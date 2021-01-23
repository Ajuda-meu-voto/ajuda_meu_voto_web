require 'elasticsearch'

class Ajudameuvoto::Index::IndexPolitician
  def call(politician:)
    client.index(
      index: 'politicians',
      id: politician.id,
      body: { name: politician.name, nickname: politician.nickname }
    )
  end

  private

  def client
    @client ||= Ajudameuvoto::Index::Client.new
  end
end
