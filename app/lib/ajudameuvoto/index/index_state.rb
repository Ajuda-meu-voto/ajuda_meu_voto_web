require 'elasticsearch'

class Ajudameuvoto::Index::IndexState
  def call(state:)
    client.index(index: 'states', id: state.id, body: { name: state.name })
  end

  private

  def client
    @client ||= Ajudameuvoto::Index::Client.new
  end
end
