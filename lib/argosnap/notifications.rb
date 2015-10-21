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
      config  = YAML::load_file("#{Dir.home}/.argosnap/config.yml")
      logfile = "#{Dir.home}/.argosnap/argosnap.log"
      @logger        = Logger.new(logfile, 10, 1024000)
      @threshold     = config[:threshold]
    end

    def gem_available?(name)
         Gem::Specification.find_by_name(name)
    rescue Gem::LoadError
         false
    rescue
         Gem.available?(name)
    end

    def send
      Argosnap::Mailer.new(config, logger).send if (data[:notifications_email] && gem_available?('mail'))
      if data[:notifications_pushover]
        key     = config[:pushover][:key]
        token   = config[:pushover][:token]
        message = "Your tarsnap account is running out of picodollars! Your current amount is #{Argosnap::Fetch.new.balance} picoUSD"
        Pushover.send(token, key, message, logger)
      end
    end
  end
end
