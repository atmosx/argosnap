module Argosnap
  class Mailer

    # load configuration files
    def config 
      Configuration.new
    end

    attr_reader :logger, :smtpd_address, :smtpd_port, :smtpd_from, :smtpd_to, :method, :format
    def initialize(config, logger)
      @logger              = logger
      @smtpd_address       = config[:smtp][:smtpd_address]
      @smtpd_port          = config[:smtp][:smtpd_port]
      @smtpd_from          = config[:smtp][:smtpd_from]
      @smtpd_to            = config[:smtp][:smtpd_to]
      @method              = config[:smtp][:email_delivery_method]
      @format              = config[:smtp][:format]
    end

    def ensure_mail_configuration
      if smtpd_address.empty?
        config.log_and_abort("There is no 'smtpd_address' in #{config}. Please check your configuration file.")
      elsif smtpd_port.empty?
        config.log_and_abort("There is no 'smtpd_port' in #{config}. Please check your configuration file.")
      elsif smtpd_to.empty?
        config.log_and_abort("There is no 'smtpd_to' in #{config}. Please check your configuration file.")
      end
    end

    # send email. HTML format is the default.
    def send_mail(format='html')
      # ensure compatibility first
      Install.new.ensure_compatibility
      ensure_mail_configuration

      # create the 'mail' object
      mail           = Mail.new

      # configure mail options
      mail[:from]    =  smtpd_from
      mail[:to]      =  smtpd_to
      mail[:subject] = "ARGOSNAP: Your tarsnap account is running out of picodollars!"

      # configure mail format: Use HTML if the user wants it, otherwise default to 'txt'
      if format == 'html'
        if config.gem_available?('haml')
          require 'haml'
          mail['content-type'] = 'text/html; charset=UTF-8'
          mail[:body] = Haml::Engine.new(File.read(File.expand_path('../../../files/mail.body.haml', __FILE__))).render
        else
          config.log_and_abort("Please install haml gem to receive HTML emails: '$ gem install haml'")
        end
      else
        mail[:body] =  File.read(File.expand_path('../../../files/mail.body.txt', __FILE__))
      end

      # SMTPd configuration. Defaults to local 'sendmail'
      if method == 'smtp'
        mail.delivery_method :smtp, address: smtpd_address, port: smtpd_port
      end

      # dispatch email
      mail.deliver
    end

  end
end
