class Location < ApplicationRecord
  belongs_to :city
  has_many :users, dependent: :destroy
  has_many :messages, dependent: :destroy
  validates :name, presence: true, uniqueness: true
end
