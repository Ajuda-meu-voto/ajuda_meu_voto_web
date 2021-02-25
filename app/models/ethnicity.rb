class Ethnicity < ActiveRecord::Base
  OTHER = 'other'.freeze

  scope :other, -> { find_by(name: OTHER) }
end
