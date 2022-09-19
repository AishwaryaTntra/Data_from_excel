class LocationsController < ApplicationController
  def index
    @locations = Location.all.where(city_id: params[:city_id])
  end

  def new
    @city = City.find_by(id: params[:city_id])
    @location = Location.new
  end

  def create
    @city = City.find_by(id: params[:city_id])
    @location = @city.locations.new(location_params)
    if @location.save
      redirect_to city_locations_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @city = City.find_by(id: params[:city_id])
    @location = Location.find_by(id: params[:id])
  end

  def update
    @city = City.find_by(id: params[:city_id])
    @location = Location.find_by(id: params[:id])

    if @location.update(location_params)
      redirect_to city_locations_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @city = City.find_by(id: params[:city_id])
    @location = Location.find_by(id: params[:id])
    @location.destroy

    redirect_to city_locations_path(city_id: @city.id), status: :see_other
  end

  private

  def location_params
    params.require(:location).permit(:name, :city_id)
  end
end
