# frozen_string_literal: true

# app > controllers > data_imports_controller
class DataImportCsvsController < ApplicationController
  before_action :authorize
  def new
    @data_import = DataImportCsv.new
    @current_user = current_user
  end

  def create
    @data_import = DataImportCsv.new(params[:data_import_csv])
    @current_user = current_user
    begin
      if @data_import.load_imported_data
        redirect_to cities_path
      else
        render :new
      end
    rescue NoMethodError
      redirect_to new_data_import_csv_path, alert: 'Make sure you have uploaded the correct file with the correct data.'
    rescue RuntimeError
      redirect_to new_data_import_csv_path,
                  alert: "You have entered a file with invalid format. Please upload file with either '.xls' or '.xlsx'
                          formats only."
    rescue IndexError
      city = City.all.where(user_id: current_user.id).last
      city.destroy
      redirect_to new_data_import_csv_path, alert: 'Make sure you have uploaded the correct file with the correct data.'
    end
  end

  def data_generate
    @data = AxlsxService.new.create_report
    respond_to do |format|
      format.xlsx do
        response.headers[
          'Content-Disposition'
        ] = 'attachment; filename=City_name.xlsx'
      end
    end
  end

  def authorize
    redirect_to '/' unless current_user
  end
end