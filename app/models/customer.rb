class Customer < ApplicationRecord
  belongs_to :location
  belongs_to :user

  def set_phone
    phone.split('.').shift
  end
end
