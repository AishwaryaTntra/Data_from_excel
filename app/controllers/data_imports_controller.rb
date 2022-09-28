class DataImportsController < ApplicationController
  def new
    @data_import = DataImport.new
  end

  def create
    @data_import = DataImport.new(params[:data_import])
    begin
      if @data_import.load_imported_data
        redirect_to cities_path
      else
        render :new
      end
    rescue NoMethodError
      redirect_to new_data_import_path, alert: 'Make sure you have uploaded the correct file with the correct data.'
    end
  rescue RuntimeError
    redirect_to new_data_import_path,
                alert: "You have entered a file with invalid format. Please upload file with '.csv', '.xls', '.xlsx' formats only."
  end
end
