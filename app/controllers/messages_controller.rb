class MessagesController < ApplicationController
  def index
    @location = Location.find_by(id: params[:location_id])
    @messages = Message.all.where(location_id: @location.id)
    unless @messages.present?
      redirect_to new_location_message_path(@location), notice: 'No messages sent yet!'
    end
  end

  def new
    @location = Location.find_by(id: params[:location_id])
    @message = Message.new
  end

  def create 
    @location = Location.find_by(id: params[:location_id])
    @message = @location.messages.new(message_params)
    if @message.save
      MessageMailer.new_message_mail(@message).deliver_now
      redirect_to location_messages_path(@location)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:body, :title)
  end
end
