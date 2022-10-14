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
  let!(:city3) { create :city, :city3, user_id: user2.id }
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
        expect(response).to render_template(:new)
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

    it 'should redirect to root_path if the city does not belongs to the user' do
      required_params = {
        'id': city3.id
      }
      get :edit, params: required_params
      expect(response).to redirect_to root_path
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
      it 'should render edit template' do
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
    it 'should redirect to root_path if the city does not belongs to the user' do
      required_params = {
        "city": {
          "name": 'Test city 1'
        },
        'id': city3.id
      }
      patch :update, params: required_params
      expect(response).to redirect_to root_path
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
    it 'should redirect to root_path if the city does not belongs to the user' do
      required_params = {
        'id': city3.id
      }
      delete :destroy, params: required_params
      expect(response).to redirect_to root_path
    end
  end
  describe 'GET	/city/:id/new_city_customer_message' do
    it 'should return http success' do
      required_params = {
        'id': city1.id
      }
      get :new_city_customer_message, params: required_params
      expect(response.status).to eq(200)
    end
    it 'should render :new_city_customer_message template' do
      required_params = {
        'id': city1.id
      }
      get :new_city_customer_message, params: required_params
      expect(response).to render_template(:new_city_customer_message)
    end
    it "should assign the variable city as the city who's customers are to be messaged" do
      required_params = {
        'id': city1.id
      }
      get :new_city_customer_message, params: required_params
      expect(assigns(:city)).to eq(city1)
    end
    it 'should redirect to root_path if the city does not belongs to the user' do
      required_params = {
        'id': city3.id
      }
      get :new_city_customer_message, params: required_params
      expect(response).to redirect_to root_path
    end
  end

  describe 'POST	/city/:id/city_customers_message' do
    context 'the message is failed to create because there are no locations for the city' do
      it 'should return http success with code 302' do
        required_params = {
          'id': city1.id,
          'message': {
            'title': 'test message 1',
            'body': 'test message for city 1 users'
          }
        }
        post :city_customers_message, params: required_params
        expect(response.status).to eq(302)
      end
      it 'should redirect to new_city_customer_message_path' do
        required_params = {
          'id': city1.id,
          'message': {
            'title': 'test message 1',
            'body': 'test message for city 1 users'
          }
        }
        post :city_customers_message, params: required_params
        expect(response).to redirect_to(new_city_customer_message_path)
      end
      it 'should assign the city variable to be equal to the city for which the message is being created' do
        required_params = {
          'id': city1.id,
          'message': {
            'title': 'test message 1',
            'body': 'test message for city 1 users'
          }
        }
        post :city_customers_message, params: required_params
        expect(assigns(:city)).to eq(city1)
      end
      it 'should flash an alert message regarding the absence of the locations' do
        required_params = {
          'id': city1.id,
          'message': {
            'title': 'test message 1',
            'body': 'test message for city 1 users'
          }
        }
        post :city_customers_message, params: required_params
        expect(flash[:alert]).to eq('Currently, There are no locations for city 1')
      end
    end
    context 'message failed to create due to customer absence' do
      let!(:location1) { create :location, :location1, city_id: city1.id, user_id: @current_user.id }
      let!(:location2) { create :location, :location2, city_id: city1.id, user_id: @current_user.id }
      it 'should return http success with 302 code' do
        required_params = {
          'id': city1.id,
          'message': {
            'title': 'test message 1',
            'body': 'test message for city 1 users'
          }
        }
        post :city_customers_message, params: required_params
        expect(response.status).to eq(302)
      end
      it 'should redirect to new_city_customer_message_path' do
        required_params = {
          'id': city1.id,
          'message': {
            'title': 'test message 1',
            'body': 'test message for city 1 users'
          }
        }
        post :city_customers_message, params: required_params
        expect(response).to redirect_to(new_city_customer_message_path)
      end
      it "should assign the city variable as the city who's customers are being messaged" do
        required_params = {
          'id': city1.id,
          'message': {
            'title': 'test message 1',
            'body': 'test message for city 1 users'
          }
        }
        post :city_customers_message, params: required_params
        expect(assigns(:city)).to eq(city1)
      end
      it 'should assign the message variable as an instance of Message model' do
        required_params = {
          'id': city1.id,
          'message': {
            'title': 'test message 1',
            'body': 'test message for city 1 users'
          }
        }
        post :city_customers_message, params: required_params
        expect(assigns(:message)).to be_instance_of(Message)
      end
      it 'should assign customers variable as an empty array' do
        required_params = {
          'id': city1.id,
          'message': {
            'title': 'test message 1',
            'body': 'test message for city 1 users'
          }
        }
        post :city_customers_message, params: required_params
        expect(assigns(:customers)).to eq([])
      end
      it 'should flash alert message' do
        required_params = {
          'id': city1.id,
          'message': {
            'title': 'test message 1',
            'body': 'test message for city 1 users'
          }
        }
        post :city_customers_message, params: required_params
        expect(flash[:alert]).to eq('Something went wrong. Please try again. Make sure you have customers for all the locations of the city.')
      end
    end
    context 'message failed to create due to absence of title or body' do
      let!(:location1) { create :location, :location1, city_id: city1.id, user_id: @current_user.id }
      let!(:customer1) { create :customer, :customer1, location_id: location1.id, user_id: @current_user.id }
      let!(:customer2) { create :customer, :customer2, location_id: location1.id, user_id: @current_user.id }
      it 'should return http success with 302 code' do
        required_params = {
          'id': city1.id,
          'message': {
            'title': '',
            'body': 'Body for city customers message'
          }
        }
        post :city_customers_message, params: required_params
        expect(response.status).to eq(302)
      end
      it 'should redirect to new_city_customer_message path' do
        required_params = {
          'id': city1.id,
          'message': {
            'title': '',
            'body': ''
          }
        }
        post :city_customers_message, params: required_params
        expect(response).to redirect_to(new_city_customer_message_path)
      end
      it 'should flash an alert' do
        required_params = {
          'id': city1.id,
          'message': {
            'title': '',
            'body': ''
          }
        }
        post :city_customers_message, params: required_params
        expect(flash[:alert]).to eq('Title and body both should be present.')
      end
      it "should assign city variable to city who's cutomers are being messaged" do
        required_params = {
          'id': city1.id,
          'message': {
            'title': '',
            'body': ''
          }
        }
        post :city_customers_message, params: required_params
        expect(assigns(:city)).to eq(city1)
      end
    end
    context 'message created successfully' do
      let!(:location1) { create :location, :location1, city_id: city1.id, user_id: @current_user.id }
      let!(:customer1) { create :customer, :customer1, location_id: location1.id, user_id: @current_user.id }
      let!(:customer2) { create :customer, :customer2, location_id: location1.id, user_id: @current_user.id }
      it 'should return http success with code 302' do
        required_params = {
          'id': city1.id,
          'message': {
            'title': 'Test message',
            'body': 'Test message for customers'
          }
        }
        post :city_customers_message, params: required_params
        expect(response.status).to eq(302)
      end
      it 'should redirect to cities_path' do
        required_params = {
          'id': city1.id,
          'message': {
            'title': 'Test message',
            'body': 'Test message for customers'
          }
        }
        post :city_customers_message, params: required_params
        expect(response).to redirect_to(cities_path)
      end
      it 'should flash a notice' do
        required_params = {
          'id': city1.id,
          'message': {
            'title': 'Test message',
            'body': 'Test message for customers'
          }
        }
        post :city_customers_message, params: required_params
        expect(flash[:notice]).to eq("city 1 customer's have been notified!")
      end
      it "should assign city variable to city who's cutomers are being messaged" do
        required_params = {
          'id': city1.id,
          'message': {
            'title': 'Test message',
            'body': 'Test message for customers'
          }
        }
        post :city_customers_message, params: required_params
        expect(assigns(:city)).to eq(city1)
      end
      it 'should assign message variable to be an instance of Message' do
        required_params = {
          'id': city1.id,
          'message': {
            'title': 'Test message',
            'body': 'Test message for customers'
          }
        }
        post :city_customers_message, params: required_params
        expect(assigns(:message)).to be_instance_of(Message)
      end
      it "should assigns customers variable with the city's customers" do
        required_params = {
          'id': city1.id,
          'message': {
            'title': 'Test message',
            'body': 'Test message for customers'
          }
        }
        post :city_customers_message, params: required_params
        expect(assigns(:customers)).to eq(city1.customers)
      end
    end
    it 'should redirect to root_path if the city does not belongs to the user' do
      required_params = {
        'id': city3.id,
        'message': {
          'title': 'Test message',
          'body': 'Test message for customers'
        }
      }
      post :city_customers_message, params: required_params
      expect(response).to redirect_to root_path
    end
  end
end
