# load libraries
require 'yaml'
require 'logger'

# load notification libraries
require_relative File.expand_path("../notifications/mailer", __FILE__)
require_relative File.expand_path("../notifications/pushover", __FILE__)

module Argosnap
  class Notifications
    attr_reader :config, :logger
    def initialize(config, logger)
      config  = "#{Dir.home}/.argosnap/config.yml"
      logfile = "#{Dir.home}/.argosnap/argosnap.log"
      data    = YAML::load_file(config)

      @logger        = Logger.new(logfile, 10, 1024000)
      @threshold     = data[:threshold]
    end

    def send
      Argosnap::Mailer.new.send if data[:notifications_email]
      if data[:notifications_pushover]
        key = data[:pushover][:key]
        token  = data[:pushover][:token]
        message = "Your tarsnap account is running out of picodollars! Your current amount is #{Argosnap::Fetch.new.balance} picoUSD"
        Pushover.send(token, key, message, logger)
      end
    end
  end
end
