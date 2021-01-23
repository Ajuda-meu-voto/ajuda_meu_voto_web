require 'dry-struct'

class Ajudameuvoto::Queries::GroupedOccupationsPerRole
  module Types
    include Dry.Types
  end

  class GroupedOccupationsPerRole < Dry::Struct
    attribute :party_id, Types::Integer
    attribute :role_id, Types::Integer
    attribute :ethnicity_id, Types::Integer
    attribute :amount, Types::Integer
  end

  def all(state_id:)
    results = Occupation
              .select(
                'politician_occupations.party_id',
                'politician_occupations.role_id',
                'politicians.ethnicity_id',
                'count(*) as amount'
              )
              .joins(:politician)
              .group('politician_occupations.party_id', 'politician_occupations.role_id', 'politicians.ethnicity_id')
              .where('politician_occupations.state_id = ?', state_id)
              .as_json

    grouped = {}

    results.each do |result|
      grouped[result['party_id']] = {} if grouped[result['party_id']].blank?
      grouped[result['party_id']][result['role_id']] = {} if grouped[result['party_id']][result['role_id']].blank?
      grouped[result['party_id']][result['role_id']][result['ethnicity_id']] =
        GroupedOccupationsPerRole.new(
          party_id: result['party_id'],
          role_id: result['role_id'],
          ethnicity_id: result['ethnicity_id'],
          amount: result['amount']
        )
    end

    grouped
  end
end
