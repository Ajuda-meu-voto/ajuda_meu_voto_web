require 'csv'

class Ajudameuvoto::Tse::Csv::ElectionResult::Process
  def call(csv_path:)
    Rails.logger.debug 'Abrindo arquivo'

    File.open(csv_path, 'r:iso-8859-1:utf-8') do |file|
      csv = CSV.new(file, headers: true, col_sep: ';')
      line_processor = Ajudameuvoto::Tse::Csv::ElectionResult::ProcessRow.new

      while row = csv.shift
        Rails.logger.debug "Processando linha para #{row['NR_CPF_CANDIDATO']}"
        line_processor.call(row: row)
      end
    end
  end
end
