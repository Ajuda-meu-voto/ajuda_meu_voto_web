# Download a content from a given url and save into a target path
class Downloader
  def download(url:, target:)
    progress_bar = ProgressBar.create(title: 'Downloaded', format: '%a |%b>>%i| %p%% %t')

    download = URI.parse(url).open(
      content_length_proc: ->(total_bytes) { progress_bar.total = total_bytes if total_bytes&.positive? },
      progress_proc: lambda do |downloaded_bytes|
        progress_bar.progress = downloaded_bytes
      rescue StandardError, e
        Rails.logger.debug e
      end
    )

    IO.copy_stream(download, target)
  end
end
