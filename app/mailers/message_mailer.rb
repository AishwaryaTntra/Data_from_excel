class MessageMailer < ApplicationMailer
  default from: 'dataproject1609@gmail.com'

  def new_message_mail(message)
    @message = message
    @location = Location.find_by(id: @message.location_id)
    @location.users.each do |user|
      user_mail(user, @message).deliver
    end
  end

  def user_mail(user, message)
    mail(to: user.email, subject: 'New Event In your Location!!!!')
  end
end
