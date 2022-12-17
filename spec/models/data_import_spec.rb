require 'rails_helper'

RSpec.describe DataImport, type: :model do
  let!(:role) { create :role, :user }
  let!(:user) { create :user, :user1, role_id: role.id }
  describe '#persisted' do
    it 'should return false as it tells rails that this object has no related table in our database.' do
      expect(DataImport.new.persisted?).to be false
    end
    it 'should not return true' do
      expect(DataImport.new.persisted?).to_not be true
    end
  end
end
 