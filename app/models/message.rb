class Message < ApplicationRecord
  belongs_to :location
  has_many :users, through: :location
  validates :body, :title, presence: true

  def formatted_created_at
    created_at.strftime('%d %b, %Y %r')
  end
end
