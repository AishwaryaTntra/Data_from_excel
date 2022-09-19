# require activerecord - import
class User < ActiveRecord::Base
  belongs_to :location
  has_one :city, through: :location
  before_create :set_phone
  validates :name, :phone, :email, presence: true
  def set_phone
    phone.split('.').shift
  end
end
