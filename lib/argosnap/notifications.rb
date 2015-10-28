# main module
module Argosnap

  # This class handles the available notifications
  class Notifications

    # When tarsnap balance is bellow threshold notify me
    # Method is chosen based on threshold
    def notify
      if config.data[:threshold] >= Fetch.new.balance
        send_mail
        send_pushover
        send_osx_notification
      end
    end

    def osx_check_and_notify
      if config.data[:threshold] >= Fetch.new.balance
        send_osx_notification
      end
    end

    def send_mail
      if config.data[:notifications_email]
        if config.gem_available?('mail')
          require 'mail'
          require 'socket'
          require_relative File.expand_path("../notifications/mailer", __FILE__)
          Mailer.new(config.data, config.logger).send_mail
        else
          config.log_and_abort("Please install 'mail' gem by executing: '$ gem install mail'.")
        end
      end
    end

    def send_pushover_notification
      if config.data[:notifications_pushover]
        require "net/https"
        require_relative File.expand_path("../notifications/pushover", __FILE__)
        key     = config.data[:pushover][:key]
        token   = config.data[:pushover][:token]
        amount = Fetch.new.balance
        message = "Your current tarsnap amount is #{amount} picoUSD!"
        Pushover.send(token, key, message, config.logger, amount)
      end
    end

    # Manually send notification to osx notifications (desktop)
    def send_osx_notification
      if config.data[:notifications_osx]
        if Gem::Platform.local.os == 'darwin'
          # load 'terminal-notifier'
          if config.gem_available?('terminal-notifier')
            require 'terminal-notifier'
            require_relative File.expand_path("../notifications/osxnotifications", __FILE__)
            message = "Your picoUSD amount is: #{Fetch.new.balance}"
            title  = 'argosnap'
            subtitle = 'running out of picoUSD!'
            OSXnotify.send(message, title, subtitle)
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
