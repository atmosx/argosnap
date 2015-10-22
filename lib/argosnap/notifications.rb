module Argosnap
  class Notifications

    # If current balance goes bellow threshold notify me
    def notify
      if config.data[:threshold] <= Fetch.new.balance
        send_email
        send_pushover
        send_osx_notification
      end
    end

    # send notification via email
    def send_mail
      if config.data[:notifications_email]
        if config.gem_available?('mail')
          require 'mail'
          require 'socket'
          require_relative File.expand_path("../notifications/mailer", __FILE__)
          Mailer.new(config, logger).send 
        else
          config.log_and_abort("Please install 'mail' gem by executing: '$ gem install mail'.")
        end
      end
    end

    # send notification via pushover.net
    def send_pushover
      if data[:notifications_pushover]
        require "net/https"
        require_relative File.expand_path("../notifications/pushover", __FILE__)
        key     = config[:pushover][:key]
        token   = config[:pushover][:token]
        message = "Your tarsnap account is running out of picodollars! Your current amount is #{Fetch.new.balance} picoUSD"
        Pushover.send(token, key, message, logger)
      end
    end

    # send notification to osx notifications (desktop)
    def send_osx_notification
      if data[:Notifications_osx]
        if Gem::Platform.local.os == 'darwin'
          # load 'terminal-notifier'
          if config.gem_available?('terminal-notifier')
            require 'terminal-notifier'
            require_relative File.expand_path("../notifications/osxnotifications", __FILE__)
            message = "Your picoUSD amount is: #{Fetch.new.balance}"
            title  = 'argosnap'
            subtitle 'running out of picoUSD!'
            OSXNotify.send(message, title, subtitle)
          else
             config.log_and_abort("You need to install 'terminal-notifier' gem!")
          end
        else
          config.log_and_abort("OSX notifications are available only under OSX > 10.8.x")
        end
      end
    end

    # private methods
    private

    # load configuration files
    def config 
      Configuration.new
    end

  end
end
