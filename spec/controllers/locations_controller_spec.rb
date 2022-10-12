# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LocationsController, type: :controller do
  let!(:role) { create :role, :user }
  let!(:user1) { create :user, :user1, role_id: role.id }
  let!(:user2) { create :user, :user2, role_id: role.id }
  before(:each) do
    @current_user = User.find_by(email: user1.email)
    sign_in(@current_user)
  end
  let!(:city1) { create :city, :city1, user_id: @current_user.id }
  let!(:location1) { create :location, :location1, city_id: city1.id, user_id: @current_user.id }
  let!(:location2) { create :location, :location2, city_id: city1.id, user_id: @current_user.id }
  describe 'GET	/cities/:city_id/locations' do
    it 'should return http success' do
      required_params = {
        'city_id': city1.id
      }
      get :index, params: required_params
      expect(response.status).to eq(200)
    end

    it 'should return render index template' do
      required_params = {
        'city_id': city1.id
      }
      get :index, params: required_params
      expect(response).to render_template(:index)
    end

    it 'should assigns locations value to the list of locations for the city' do
      required_params = {
        'city_id': city1.id
      }
      get :index, params: required_params
      expect(assigns(:locations)).to eq([location1, location2])
    end
  end

  describe 'GET	/cities/:city_id/locations/new' do
    it 'should render new successfully' do
      required_params = {
        'city_id': city1.id
      }
      get :new, params: required_params
      expect(response).to render_template(:new)
    end
    it 'should return http success' do
      required_params = {
        'city_id': city1.id
      }
      get :new, params: required_params
      expect(response.status).to be(200)
    end
  end

  describe 'POST	/cities/:city_id/locations' do
<<<<<<< HEAD
    context 'the location is saved' do
=======

>>>>>>> c9e8669026e593562deb35720c70556f9871d51f
      it 'should redirect to location index' do
        required_params = {
          'location': {
            'name': 'TestLocation',
            'user_id': @current_user.id
          },
          'city_id': city1.id
        }
        post :create, params: required_params
        expect(response).to redirect_to city_locations_path
      end
      it 'should respond with http code 302' do
        required_params = {
          'location': {
            'name': 'TestLocation',
            'user_id': @current_user.id
          },
          'city_id': city1.id
        }
        post :create, params: required_params
        expect(response.status).to eq(302)
      end
    end
    context 'Location is not saved' do
      it 'should render new template ' do
        required_params = {
          'location': {
            'name': '',
            'user_id': @current_user.id
          },
          'city_id': city1.id
        }
        post :create, params: required_params
        expect(response).to render_template(:new)
      end

      it 'should respond with unprocessable entity' do
        required_params = {
          'location': {
            'name': '',
            'user_id': @current_user.id
          },
          'city_id': city1.id
        }
        post :create, params: required_params
        expect(response.status).to eq(422)
      end
    end
    it 'should raise missing parameter error' do
      required_params = {
        'location': {}
      }
      expect { post :create, params: required_params }.to raise_error(ActionController::ParameterMissing)
    end
  end

  describe 'GET	/cities/:city_id/locations/:id/edit' do
    it 'should return http success' do
      required_params = {
        "city_id": city1.id,
        'id': location1.id
      }
      get :edit, params: required_params
      expect(response.status).to eq(200)
    end
    it 'should render edit template' do
      required_params = {
        "city_id": city1.id,
        'id': location1.id
      }
      get :edit, params: required_params
      expect(response).to render_template(:edit)
    end

    it 'should raise URLGeneration error' do
      expect { get :edit }.to raise_error(ActionController::UrlGenerationError)
    end

    it 'should raise record not found error when wrong id passed' do
      required_params = {
        'id': 2654,
        'city_id': city1.id
      }
      expect { get :edit, params: required_params }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'PATCH	/cities/:city_id/locations/:id' do
    context 'the location is updated' do
      name = 'Test Location'
      it 'should return http code 302' do
        required_params = {
          "location": {
            "name": name
          },
          "id": location1.id,
          'city_id': city1.id
        }
        patch :update, params: required_params
        expect(response.status).to be(302)
      end
      it 'should redirect to locations index' do
        required_params = {
          "location": {
            "name": name
          },
          "id": location1.id,
          'city_id': city1.id
        }
        patch :update, params: required_params
        expect(response).to redirect_to city_locations_path
      end
      it 'should assign location variable with the location to be updated' do
        required_params = {
          "location": {
            "name": name
          },
          "id": location1.id,
          'city_id': city1.id
        }
        patch :update, params: required_params
        expect(assigns(:location)).to eq(location1)
      end
    end

    context 'the location is not updated' do
      it 'should render edit template' do
        required_params = {
          'location': {
            'name': ''
          },
          'id': location1.id,
          'city_id': city1.id
        }
        patch :update, params: required_params
        expect(response).to render_template(:edit)
      end

      it 'should respond with unprocessable entity status' do
        required_params = {
          'location': {
            'name': ''
          },
          'id': location1.id,
          'city_id': city1.id
        }
        patch :update, params: required_params
        expect(response.status).to be(422)
      end
    end

    it 'should raise missing parameter error' do
      required_params = {
        'location': {},
        'city_id': city1.id,
        'id': location1.id
      }
      expect { patch :update, params: required_params }.to raise_error(ActionController::ParameterMissing)
    end
    it 'should raise url generation error' do
      required_params = {
        'location': {
          'name': 'Test Location'
        }
      }
      expect { patch :update, params: required_params }.to raise_error(ActionController::UrlGenerationError)
    end
  end

  describe 'DELETE	/cities/:city_id/locations/:id' do
    it 'should return http code 303' do
      required_params = {
        'city_id': city1.id,
        'id': location1.id
      }
      delete :destroy, params: required_params
      expect(response.status).to be(303)
    end
    it 'should redirect to city index' do
      required_params = {
        'city_id': city1.id,
        'id': location1.id
      }
      delete :destroy, params: required_params
      expect(response).to redirect_to city_locations_path
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
