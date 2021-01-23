class AjudameuvotoController < ApplicationController
  def index
    @question = Ajudameuvoto::Queries::FetchHelpMeQuestion.new.initial[:question]
    @position = 0
  end
end
