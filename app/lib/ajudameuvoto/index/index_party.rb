require 'elasticsearch'

class Ajudameuvoto::Index::IndexParty
  def call(party:)
    client.index(
      index: 'parties',
      id: party.id,
      body: { name: party.name, shortname: party.shortname }
    )
  end

  private

  def client
    @client ||= Ajudameuvoto::Index::Client.new
  end
end
