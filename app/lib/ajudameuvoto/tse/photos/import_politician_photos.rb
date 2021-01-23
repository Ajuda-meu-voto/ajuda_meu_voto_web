require 'dry/transaction'
require 'zip'
require 'downloader'

class Ajudameuvoto::Tse::Photos::ImportPoliticianPhotos
  include Dry::Transaction

  URL_PHOTOS_ZIP = 'https://cdn.tse.jus.br/estatistica/sead/eleicoes/eleicoes{{YEAR}}/fotos/foto_cand{{YEAR}}_{{STATE}}_div.zip'.freeze
  TARGET_FOLDER = Rails.root.join('lib', 'assets', 'politician_photos')
  REGEX_PARSE_PHOTO_FILENAME = /^[A-Z]([A-Z]{2})(\d+)_div.*/.freeze # => [_, state, tse_candidate_number]
  TEMP_DIR = Rails.root.join('tmp')

  step :normalize_params
  step :assign_target_filename
  step :maybe_download_zip_file
  step :process_photos

  private

  def normalize_params(input)
    input[:state_shortname].upcase!

    Success(input)
  end

  def assign_target_filename(input)
    input[:target_filename] = "#{input[:state_shortname]}_#{input[:election_year]}.zip"
    input[:target_path] = "#{TARGET_FOLDER}/#{input[:target_filename]}"

    Success(input)
  end

  def maybe_download_zip_file(input)
    if File.exist?(input[:target_path])
      Rails.logger.debug "File #{input[:target_path]} exists, no need to download the zipfile"
      return Success(input)
    end

    url = URL_PHOTOS_ZIP.gsub('{{YEAR}}', input[:election_year]).gsub('{{STATE}}', input[:state_shortname])

    Rails.logger.debug "Downloading the zipfile for #{input[:target_path]} from #{url}"
    Downloader.new.download(url: url, target: input[:target_path])

    Success(input)
  end

  def process_photos(input)
    Rails.logger.debug 'Processing photos...'

    Zip::File.open(input[:target_path]) do |zipfile|
      zipfile.each do |photo_file|
        Rails.logger.debug "Processing photo file #{photo_file.name}"

        _, _state, tse_candidate_number = photo_file.name.match(REGEX_PARSE_PHOTO_FILENAME).to_a
        Rails.logger.debug "Photo parsed as TSE number: #{num}"

        politician = Ajudameuvoto::Queries::FindPoliticianByTseNumber.new.find(
          year: input[:election_year],
          tse_candidate_number: tse_candidate_number
        )

        next unless politician.present?

        Rails.logger.debug "Found politician #{politician.id}... Attaching image..."

        photo_io = extract_photo_file_to_disk(photo_file)
        add_photo_to_politician(politician, photo_io, photo_file.name)

        Rails.logger.debug 'Done.'
      end
    end

    Success(input)
  end

  def extract_photo_file_to_disk(file)
    temp_photo_path = "#{TEMP_DIR}/#{file.name}"
    File.delete(temp_photo_path) if File.exist?(temp_photo_path)

    file.extract(temp_photo_path)
    File.open(temp_photo_path, 'r')
  end

  def add_photo_to_politician(politician, file_io, file_name)
    politician.image.attach(io: file_io, filename: file_name, content_type: 'image/jpeg')
    File.delete(file_io)
  end
end
