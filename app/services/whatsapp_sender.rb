# app > services > whatsapp_sender.rb
class WhatsappSender
  def initialize(message)
    @message = message
  end

  def send_message(receiver)
    @account_sid = ENV['twilio_account_sid']
    @auth_token = ENV['twilio_auth_token']
    @client = Twilio::REST::Client.new(@account_sid, @auth_token)
    @receiver_num = "whatsapp:+91#{receiver.phone}"
    @body = @message.body
    message = @client.messages.create(
      body: @body,
      from: 'whatsapp:+14155238886',
      to: @receiver_num
    )
  end

  def find_users
    @users = @message.users
    @users.each do |user|
      send_message(user)
    end
  end
end
