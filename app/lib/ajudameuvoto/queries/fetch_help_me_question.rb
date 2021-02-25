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
    { position: 1, question: fetch_question }
  end

  def next(after_position: -1, user_filters: {})
    next_position = after_position.to_i + 1

    { position: next_position, question: fetch_question(position: next_position, user_filters: user_filters) }
  end

  private

  def fetch_question(position: 0, user_filters: {})
    question = questions[position]

    return if question.blank?

    populate_options(question, user_filters) if populate_options?(question)
  end

  def populate_options(question, user_filters)
    new_options = build_question_options(question, repository: question_options_repository(question),
                                                   user_filters: user_filters)

    HelpMeQuestion.new(
      title: question.title,
      filter: question.filter,
      type: question.type,
      options: new_options + question.options
    )
  end

  def build_question_options(question, repository:, user_filters:)
    repository = apply_filters(question, repository: repository, user_filters: user_filters)
    repository = apply_hides(question, repository: repository)

    new_options = repository.all.map do |o|
      { id: o.id, title: o&.name || o&.title }
    end

    new_options.sort_by { |i| i[:title] }
  end

  def apply_filters(question, repository:, user_filters:)
    question.options_config.fetch(:filter, []).each do |filter|
      repository = repository.where(filter => user_filters[filter])
    end
    repository
  end

  def apply_hides(question, repository:)
    ids_to_hide = question.options_config[:hide] || []
    repository.where.not(id: ids_to_hide)
  end

  def populate_options?(question)
    question.options_config.present?
  end

  def question_options_repository(question)
    question.options_config[:repository].constantize
  end

  def questions
    [
      HelpMeQuestion.new(
        title: 'Qual cargo você quer votar?',
        filter: 'role_id',
        type: 'single-choice',
        options_config: { repository: 'Role', hide: [Role.vice_mayor.id] }
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
        title: 'Alguma etnia?',
        filter: 'ethnicity_id',
        type: 'multiple-choice',
        options_config: { repository: 'Ethnicity', hide: [Ethnicity.other.id] }
      )
    ]
  end
end
