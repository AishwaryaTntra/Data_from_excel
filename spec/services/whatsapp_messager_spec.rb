# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WhatsappMessager, type: :model do
  let!(:role) { create :role, :user }
  let!(:user) { create :user, :user1, role_id: role.id }
  let!(:city) { create :city, :city1, user_id: user.id }
  let!(:location1) { create :location, :location1, city_id: city.id, user_id: user.id }
  let!(:customer1) { create :customer, :customer1, location_id: location1.id, user_id: user.id }
  let!(:customer2) { create :customer, :customer2, location_id: location1.id, user_id: user.id }
  let!(:message) { create :message, :message1, location_id: location1.id }
  describe '#send_message' do
    context 'it sends whastapp message' do
      it "should have response with message 'ok'" do
        response = JSON.parse(WhatsappMessager.new(message).send_message(customer1).body)
        expect(response['message']).to eq('ok')
      end
      it 'should have response with sent value true' do
        response = JSON.parse(WhatsappMessager.new(message).send_message(customer1).body)
        expect(response['sent']).to eq('true')
      end
    end

    it 'should raise Argument error when receiver is not present' do
      expect { WhatsappMessager.new(message).send_message }.to raise_error(ArgumentError)
    end
  end

  describe '#find_customers' do
    context ' it calls send_message method indiviually on all the customers of a location' do
      it 'should have response equal to array of customers of that location' do
        response = WhatsappMessager.new(message).find_customers
        expect(response).to eq([customer1, customer2])
      end
      it 'should have response which is an array' do
        response = WhatsappMessager.new(message).find_customers
        expect(response.is_a?(Array)).to be true
      end
      it 'should not return an empty response' do
        response = WhatsappMessager.new(message).find_customers
        expect(response.empty?).to be false
      end
    end
  end
end
