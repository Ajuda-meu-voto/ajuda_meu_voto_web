class PoliticiansController < ApplicationController
  def show
    @politician = Politician.find(params[:id])
  end

  def index
    @politicians = Ajudameuvoto::Queries::PoliticiansFiltered.new.all(index_filters)
  end

  private

  def index_filters
    params.required(:filters)
  end
end
