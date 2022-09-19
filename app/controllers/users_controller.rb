class UsersController < ApplicationController
  def index
    @location = Location.find_by(id: params[:location_id])
    @users = User.all.where(location_id: @location.id)
  end

  def edit
    @location = Location.find_by(id: params[:location_id])
    @user = User.find_by(id: params[:id])
  end

  def update
    @location = Location.find_by(id: params[:location_id])
    @user = User.find_by(id: params[:id])

    if @user.update(user_params)
      redirect_to city_location_users_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :phone, :email, :location_id)
  end
end
