# frozen_string_literal: true

# app > controllers > cities_controller
class CitiesController < ApplicationController
  load_and_authorize_resource
  before_action :authorize
  def index
    @cities = City.all.where(user_id: current_user.id)
  end

  def new
    @city = current_user.cities.new
  end

  def create
    @city = current_user.cities.new(city_params)

    if @city.save
      redirect_to cities_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @city = City.find_by(id: params[:id], user_id: current_user.id)
  end

  def update
    @city = City.find_by(id: params[:id], user_id: current_user.id)

    if @city.update(city_params)
      redirect_to cities_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @city = City.find_by(id: params[:id], user_id: current_user.id)
    @city.destroy

    redirect_to cities_path, status: :see_other
  end

  def new_city_customer_message
    @city = City.find_by(id: params[:id], user_id: current_user.id)
  end

  def city_customers_message
    @city = City.find_by(id: params[:id], user_id: current_user.id)
    @city.locations.each do |location|
      @message = Message.new(message_params)
      @message.assign_attributes(location_id: location.id)
      @customers = location.customers
      if @customers.present? && @message.save
        WhatsappMessager.new(@message).find_customers
      end
    end
    if @message.persisted?
      redirect_to cities_path, notice: "#{@city.name} customer's have been notified!" 
    else
      redirect_to new_city_customer_message_path, alert: 'Something went wrong. Please try again.'
    end
  end

  private

  def city_params
    params.require(:city).permit(:name, :user_id)
  end

  def message_params
    params.permit(:body, :title)
  end

  def authorize
    redirect_to '/' unless current_user
  end
end
