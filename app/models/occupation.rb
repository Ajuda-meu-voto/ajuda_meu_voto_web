class Occupation < ActiveRecord::Base
  self.table_name = 'politician_occupations'

  belongs_to :politician
  belongs_to :role
  belongs_to :municipality
  belongs_to :state
  belongs_to :party

  scope :current, -> { order(year: :desc).limit(1).first }
end
