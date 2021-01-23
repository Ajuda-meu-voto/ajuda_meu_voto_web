class Politician < ActiveRecord::Base
  has_many :occupations
  belongs_to :ethnicity
  has_one_attached :image

  def current_occupation
    occupations.current
  end
end
