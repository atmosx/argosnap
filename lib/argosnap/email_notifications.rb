require_relative File.expand_path('../balance', __FILE__)

require 'mail'
require 'socket'
require 'haml'

module Argosnap
  class Mailer
    # set getters
    attr_reader :email_notifications, :logger, :smtpd_address, :smtpd_port, :smtpd_from, :smtpd_to, :method, :format
    def initialize
      config               = YAML::load_file("#{Dir.home}/.argosnap/config.yml")
      logfile              = "#{Dir.home}/.argosnap/argosnap.log"

      @logger              = Logger.new(logfile)
      @smtpd_address       = config[:smtp][:smtpd_address]
      @smtpd_port          = config[:smtp][:smtpd_port]
      @smtpd_from          = config[:smtp][:smtpd_from]
      @smtpd_to            = config[:smtp][:smtpd_to]
      @method              = config[:smtp][:email_delivery_method]
      @format              = config[:smtp][:format]
      @email_notifications = config[:smtp][:email_notifications]
    end

    def ensure_mail_configuration
      if smtpd_address.empty?
        logger.error("There is no 'smtpd_address' in #{config}\nPlease check your configuration file.")
        Kernel.abort("There is no 'smtpd_address' in #{config}\nPlease check your configuration file.")
      elsif smtpd_port.empty?
        logger.error("There is no 'smtpd_port' in #{config}\nPlease check your configuration file.")
        Kernel.abort("There is no 'smtpd_port' in #{config}\nPlease check your configuration file.")
      elsif smtpd_to.empty?
        logger.error("There is no 'smtpd_to' in #{config}\nPlease check your configuration file.")
        Kernel.abort("There is no 'smtpd_to' in #{config}\nPlease check your configuration file.")
      end
    end

    # send email. HTML format is the default.
    def send_mail(format='html')
      # ensure compatibility first
      Argosnap::Install.new.ensure_compatibility
      ensure_mail_configuration
      if email_notifications
        # create the 'mail' object
        mail           = Mail.new

        # configure mail options
        mail[:from]    =  smtpd_from
        mail[:to]      =  smtpd_to
        mail[:subject] = "ARGOSNAP: Your tarsnap account is running out of picodollars!"

        # configure mail format
        if format == 'txt'
          mail[:body] =  File.read(File.expand_path('../../../files/mail.body.txt', __FILE__))
        else
          mail['content-type'] = 'text/html; charset=UTF-8'
          mail[:body] = Haml::Engine.new(File.read(File.expand_path('../../../files/mail.body.haml', __FILE__))).render
        end

        # SMTPd configuration. Defaults to local 'sendmail'
        if method == 'smtp'
          mail.delivery_method :smtp, address: smtpd_address, port: smtpd_port
        end

        # dispatch email
        mail.deliver
      else
        logger.info("Email notifications are disasbled. Please check your config: #{config}")
        puts "Email notifications are disasbled. Please check your config: #{config}"
      end
    end

  end
end
