class Ajudameuvoto::Index::IndexParties
  def call
    indexer = Ajudameuvoto::Index::IndexParty.new

    Party.all.each { |party| indexer.call(party: party) }
  end
end
