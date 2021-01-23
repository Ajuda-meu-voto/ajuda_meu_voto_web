class Api::HelpMeAnswersController < ApplicationController
  def create
    session[:help_me_answers] = {} if session[:help_me_answers].blank?
    session[:help_me_answers].merge!(Hash[create_params[:question][:filter], params[:answer]])

    question =
      ::Ajudameuvoto::Queries::FetchHelpMeQuestion.new.next(
        last_position: create_params[:question][:position],
        user_filters: session[:help_me_answers]
      )

    if question[:question].blank?
      url_result = politicians_path(filters: session[:help_me_answers])

      session[:help_me_answers] = nil
      render json: question.merge(url_result: url_result)
    else
      render json: question
    end
  end

  private

  def create_params
    params.permit(:answer, question: %i[position filter])
  end
end
