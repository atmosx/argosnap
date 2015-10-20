require 'yaml'
require 'mechanize'
require 'logger'

module Argosnap
  # Given a username and a password, fetch balance from https://www.tarsnap.com
  class Fetch
    attr_reader :email, :password, :logger, :agent
    def initialize         
      begin

        config  = "#{Dir.home}/.argosnap/config.yml"
        logfile = "#{Dir.home}/.argosnap/argosnap.log"
        data    = YAML::load_file(config)

        @email     = data[:email]
        @password  = data[:password] 
        @logger    = Logger.new(logfile, 10, 1024000)
        @agent     = Mechanize.new

      rescue ArgumentError => e
        puts e.message
        exit
      end
    end

    # Elementary configuration file check
    def check_configuration
      Argosnap::Install.new.ensure_compatibility
      if email.empty?
        puts "Please add your tarsnap email to #{config}"
      elsif password.empty?
        puts "Please add your tarsnap password to #{config}"
      else 
        true
      end
    end

    # Fetch balance from tarsnap using
    def balance
      check_configuration
      begin
        page          = agent.get('https://www.tarsnap.com/account.html')
        form          = page.form_with(:action => 'https://www.tarsnap.com/manage.cgi')
        form.address  = email
        form.password = password
        panel         = agent.submit(form)
        picodollars   = panel.parser.to_s.scan(/\$\d+\.\d+/)[0].scan(/\d+\.\d+/)[0].to_f.round(4) 
        logger.info   "Execution ended successfully! Picodollars: #{picodollars}" 
        picodollars
      rescue Exception => e
        logger.error  "A problem with tarsnap notification occured:"
        logger.error  "#{e}"
      end
    end
  end
end
