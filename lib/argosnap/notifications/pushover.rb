# pushover.net module
module Pushover
  def self.send(token, user, message, log)
    begin
      # be nice to Pushover API
      sleep(5)
      url = URI.parse("https://api.pushover.net/1/messages.json")
      req = Net::HTTP::Post.new(url.path)
      req.set_form_data({
        token: token,
        user: user,
        message: message
      })
      res = Net::HTTP.new(url.host, url.port)
      res.use_ssl = true
      res.verify_mode = OpenSSL::SSL::VERIFY_PEER
      res.start do |http|
        status = http.request(req).code
        if status == '200'
          log.info('Notification sent via Pushover!')
        elsif (400...500).to_a.include?(status)
          log.error("Please revise your Pushover credentials. API request failed.")
        else
          log.error("Request returned status code: #{status}, Pushover notification probably failed.")
        end
      end
    end
  rescue SocketError
    log.error("No internet connection available, Pushover notification failed.")
  end
end
