class Ajudameuvoto::Queries::PoliticiansFiltered
  def all(filters, limit = 100)
    query = Politician.joins(:occupations).includes(:image_attachment)
    query = apply_role_filter(query, filters['role_id'])
    query = apply_state_filter(query, filters['state_id'])
    query = apply_ethnicity_filter(query, filters['ethnicity_id'])
    query = apply_municipality_filter(query, filters['municipality_id'])
    query.order(:name).limit(limit)
  end

  private

  def apply_role_filter(query, ids = [])
    return query.where(occupations: { role_id: ids.first }) if ids&.first&.present?

    query
  end

  def apply_state_filter(query, ids = [])
    return query.where(occupations: { state_id: ids.first }) if ids&.first&.present?

    query
  end

  def apply_ethnicity_filter(query, ids = [])
    return query.where(ethnicity_id: ids) if ids.present?

    query
  end

  def apply_municipality_filter(query, ids = [])
    return query.where(occupations: { municipality_id: ids }) if ids.present?

    query
  end
end
