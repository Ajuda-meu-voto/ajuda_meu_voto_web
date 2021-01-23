require 'dry-struct'

class Ajudameuvoto::Queries::FetchHelpMeQuestion
  module Types
    include Dry.Types
  end

  class HelpMeQuestionOptions < Dry::Struct
    attribute :title, Types::String
    attribute :id, Types::Integer
  end

  class HelpMeQuestion < Dry::Struct
    attribute :filter, Types::String
    attribute :title, Types::String
    attribute :type, Types::String.enum('single-choice', 'multiple-choice')
    attribute :options, Types::Array.of(HelpMeQuestionOptions).default([])
    attribute :options_config, Types::Hash.default({})
  end

  def initial
    {
      position: 1,
      question: fetch_question(position: 0)
    }
  end

  def next(opts)
    last_position = opts[:last_position].blank? ? -1 : opts[:last_position].to_i

    next_position = last_position + 1

    { position: next_position, question: fetch_question(position: next_position, user_filters: opts[:user_filters]) }
  end

  private

  def fetch_question(position:, user_filters: {})
    question = questions[position]

    return if question.blank?

    process_options(question, user_filters)
  end

  def process_options(question, user_filters)
    return question if question.options_config.blank?

    options_query = question.options_config[:repository].constantize

    if question.options_config[:filter].present?
      question.options_config[:filter].each do |filter|
        options_query = options_query.where(filter => user_filters[filter])
      end
    end

    new_options = options_query.all.map do |o|
      { id: o.id, title: o&.name || o&.title }
    end

    new_options.sort_by! { |i| i[:title] }

    HelpMeQuestion.new(
      title: question.title,
      filter: question.filter,
      type: question.type,
      options: new_options + question.options
    )
  end

  def questions
    [
      HelpMeQuestion.new(
        title: 'Qual cargo você quer votar?',
        filter: 'role_id',
        type: 'single-choice',
        options_config: { repository: 'Role' }
      ),
      HelpMeQuestion.new(
        title: 'Qual estado?',
        filter: 'state_id',
        type: 'single-choice',
        options_config: { repository: 'State' }
      ),
      HelpMeQuestion.new(
        title: 'Qual município?',
        filter: 'municipality_id',
        type: 'single-choice',
        options_config: { repository: 'Municipality', filter: ['state_id'] }
      ),
      HelpMeQuestion.new(
        title: 'Alguma etinia?',
        filter: 'ethnicity_id',
        type: 'multiple-choice',
        options_config: { repository: 'Ethnicity' }
      )
    ]
  end
end
