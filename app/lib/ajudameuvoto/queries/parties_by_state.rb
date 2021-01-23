class Ajudameuvoto::Queries::PartiesByState
  def all(state_id:)
    Party
      .select("DISTINCT(parties.name) as name, parties.*")
      .joins(:occupations)
      .where(occupations: { state_id: state_id })
      .all
  end
end
