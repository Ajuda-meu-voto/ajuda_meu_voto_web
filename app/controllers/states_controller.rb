class StatesController < ApplicationController
  def show
    @state = State.find(params[:id])
    @roles = Role.all
    @ethnicities = Ethnicity.all
    @parties = Ajudameuvoto::Queries::PartiesByState.new.all(state_id: @state.id)
    @grouped = Ajudameuvoto::Queries::GroupedOccupationsPerRole.new.all(state_id: @state.id)
  end
end
