# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CitiesController, type: :controller do
  let!(:role) { create :role, :user }
  let!(:user1) { create :user, :user1, role_id: role.id }
  let!(:user2) { create :user, :user2, role_id: role.id }
  before(:each) do
    @current_user = User.find_by(email: user1.email)
    sign_in(@current_user)
  end
  let!(:city1) { create :city, :city1, user_id: @current_user.id }
  let!(:city2) { create :city, :city2, user_id: @current_user.id }
  describe 'GET	/cities' do
    let!(:city3) { create :city, :city3, user_id: user2.id }
    it 'should return http success' do
      get :index
      expect(response.status).to eq(200)
    end
    it 'should render index template' do
      get :index
      expect(response).to render_template(:index)
    end
    it "assigns cities variables with user's cities" do
      get :index
      expect(assigns(:cities)).to eq([city1, city2])
    end
  end

  describe 'GET	/cities/new' do
    let!(:city) { build :city, :city3, user_id: @current_user.id }
    it 'should render new template' do
      get :new
      expect(response.status).to be(200)
    end
    it 'should respond with http success' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST /cities' do
    context 'if the city is saved' do
      it 'should redirect to citiex index path' do
        required_params = {
          'city': {
            'name': 'TestCity',
            'user_id': @current_user.id
          }
        }
        post :create, params: required_params
        expect(response).to redirect_to cities_path
      end
      it 'should return http code 302' do
        required_params = {
          'city': {
            'name': 'TestCity',
            'user_id': @current_user.id
          }
        }
        post :create, params: required_params
        expect(response.status).to eq(302)
      end
    end
    context 'if the city is not saved' do
      it 'should render new template' do
        required_params = {
          'city': {
            'name': ''
          }
        }
        post :create, params: required_params
        expect(response.status).to eq(422)
      end
      it 'should respond with unprocessable status' do
        required_params = {
          'city': {
            'name': ''
          }
        }
        post :create, params: required_params
        expect(response.status).to eq(422)
      end
    end
    it 'should raise missing parameter error' do
      required_params = {
        'city': {}
      }
      expect { post :create, params: required_params }.to raise_error(ActionController::ParameterMissing)
    end
  end

  describe 'GET	/cities/:id/edit' do
    it 'should render edit template' do
      required_params = {
        "id": city1.id
      }
      get :edit, params: required_params
      expect(response).to render_template(:edit)
    end
    it 'should return http success' do
      required_params = {
        "id": city1.id
      }
      get :edit, params: required_params
      expect(response.status).to eq(200)
    end

    it 'should raise URLGeneration error' do
      expect { get :edit }.to raise_error(ActionController::UrlGenerationError)
    end

    it 'should raise record not found error when wrong id passed' do
      required_params = {
        'id': 2_654_918_469_546
      }
      expect { get :edit, params: required_params }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'PATCH	/cities/:id' do
    let!(:test_city) { create :city, name: 'Test city1', user: @current_user }
    context 'the city is updated' do
      name = 'Test city 1'
      it 'should redirect to city path with updated city' do
        required_params = {
          "city": {
            "name": name
          },
          "id": city1.id
        }
        patch :update, params: required_params
        expect(response).to redirect_to cities_path
      end
      it 'should return with http code 302' do
        required_params = {
          "city": {
            "name": name
          },
          "id": city1.id
        }
        patch :update, params: required_params
        expect(response.status).to be(302)
      end

      it 'should assign city variable with the city to be updated' do
        required_params = {
          "city": {
            "name": name
          },
          "id": city1.id
        }
        patch :update, params: required_params
        expect(assigns(:city)).to eq(city1)
      end
    end

    context 'the city is not updated' do
      it 'should render new with unprocessable entity status' do
        required_params = {
          'city': {
            'name': ''
          },
          'id': city1.id
        }
        patch :update, params: required_params
        expect(response).to render_template(:edit)
      end
      it 'should return with unprocessable entity status' do
        required_params = {
          'city': {
            'name': ''
          },
          'id': city1.id
        }
        patch :update, params: required_params
        expect(response.status).to be(422)
      end
    end

    it 'should raise missing parameter error' do
      required_params = {
        'city': {},
        'id': city1.id
      }
      expect { patch :update, params: required_params }.to raise_error(ActionController::ParameterMissing)
    end
    it 'should raise url generation error' do
      required_params = {
        'city': {
          'name': 'Test User'
        }
      }
      expect { patch :update, params: required_params }.to raise_error(ActionController::UrlGenerationError)
    end
  end

  describe 'DELETE	/cities/:id' do
    it 'should redirect to city index' do
      required_params = {
        'id': city2.id
      }
      delete :destroy, params: required_params
      expect(response).to redirect_to cities_path
    end
    it 'should respond with http code 303 ' do
      required_params = {
        'id': city2.id
      }
      delete :destroy, params: required_params
      expect(response.status).to be(303)
    end
    it 'should raise nomethod error when nil id passed' do
      required_params = {
        'id': ''
      }
      expect { delete :destroy, params: required_params }.to raise_error(NoMethodError)
    end
    it 'should raise URLGeneration error when no id passed' do
      required_params = {}
      expect { delete :destroy, params: required_params }.to raise_error(ActionController::UrlGenerationError)
    end
  end
end
