class City < ApplicationRecord
  has_many :locations, dependent: :destroy
  has_many :users, through: :locations
  validates :name, presence: true, uniqueness: true
end
