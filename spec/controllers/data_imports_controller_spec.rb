require 'rails_helper'

RSpec.describe DataImportsController, type: :controller do
  let!(:role) { create :role, :user }
  let!(:user) { create :user, :user1, role_id: role.id }
  before(:each) do
    @current_user = User.find_by(email: user.email)
    sign_in(@current_user)
  end

  describe 'GET	/data_imports/new' do
    it 'should render new template' do
      get :new
      expect(response.status).to render_template(:new)
    end
    it 'should respond with http success' do
      get :new
      expect(response.status).to eq(200)
    end
    it 'should assign the current user correctly' do
      get :new
      expect(assigns(:current_user)).to eq(user)
    end
    it 'should assign data_imports variable as an instance of DataImport' do
      get :new
      expect(assigns(:data_import)).to be_instance_of(DataImport)
    end
  end

  describe 'GET	/data_imports/create' do
    context 'the data is imported successfully' do
      let!(:file) { fixture_file_upload('Vadodara.xlsx') }
      it 'should redirect to cities path' do
        required_params = {
          'data_import': {
            'file': file
          }
        }
        post :create, params: required_params
        expect(response).to redirect_to cities_path
      end
      it 'should respond with http code 302' do
        required_params = {
          'data_import': {
            'file': file
          }
        }
        post :create, params: required_params
        expect(response.status).to eq(302)
      end
      it 'should assign data_import variable as an instance of DataImports' do
        required_params = {
          'data_import': {
            'file': file
          }
        }
        post :create, params: required_params
        expect(assigns(:data_import)).to be_instance_of(DataImport)
      end
    end
    context 'the file is not imported properly' do
      it 'should render new' do
        post :create
        expect(response).to redirect_to new_data_import_path
      end
    end
    context 'incorrect file format' do
      let!(:file) { fixture_file_upload('dummy.txt') }
      it 'should redirect to new template with notice ' do
        required_params = {
          'data_import': {
            'file': file
          }
        }
        post :create, params: required_params
        expect(response).to redirect_to new_data_import_path
      end
      it 'should respond with http code 302' do
        required_params = {
          'data_import': {
            'file': file
          }
        }
        post :create, params: required_params
        expect(response.status).to eq(302)
      end
    end
  end
end
