require 'mechanize'
require 'logger'

module Argosnap
  # Given a username and a password, fetch balance from https://www.tarsnap.com
  class Fetch

    # load configuration files
    def config 
      Configuration.new
    end

    attr_reader :email, :password, :logger, :agent
    def initialize         
        @email     = config.data[:email]
        @password  = config.data[:password] 
        @logger    = config.logger
        @agent     = Mechanize.new
    end

    # Elementary configuration file check
    def check_configuration
      Install.new.ensure_compatibility
      if email.empty?
        logger.error "Please add your tarsnap email to #{config}"
        Kernel.abort "Please add your tarsnap email to #{config}"
      end
      if password.empty?
        logger.error "Please add your tarsnap password to #{config}"
        Kernel.abort "Please add your tarsnap password to #{config}"
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
        logger.info("Current amount of picoUSD: #{picodollars}")
        picodollars
      rescue SockerError => e
        logger.error("A problem with tarsnap notification occured:")
        logger.error(e)
      end
    end
  end
end
