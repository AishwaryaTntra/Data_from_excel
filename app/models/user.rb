# require activerecord - import
class User < ActiveRecord::Base
  has_many :cities
  has_many :locations
  has_many :customers
  validates :name, :phone, :email, presence: true
end
