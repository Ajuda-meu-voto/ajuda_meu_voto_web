class Ajudameuvoto::Index::IndexStates
  def call
    indexer = Ajudameuvoto::Index::IndexState.new

    State.all.each { |state| indexer.call(state: state) }
  end
end
