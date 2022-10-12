require 'rails_helper'

RSpec.describe Devise::SessionsController, type: :controller do
  let!(:role) { create :role, :user }
  let!(:user1) { create :user, :user1, role_id: role.id }

  describe 'DELETE destroy' do
    before :each do
      request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user1
    end
    it 'should redirect to root path' do
      required_params = {
        'id': user1.id
      }
      delete :destroy, params: required_params
      expect(response).to redirect_to root_path
    end
    it 'should have http success with code 302' do
      required_params = {
        'id': user1.id
      }
      delete :destroy, params: required_params
      expect(response.status).to eq(302)
    end
    it 'should flash a notice' do
      required_params = {
        'id': user1.id
      }
      delete :destroy, params: required_params
      expect(flash[:notice]).to eq('Signed out successfully.')
    end
    it 'should work with User model object' do
      required_params = {
        'id': user1.id
      }
      delete :destroy, params: required_params
      expect(assigns(:devise_mapping).class_name).to eq('User')
    end
  end
end
