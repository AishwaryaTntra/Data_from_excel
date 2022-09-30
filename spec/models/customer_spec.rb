require 'rails_helper'

RSpec.describe Customer, type: :model do
  let!(:role) { create :role, :user }
  let!(:user) { create :user, :user1, role_id: role.id }
  let!(:city) { create :city, :city1, user_id: user.id }
  let!(:location) { create :location, :location1, city_id: city.id, user_id: user.id }
  let!(:customer) { create :customer, :customer1, phone: '123456789.1', location_id: location.id, user_id: user.id }

  describe '#set_phone' do
    it 'should return the set phone number' do
      expect(customer.set_phone).to eq('123456789')
    end
  end
end