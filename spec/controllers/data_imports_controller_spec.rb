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
      it 'should render an alert message' do
        post :create
        expect(flash[:alert]).to eq('Make sure you have uploaded the correct file with the correct data.')
      end
    end
    context 'incorrect file format' do
      let!(:file) { fixture_file_upload('dummy.txt') }
      it 'should redirect to new template' do
        required_params = {
          'data_import': {
            'file': file
          }
        }
        post :create, params: required_params
        expect(response).to redirect_to new_data_import_path
      end
      it 'should flash a notice' do
        required_params = {
          'data_import': {
            'file': file
          }
        }
        post :create, params: required_params
        expect(flash[:alert]).to eq("You have entered a file with invalid format. Please upload file with either '.xls' or '.xlsx' formats only.")
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
    context 'xls format file uploaded' do
      let!(:file) { fixture_file_upload('Vadodara.xls') }
      it 'should redirect to cities path' do
        required_params = {
          'data_import': {
            'file': file
          }
        }
        post :create, params: required_params
        expect(response).to redirect_to cities_path
      end
      it 'should have http code 302' do
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
    context 'file with incorrect data raising nomethoderror' do
      let!(:file) { fixture_file_upload('Incorrect-File.xlsx') }
      it 'should respond with http success with 302 code' do
        required_params = {
          'data_import': {
            'file': file
          }
        }
        post :create, params: required_params
        expect(response.status).to eq(302)
      end
      it 'should redirect to new data import path' do
        required_params = {
          'data_import': {
            'file': file
          }
        }
        post :create, params: required_params
        expect(response).to redirect_to new_data_import_path
      end
      it 'should flash an alert' do
        required_params = {
          'data_import': {
            'file': file
          }
        }
        post :create, params: required_params
        expect(flash[:alert]).to eq('Make sure you have uploaded the correct file with the correct data.')
      end
      it 'should assign data_import variable as an instance DataImport' do
        required_params = {
          'data_import': {
            'file': file
          }
        }
        post :create, params: required_params
        expect(assigns(:data_import)).to be_instance_of(DataImport)
      end
    end
  end

  describe 'GET	/data_imports/data_generate' do
    it 'should respond with http success' do
      get :data_generate, format: :xlsx
      expect(response.status).to eq(200)
    end
    it 'should render template data_generate' do
      get :data_generate, format: :xlsx
      expect(response).to render_template(:data_generate)
    end
    it 'the generated file should be an excel file' do
      get :data_generate, format: :xlsx
      expect(assigns[:rendered_format].symbol).to eq(:xlsx)
    end
    it 'should assign current_user as the currently logged in user' do
      get :data_generate, format: :xlsx
      expect(assigns[:current_user]).to eq(user)
    end
  end
end
