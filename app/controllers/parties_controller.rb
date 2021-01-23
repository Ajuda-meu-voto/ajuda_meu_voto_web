class PartiesController < ApplicationController
  def show
    @party = Ajudameuvoto::Queries::FetchParty.new.first!(party_id: params[:id])
  end
end
