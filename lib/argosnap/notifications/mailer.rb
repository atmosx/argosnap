module Argosnap
  class Mailer

    # load configuration files
    def config 
      Configuration.new
    end

    attr_reader :logger, :smtpd_user, :smtpd_password, :smtpd_address, :smtpd_port, :smtpd_from, :smtpd_to, :method, :format, :balance
    def initialize(config, logger)
      @logger              = logger
      @smtpd_user          = config[:smtp][:smtpd_user]
      @smtpd_password      = config[:smtp][:smtpd_password]
      @smtpd_address       = config[:smtp][:smtpd_address]
      @smtpd_port          = config[:smtp][:smtpd_port]
      @smtpd_from          = config[:smtp][:smtpd_from]
      @smtpd_to            = config[:smtp][:smtpd_to]
      @method              = config[:smtp][:email_delivery_method]
      @format              = config[:smtp][:format]
      @balance             = Fetch.new.balance.to_s
    end

    def ensure_mail_configuration
      if smtpd_address.empty?
        config.log_and_abort("There is no 'smtpd_address' in #{config}. Please check your configuration file.")
      elsif smtpd_to.empty?
        config.log_and_abort("There is no 'smtpd_to' in #{config}. Please check your configuration file.")
      end
    end

    def text_message(amount)
      message = <<EOF

Hello

Your tarsnap account is running out of funds. Your current amount of picoUSD is #{amount}.

This automated email message was sent by argosnap. Please do not reply to this email.

Have a nice day!

argosnap
--

Argosnap: Receive notifications when your tarsnap account is running out of picoUSD!
URL:      https://github.com/atmosx/argosnap

EOF

      message
    end


    # send email. HTML format is the default.
    def send_mail
      # ensure compatibility first
      Install.new.ensure_compatibility
      ensure_mail_configuration

      # create the 'mail' object
      mail           = Mail.new

      # configure mail options
      mail[:from]    =  smtpd_from
      mail[:to]      =  smtpd_to
      mail[:subject] = "ARGOSNAP: your tarsnap balance."

      # configure mail format: Use HTML if the user wants it, otherwise default to 'txt'
      if format == 'html'
        if config.gem_available?('haml')
          require 'haml'
          mail['content-type'] = 'text/html; charset=UTF-8'
          # convert HAML to HTML
          Haml::Engine.new(File.read(File.expand_path('../../../../files/mail.body.haml', __FILE__))).def_method(balance, :render)
          mail[:body] = balance.render
        else
          log.error("Please install haml gem to receive HTML emails: '$ gem install haml'")
          mail[:body] = text_message(balance)
        end
      else
        mail[:body] =  text_message(balance)
      end

      # SMTPd configuration. Defaults to local 'sendmail'
      if method == 'smtp'
        if smtpd_port == 465
          # use smtps with some defaults
          mail.delivery_method :smtp, address: smtpd_address, port: smtpd_port, user_name: smtpd_user, password: smtpd_password, ssl: true, openssl_verify_mode: 0
        else
          mail.delivery_method :smtp, address: smtpd_address, port: smtpd_port
        end
      end

      # dispatch email
      mail.deliver
      logger.info("Argosnap sent an email to #{smtpd_to}!")
      logger.info("Current amount in picoUSD: #{balance}")
    end

  end
end
