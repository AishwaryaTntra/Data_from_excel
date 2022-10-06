require 'rails_helper'

RSpec.describe Message, type: :model do
  let!(:role) { create :role, :user }
  let!(:user) { create :user, :user1, role_id: role.id }
  let!(:city) { create :city, :city1, user_id: user.id }
  let!(:location) { create :location, :location1, city_id: city.id, user_id: user.id }
  let!(:message) { create :message, :message1, location_id: location.id, created_at: Time.zone.local(2022, 9, 30) }
  describe '#formatted_created_at' do
    it 'should return formatted created at' do
      expect(message.formatted_created_at).to eq('30 Sep, 2022 12:00:00 AM')
    end
  end
end
