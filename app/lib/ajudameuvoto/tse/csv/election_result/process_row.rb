require 'dry/transaction'

class Ajudameuvoto::Tse::Csv::ElectionResult::ProcessRow
  include Dry::Transaction

  step :assign_politician_values
  step :assign_election_values
  step :check_elected
  step :maybe_create_party
  step :maybe_create_role
  step :maybe_create_ethnicity
  step :maybe_create_state
  step :maybe_create_municipality
  step :update_or_create_politician
  step :maybe_add_politician_occupation
  step :do_index

  private

  def assign_politician_values(input)
    input[:politician_data] = row_parser.parse_politician(input[:row])

    Success(input)
  end

  def assign_election_values(input)
    input[:election_result_data] = row_parser.parse_election_result(input[:row])

    Success(input)
  end

  def check_elected(input)
    return Success(input) if input[:election_result_data][:elected?]

    Failure("Candidate cpf: #{input[:politician_data][:cpf]} did not get elected. Skipping...")
  end

  def maybe_create_party(input)
    input[:party] = Party.find_by(shortname: input[:election_result_data][:party][:shortname])
    input[:party] = Party.create(input[:election_result_data][:party]) unless input[:party]

    Success(input)
  end

  def maybe_create_role(input)
    input[:role] = Role.find_by(name: input[:election_result_data][:role])
    input[:role] = Role.create(name: input[:election_result_data][:role]) unless input[:role]

    Success(input)
  end

  def maybe_create_ethnicity(input)
    ethnicity = Ethnicity.find_by(name: input[:politician_data][:ethnicity])
    ethnicity ||= Ethnicity.create(name: input[:politician_data][:ethnicity])

    input[:politician_data][:ethnicity] = ethnicity

    Success(input)
  end

  def maybe_create_state(input)
    input[:state] = State.find_by(name: input[:election_result_data][:state])
    input[:state] = State.create(name: input[:election_result_data][:state]) unless input[:state]

    Success(input)
  end

  def maybe_create_municipality(input)
    input[:municipality] =
      Municipality.find_by(name: input[:election_result_data][:municipality], state_id: input[:state].id)

    unless input[:municipality]
      input[:municipality] =
        Municipality.create(name: input[:election_result_data][:municipality], state_id: input[:state].id)
    end

    Success(input)
  end

  def update_or_create_politician(input)
    politician = Politician.find_by(cpf: input[:politician_data][:cpf])

    input[:politician] = if politician
                           politician.update(input[:politician_data])
                           politician
                         else
                           Politician.create(input[:politician_data])
                         end

    Success(input)
  end

  def maybe_add_politician_occupation(input)
    input[:occupation] =
      Occupation.find_by(politician_id: input[:politician].id, year: input[:election_result_data][:year],
                         role_id: input[:role].id)

    unless input[:occupation]
      input[:occupation] = input[:politician].occupations << Occupation.new(
        year: input[:election_result_data][:year],
        role_id: input[:role].id,
        state_id: input[:state].id,
        municipality_id: input[:municipality].id,
        party_id: input[:party].id,
        tse_ue: input[:election_result_data][:tse_ue],
        tse_candidate_number: input[:election_result_data][:tse_candidate_number]
      )
    end

    Success(input)
  end

  def do_index(input)
    Ajudameuvoto::Index::IndexParty.new.call(party: input[:party])
    Ajudameuvoto::Index::IndexState.new.call(state: input[:state])
    Ajudameuvoto::Index::IndexPolitician.new.call(politician: input[:politician])

    Success(input)
  end

  def row_parser
    @row_parser ||= Ajudameuvoto::Tse::Csv::ElectionResult::RowParser.new
  end
end
