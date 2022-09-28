class CustomersController < ApplicationController
  def index
    @location = Location.find_by(id: params[:location_id])
    @customers = Customer.all.where(location_id: location.id, user_id: current_user.id)
  end

  def edit
    @location = Location.find_by(id: params[:location_id])
    @customer = Customer.find_by(id: params[:id])
  end

  def update
    @location = Location.find_by(id: params[:location_id])
    @customer = Customer.find_by(id: params[:id])

    if @customer.update(customer_params)
      redirect_to location_customers_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :phone, :email, :location_id, :user_id)
  end
end
