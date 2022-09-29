class Customer < ApplicationRecord
  belongs_to :location
  belongs_to :user
  validates :name, :phone, :email, presence: true, uniqueness: true

  before_create :set_phone

  def set_phone
    phone.split('.').shift
  end
end
