class Location < ApplicationRecord
  belongs_to :city
  has_many :customers, dependent: :destroy
  has_many :messages, dependent: :destroy
  belongs_to :user
  validates :name, presence: true, uniqueness: true
end
