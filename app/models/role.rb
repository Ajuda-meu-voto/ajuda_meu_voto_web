class Role < ActiveRecord::Base
  VICE_MAYOR = 'vice-prefeito'.freeze

  scope :vice_mayor, -> { find_by(name: VICE_MAYOR) }
end
