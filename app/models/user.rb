# require activerecord - import
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :cities, dependent: :destroy
  has_many :locations
  has_many :customers
  belongs_to :role
  validates :name, :phone, :email, presence: true, uniqueness: true
  after_initialize :set_default_role

  %w[admin user].each do |role|
    define_method "#{role}?" do
      self.role == Role.find_by(name: role.titleize)
    end
  end

  private

  def set_default_role
    self.role ||= Role.find_by(name: 'User')
  end
end
