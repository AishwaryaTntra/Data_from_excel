class City < ApplicationRecord
  belongs_to :user
  has_many :locations, dependent: :destroy
  has_many :customers, through: :locations
  validates :name, presence: true
  validate :no_duplicate_location
  def no_duplicate_location
    self.locations = locations.uniq
  end
end
