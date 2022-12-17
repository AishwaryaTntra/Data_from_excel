# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

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
  describe '#abilites' do
    context 'The visitor is an admin' do
      let!(:admin_role) { create :role, :admin }
      let!(:admin_user) { create :user, :user2, role_id: admin_role.id }
      it 'should allow admin to manage all the actions for User model' do
        ability = Ability.new(admin_user)
        expect(ability).to be_able_to(:manage, User.new)
      end
      it 'should allow admin to manage all the actions for City model' do
        ability = Ability.new(admin_user)
        expect(ability).to be_able_to(:manage, City.new)
      end
      it 'should allow admin to manage all the actions for Location model' do
        ability = Ability.new(admin_user)
        expect(ability).to be_able_to(:manage, Location.new)
      end
      it 'should allow admin to manage all the actions for Message model' do
        ability = Ability.new(admin_user)
        expect(ability).to be_able_to(:manage, Message.new)
      end
      it 'should allow admin to manage all the actions for Customer model' do
        ability = Ability.new(admin_user)
        expect(ability).to be_able_to(:manage, Customer.new)
      end
    end
    context 'The visitor is a user' do
      let!(:second_user) { create :user, :user2, role_id: role.id }
      let!(:city1) { create :city, :city1, user_id: user.id }
      let!(:location1) { create :location, :location1, city_id: city1.id, user_id: user.id }
      let!(:message1) { create :message, :message1, location_id: location1.id }
      let!(:customer1) { create :customer, :customer1, location_id: location1.id, user_id: user.id }
      let!(:city2) { create :city, :city2, user_id: second_user.id }
      let!(:location2) { create :location, :location2, city_id: city2.id, user_id: second_user.id }
      let!(:message2) { create :message, :message2, location_id: location2.id }
      let!(:customer2) { create :customer, :customer2, location_id: location2.id, user_id: second_user.id }

      it 'should not allow user to manage all the actions for User model' do
        ability = Ability.new(user)
        expect(ability).to_not be_able_to(:manage, User.new)
      end
      it 'should allow user to create an instance of all the models' do
        ability = Ability.new(user)
        actions = %i[new create]
        expect(ability).to be_able_to(actions, :all)
      end
      it 'should allow user to manage all the actions for the city that belongs to user' do
        ability = Ability.new(user)
        actions = %i[edit update destroy]
        expect(ability).to be_able_to(actions, city1)
      end
      it 'should not allow user to edit the city that does not belongs to the user' do
        ability = Ability.new(user)
        actions = %i[edit update destroy]
        expect(ability).to_not be_able_to(actions, city2)
      end
      it 'should allow user to manage all the actions for location that belongs to user' do
        ability = Ability.new(user)
        actions = %i[edit update destroy]
        expect(ability).to be_able_to(actions, location1)
      end
      it 'should not allow user to manage any action for the location that does not belongs to the user' do
        ability = Ability.new(user)
        actions = %i[edit update destroy]
        expect(ability).to_not be_able_to(actions, location2)
      end
      it 'should allow user to manage all the actions for message that belongs to user' do
        ability = Ability.new(user)
        actions = %i[edit update destroy]
        expect(ability).to be_able_to(actions, message1)
      end
      it 'should not allow user to manage any action for the message that does not belongs to the user' do
        ability = Ability.new(user)
        actions = %i[edit update destroy]
        expect(ability).to_not be_able_to(actions, message2)
      end
      it 'should allow user to manage all the actions for customer that belongs to user' do
        ability = Ability.new(user)
        actions = %i[edit update destroy]
        expect(ability).to be_able_to(actions, customer1)
      end
      it 'should not allow user to manage any action for the customer that does not belongs to the user' do
        ability = Ability.new(user)
        actions = %i[edit update destroy]
        expect(ability).to_not be_able_to(actions, customer2)
      end
    end
  end
end
