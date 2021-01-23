class Ajudameuvoto::Queries::PoliticiansFiltered
  def all(filters, limit = 100)
    query = Politician.joins(:occupations)

    query = query.where(occupations: { role_id: filters['role_id'].first }) if filters['role_id']&.first&.present?
    query = query.where(occupations: { state_id: filters['state_id'].first }) if filters['state_id']&.first&.present?
    query = query.where(ethnicity_id: filters['ethnicity_id']) if filters['ethnicity_id'].present?

    if filters['municipality_id']&.first&.present?
      query = query.where(occupations: { municipality_id: filters['municipality_id'].first })
    end

    query.order(:name).limit(limit)
  end
end
