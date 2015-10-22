require 'mechanize'

module Argosnap
  # Given a username and a password, fetch balance from https://www.tarsnap.com
  class Fetch

    # Elementary configuration file check
    def check_configuration
      Install.new.ensure_compatibility
      Install.new.ensure_installation
      if config.data[:email].empty?
        config.log_and_abort("Please add your tarsnap email to #{config}")
      end
      if config.data[:password].empty?
        config.log_and_abort("Please add your tarsnap password to #{config}")
      end
    end

    # Fetch balance from tarsnap using
    def balance
      check_configuration
      agent         = Mechanize.new
      page          = agent.get('https://www.tarsnap.com/account.html')
      form          = page.form_with(:action => 'https://www.tarsnap.com/manage.cgi')
      form.address  = config.data[:email]
      form.password = config.data[:password]
      panel         = agent.submit(form)
      wrong_email_message = 'No user exists with the provided email address; please try again.'
      wrong_password_message = 'Password is incorrect; please try again.'
      if panel.body.include?(wrong_email_message)
        config.log_and_abort('Password is incorrect; please try again.')
      elsif panel.body.include?(wrong_password_message)
        config.log_and_abort('Bad password. Please check your configuration file tarsnap password!')
      end
      picodollars   = panel.parser.to_s.scan(/\$\d+\.\d+/)[0].scan(/\d+\.\d+/)[0].to_f.round(4) 
      config.logger.info("Current amount of picoUSD: #{picodollars}")
      picodollars
    end

    # private methods
    private 

    # load configuration files
    def config 
      Configuration.new
    end
  end
end
