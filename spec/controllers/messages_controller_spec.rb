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
      expect(response.status).to eq(200)
      expect(response).to render_template(:new)
      expect(assigns(:message)).to be_instance_of(Message)
    end
  end

  describe 'POST	/locations/:location_id/messages' do
    context 'the message is created successfully' do
      it 'should redirect to location messages path with a created message' do
        required_params = {
          'message': {
            'body': 'Test message 1 as invite to people.',
            'title': 'Test message title'
          },
          'location_id': location.id
        }
        post :create, params: required_params
        expect(response).to redirect_to location_messages_path
        expect(response.status).to eq(302)
        expect(assigns(:location)).to eq(location)
        expect(assigns(:message)).to be_instance_of(Message)
      end
    end
    context 'the message is failed to create' do
      it 'should render new with unprocessable entitiy status' do
        required_params = {
          'message': {
            'body': ''
          },
          'location_id': location.id
        }
        post :create, params: required_params
        expect(response).to render_template(:new)
        expect(response.status).to eq(422)
        expect(assigns(:location)).to eq(location)
        expect(assigns(:message)).to be_instance_of(Message)
      end
    end
  end
end
