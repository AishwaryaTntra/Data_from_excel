# require activerecord - import
class User < ActiveRecord::Base
  has_many :cities
  has_many :locations
  has_many :customers
  before_create :set_phone
  validates :name, :phone, :email, presence: true
end
