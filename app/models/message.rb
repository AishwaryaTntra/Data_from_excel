# frozen_string_literal: true

# app > models > message
class Message < ApplicationRecord
  belongs_to :location
  has_many :customers, through: :location
  validates :body, :title, presence: true

  def formatted_created_at
    created_at.strftime('%d %b, %Y %r')
  end
end
