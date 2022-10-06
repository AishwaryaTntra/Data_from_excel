# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:role) { create :role, :user }
  let!(:user) { create :user, :user1, role_id: role.id }
  describe '#admin?' do
    let!(:admin_role) { create :role, :admin }
    let!(:admin) { create :user, :user2, role_id: admin_role.id }
    it 'should return true if the user is admin' do
      expect(admin.admin?).to be true
    end
    it 'should return false if the user is not an admin' do
      expect(user.admin?).to be false
    end
  end
  describe '#user?' do
    let!(:admin_role) { create :role, :admin }
    let!(:admin) { create :user, :user2, role_id: admin_role.id }
    it 'should return true if the user is not an admin' do
      expect(user.user?).to be true
    end
    it 'should return false if the user is  an admin' do
      expect(admin.user?).to be false
    end
  end
end
