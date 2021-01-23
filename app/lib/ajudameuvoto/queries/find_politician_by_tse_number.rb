class Ajudameuvoto::Queries::FindPoliticianByTseNumber
  def find(year:, tse_candidate_number:)
    Politician.joins(:occupations).where(occupations: { year: year, tse_candidate_number: tse_candidate_number }).first
  end
end
