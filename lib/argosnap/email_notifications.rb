require_relative File.expand_path('../balance', __FILE__)

require 'mail'
require 'socket'
require 'haml'

module Argosnap
  class Mailer
    attr_accessor :picodollars, :method, :smtpd_address, :smtpd_port, :smtpd_from, :smtpd_to
    def initialize
      # config and log files
      config = YAML::load_file("#{Dir.home}/.argosnap/config.yml")
      logfile = "#{Dir.home}/.argosnap/argosnap.log"

      # vars
      @logger = Logger.new(logfile)
      @picodollars = Argosnap::Fetch.new.balance
      @threshold = config[:threshold]
      @seconds = config[:seconds]
      @smtpd_address = config[:smtpd_address]
      @smtpd_port = config[:smtpd_port]
      @smtpd_from = config[:smtpd_from]
      @smtpd_to = config[:smtpd_to]
      @email_delivery = [:email_delivery_method]
    end

    # send email. HTML format is the default.
    def send_mail(format='html')
      mail = Mail.new
      mail[:from] =  @smtpd_from
      mail[:to]    =  @smtpd_to
      mail[:subject] = "ARGOSNAP: Your tarsnap account is running out!"

      if format == 'txt'
        mail[:body] =  File.read(File.expand_path('../../../files/mail.body.txt', __FILE__))
      else
        mail['content-type'] = 'text/html; charset=UTF-8'
        mail[:body] = Haml::Engine.new(File.read(File.expand_path('../../../files/mail.body.haml', __FILE__))).render
      end

      # SMTPd variables
      if @method == 'smtp'
        mail.delivery_method :smtp, address: @smtpd_address, port: @smtpd_port
      end

      # dispatch email
      mail.deliver
    end
  end
end
