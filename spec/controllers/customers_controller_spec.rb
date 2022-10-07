# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CustomersController, type: :controller do
  let!(:role) { create :role, :user }
  let!(:user) { create :user, :user1, role_id: role.id }
  before(:each) do
    @current_user = User.find_by(email: user.email)
    sign_in(@current_user)
  end
  let!(:city) { create :city, :city1, user_id: user.id }
  let!(:location1) { create :location, :location1, city_id: city.id, user_id: user.id }
  let!(:location2) { create :location, :location2, city_id: city.id, user_id: user.id }
  let!(:customer1) { create :customer, :customer1, location_id: location1.id, user_id: user.id }
  let!(:customer2) { create :customer, :customer2, location_id: location1.id, user_id: user.id }
  let!(:customer3) { create :customer, :customer3, location_id: location2.id, user_id: user.id }

  describe 'GET	/locations/:location_id/customers' do
    it 'should render index template' do
      required_params = {
        'location_id': location1.id
      }
      get :index, params: required_params
      expect(response).to render_template(:index)
    end
    it 'should assign customers variable with customers of the specific location' do
      required_params = {
        'location_id': location1.id
      }
      get :index, params: required_params
      expect(assigns(:customers)).to eq(location1.customers)
    end
    it 'should respond with http success' do
      required_params = {
        'location_id': location1.id
      }
      get :index, params: required_params
      expect(response.status).to eq(200)
    end
    it 'should raise NoMethodError' do
      required_params = {
        'location_id': ''
      }
      expect { get :index, params: required_params }.to raise_error(NoMethodError)
    end
    it 'should raise URLGeneration error' do
      required_params = {}
      expect { get :index, params: required_params }.to raise_error(ActionController::UrlGenerationError)
    end
  end

  describe 'GET	/locations/:location_id/customers/:id/edit' do
    it 'should render edit template' do
      required_params = {
        'id': customer1.id,
        'location_id': location1.id
      }
      get :edit, params: required_params
      expect(response).to render_template(:edit)
    end

    it 'should respond with http success' do
      required_params = {
        'id': customer1.id,
        'location_id': location1.id
      }
      get :edit, params: required_params
      expect(response.status).to eq(200)
    end

    it "should assign location variable as the customer's location" do
      required_params = {
        'id': customer1.id,
        'location_id': location1.id
      }
      get :edit, params: required_params
      expect(assigns(:location)).to eq(location1)
    end

    it 'should assign customer variable with the customer object being edited' do
      required_params = {
        'id': customer1.id,
        'location_id': location1.id
      }
      get :edit, params: required_params
      expect(assigns(:customer)).to eq(customer1)
    end

    it 'should raise URLGeneration error when location_id not passed' do
      required_params1 = {
        'location_id': location1.id
      }
      expect { get :edit, params: required_params1 }.to raise_error(ActionController::UrlGenerationError)
    end
    it 'should raise URLGeneration error when id not passed' do
      required_params2 = {
        'id': customer1.id
      }
      expect { get :edit, params: required_params2 }.to raise_error(ActionController::UrlGenerationError)
    end
  end

  describe 'PATCH	/locations/:location_id/customers/:id' do
    context 'successfully updates the customer' do
      it 'should redirect to customers index' do
        required_params = {
          'customer': {
            'phone': '1234876590'
          },
          'id': customer1.id,
          'location_id': location1.id
        }
        patch :update, params: required_params
        expect(response).to redirect_to location_customers_path
      end
      it 'should respond with http code 302' do
        required_params = {
          'customer': {
            'phone': '1234876590'
          },
          'id': customer1.id,
          'location_id': location1.id
        }
        patch :update, params: required_params
        expect(response.status).to eq(302)
      end
    end
    context 'not updated successfully' do
      it 'should render edit template' do
        required_params = {
          'customer': {
            'phone': ''
          },
          'id': customer1.id,
          'location_id': location1.id
        }
        patch :update, params: required_params
        expect(response).to render_template(:edit)
      end
      it 'should respond with unprocessable entity status' do
        required_params = {
          'customer': {
            'phone': ''
          },
          'id': customer1.id,
          'location_id': location1.id
        }
        patch :update, params: required_params
        expect(response.status).to eq(422)
      end
    end
    it 'should raise URLGeneration error when location_id not passed' do
      required_params1 = {
        'location_id': location1.id
      }
      expect { patch :update, params: required_params1 }.to raise_error(ActionController::UrlGenerationError)
    end
    it 'should raise URLGeneration error when id not passed' do
      required_params2 = {
        'id': customer1.id
      }
      expect { patch :update, params: required_params2 }.to raise_error(ActionController::UrlGenerationError)
    end
  end
end
