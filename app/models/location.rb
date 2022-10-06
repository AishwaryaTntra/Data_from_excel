# frozen_string_literal: true

# app > models > location
class Location < ApplicationRecord
  belongs_to :city
  has_many :customers, dependent: :destroy
  has_many :messages, dependent: :destroy
  belongs_to :user
  validates :name, presence: true
  validates_uniqueness_of :name, scope: %i[city_id user_id]
end
