class DataImportsController < ApplicationController
  def new
    @data_import = DataImport.new
  end

  def create
    @data_import = DataImport.new(params[:data_import])
    if @data_import.load_imported_data
      redirect_to cities_path
    else
      render :new
    end
  end
end
