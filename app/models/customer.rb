class Customer < ApplicationRecord
  belongs_to :location
  belongs_to :user

  before_create :set_phone

  def set_phone
    phone.split('.').shift
  end
end
