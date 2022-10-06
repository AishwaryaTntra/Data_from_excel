class Customer < ApplicationRecord
  belongs_to :location
  belongs_to :user
  validates :name, :phone, :email, presence: true
  validates_uniqueness_of :name, :email, :phone, scope: :user_id

  before_create :set_phone

  def set_phone
    phone.split('.').shift
  end
end
