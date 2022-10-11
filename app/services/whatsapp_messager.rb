# frozen_string_literal: true

# app > services > whatsapp_messager
class WhatsappMessager
  require 'uri'
  require 'net/http'
  require 'openssl'
  def initialize(message)
    @message = message
  end

  def send_message(receiver)
    url = URI('https://api.ultramsg.com/instance19754/messages/chat')
    receiver_num = "+91#{receiver.phone}"
    body = @message.body

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request['content-type'] = 'application/x-www-form-urlencoded'
    request.body = "token=avtom1cgi64pnl4g&to=#{receiver_num}&body=#{body}!&priority=1&referenceId="
    http.request(request)
  end

  def find_customers
    @customers = @message.customers
    @customers.each do |customer|
      send_message(customer)
    end
  end
end
