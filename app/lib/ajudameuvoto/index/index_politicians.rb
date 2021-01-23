class Ajudameuvoto::Index::IndexPoliticians
  def call
    indexer = Ajudameuvoto::Index::IndexPolitician.new
    politicians = [Politician.first]

    politicians.each { |politician| indexer.call(politician: politician) }
  end
end
