require 'rails_helper'

RSpec.describe City, type: :model do
  let!(:role) { create :role, :user }
  let!(:user) { create :user, :user1, role_id: role.id }
  let!(:city) { create :city, :city1, user_id: user.id }
  describe '#no_duplicate_location' do
    it 'should return nil if city has no location' do
      expect(city.no_duplicate_location).to be_nil
    end
    context 'city has multiple locations' do
      let!(:location1) { create :location, :location1, city: city, user: user }
      let!(:location2) { create :location, :location2, city: city, user: user }
      it 'should return uniq list of locations' do
        city.locations << Location.first
        expect(city.no_duplicate_location).to eq([location1, location2])
      end
    end
  end
end
