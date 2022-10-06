# frozen_string_literal: true

# app > controllers > messages_controller
class MessagesController < ApplicationController
  load_and_authorize_resource
  before_action :authorize
  def index
    @location = Location.find_by(id: params[:location_id])
    @messages = Message.all.where(location_id: @location.id)
    redirect_to new_location_message_path(@location), notice: 'No messages sent yet!' unless @messages.present?
  end

  def new
    @location = Location.find_by(id: params[:location_id])
    @message = Message.new
  end

  def create
    @location = Location.find_by(id: params[:location_id])
    @message = @location.messages.new(message_params)
    @customers = @location.customers
    if @customers.present?
      if @message.save
        WhatsappMessager.new(@message).find_customers
        redirect_to location_messages_path(@location)
      else
        render :new, status: :unprocessable_entity
      end
    else
      redirect_to new_location_message_path, alert: 'No customers present for this location.'
    end
  end

  private

  def message_params
    params.require(:message).permit(:body, :title)
  end

  def authorize
    redirect_to '/' unless current_user
  end
end
