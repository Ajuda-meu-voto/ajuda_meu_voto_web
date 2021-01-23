class Ajudameuvoto::Index::Client
  def initialize
    @elastic =
      ::Elasticsearch::Client.new(url: 'http://127.0.0.1:9200', log: true)
  end

  def index(*args, **kw)
    @elastic.index(*args, **kw)
  end

  def search(*args, **kw)
    @elastic.search(*args, **kw)
  end
end
