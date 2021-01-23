class Ajudameuvoto::Queries::FetchParty
  def first!(party_id:)
    Party
      .joins(occupations: %i[municipality state role party politician])
      .includes(occupations: %i[municipality state role party politician])
      .where(id: party_id)
      .first!
  end
end
