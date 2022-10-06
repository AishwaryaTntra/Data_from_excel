# frozen_string_literal: true

# app > models > role
class Role < ApplicationRecord
  validates :name, presence: true
  has_many :users
end
