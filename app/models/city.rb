class City < ApplicationRecord
  belongs_to :user
  has_many :locations, dependent: :destroy
  has_many :customers, through: :locations
  validates :name, presence: true, uniqueness: true
end
