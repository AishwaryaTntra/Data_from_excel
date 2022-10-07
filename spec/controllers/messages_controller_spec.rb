require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  let!(:role) { create :role, :user }
  let!(:user) { create :user, :user1, role_id: role.id }
  before(:each) do
    @current_user = User.find_by(email: user.email)
    sign_in(@current_user)
  end
  let!(:city) { create :city, :city1, user_id: user.id }
  let!(:location) { create :location, :location1, city_id: city.id, user_id: user.id }
  let!(:customer1) { create :customer, :customer1, location_id: location.id, user_id: @current_user.id }
  let!(:customer2) { create :customer, :customer2, location_id: location.id, user_id: @current_user.id }
  let!(:message) { create :message, :message1, location_id: location.id }
  describe 'GET	/locations/:location_id/messages' do
    context 'no messages have been created yet' do
      it 'should redirect to message new template' do
        location.messages.destroy_all
        required_params = {
          'location_id': location.id
        }
        get :index, params: required_params
        expect(response).to redirect_to new_location_message_path
      end
      it 'should assign messages variable as empty array' do
        location.messages.destroy_all
        required_params = {
          'location_id': location.id
        }
        get :index, params: required_params
        expect(assigns(:messages)).to eq([])
      end
    end

    context 'there are messages for the location' do
      let!(:message1) { create :message, :message1, location_id: location.id }
      let!(:message2) { create :message, :message2, location_id: location.id }
      it 'should render index template' do
        required_params = {
          'location_id': location.id
        }
        get :index, params: required_params
        expect(response).to render_template(:index)
      end
      it 'should respond with http success' do
        required_params = {
          'location_id': location.id
        }
        get :index, params: required_params
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'GET	/locations/:location_id/messages/:id/new' do
    let!(:message) { create :message, :message1, location_id: location.id }
    it 'should render new template' do
      required_params = {
        'id': message.id,
        'location_id': location.id
      }
      get :new, params: required_params
      expect(response).to render_template(:new)
    end
    it 'should respond with http success' do
      required_params = {
        'id': message.id,
        'location_id': location.id
      }
      get :new, params: required_params
      expect(response.status).to eq(200)
    end
    it 'should assign variable message as an instance of Message' do
      required_params = {
        'id': message.id,
        'location_id': location.id
      }
      get :new, params: required_params
      expect(assigns(:message)).to be_instance_of(Message)
    end
  end

  describe 'POST	/locations/:location_id/messages' do
    context 'the message is created successfully' do
      it 'should redirect to location messages path' do
        required_params = {
          'message': {
            'body': 'Test message 1 as invite to people.',
            'title': 'Test message title'
          },
          'location_id': location.id
        }
        post :create, params: required_params
        expect(response).to redirect_to location_messages_path
      end

      it 'should respond with http code 302' do
        required_params = {
          'message': {
            'body': 'Test message 1 as invite to people.',
            'title': 'Test message title'
          },
          'location_id': location.id
        }
        post :create, params: required_params
        expect(response.status).to eq(302)
      end

      it "should assign the location variable with the message's location" do
        required_params = {
          'message': {
            'body': 'Test message 1 as invite to people.',
            'title': 'Test message title'
          },
          'location_id': location.id
        }
        post :create, params: required_params
        expect(assigns(:location)).to eq(location)
      end

      it 'should assign the message variable as an instance of Message' do
        required_params = {
          'message': {
            'body': 'Test message 1 as invite to people.',
            'title': 'Test message title'
          },
          'location_id': location.id
        }
        post :create, params: required_params
        expect(assigns(:message)).to be_instance_of(Message)
      end

    end
    context 'the message is failed to create' do
      it 'should render new template' do
        required_params = {
          'message': {
            'body': ''
          },
          'location_id': location.id
        }
        post :create, params: required_params
        expect(response).to render_template(:new)
      end
      it 'should respond with unprocessable entity status' do
        required_params = {
          'message': {
            'body': ''
          },
          'location_id': location.id
        }
        post :create, params: required_params
        expect(response.status).to eq(422)
      end
      it "should assign location variable as the message's location" do
        required_params = {
          'message': {
            'body': ''
          },
          'location_id': location.id
        }
        post :create, params: required_params
        expect(assigns(:location)).to eq(location)
      end

      it 'should assign the message as an instance of Message' do
        required_params = {
          'message': {
            'body': ''
          },
          'location_id': location.id
        }
        post :create, params: required_params
        expect(assigns(:message)).to be_instance_of(Message)
      end
    end
    context 'the message is failed to create because of no existing customers in the location' do
      it 'should redirect to new template' do
        location.customers.destroy_all
        required_params = {
          'message': {
            'body': 'Test message 1 as invite to people.',
            'title': 'Test message title'
          },
          'location_id': location.id
        }
        post :create, params: required_params
        expect(response).to redirect_to(new_location_message_path)
      end
      it 'should respond with http code 302' do
        location.customers.destroy_all
        required_params = {
          'message': {
            'body': 'Test message 1 as invite to people.',
            'title': 'Test message title'
          },
          'location_id': location.id
        }
        post :create, params: required_params
        expect(response.status).to eq(302)
      end
      it 'should assign @message variable as an instance of Message' do
        location.customers.destroy_all
        required_params = {
          'message': {
            'body': 'Test message 1 as invite to people.',
            'title': 'Test message title'
          },
          'location_id': location.id
        }
        post :create, params: required_params
        expect(assigns(:message)).to be_instance_of(Message)
      end
      it 'should assign @location variable as the location of the message' do
        location.customers.destroy_all
        required_params = {
          'message': {
            'body': 'Test message 1 as invite to people.',
            'title': 'Test message title'
          },
          'location_id': location.id
        }
        post :create, params: required_params
        expect(assigns(:location)).to eq(message.location)
      end
    end
  end
end
