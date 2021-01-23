class Api::SearchController < ApplicationController
  def index
    result = ::Ajudameuvoto::Index::Client.new.search(q: search_params)

    categories = {}

    result['hits']['hits'].each do |row|
      if categories[row['_index']].nil?
        categories[row['_index']] = { name: row['_index'], results: [] }
      end

      result_row = { title: row['_source']['name'], url: url_for(row) }
      categories[row['_index']][:results].push(result_row)
    end

    render json: { results: categories }
  end

  private

  def search_params
    params.required(:q)
  end

  def url_for(result_row)
    if result_row['_index'] == 'states'
      state_path(id: result_row['_id'])
    elsif result_row['_index'] == 'politicians'
      politician_path(id: result_row['_id'])
    elsif result_row['_index'] == 'parties'
      party_path(id: result_row['_id'])
    end
  end
end
