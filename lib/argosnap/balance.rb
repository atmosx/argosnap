require 'yaml'
require 'mechanize'
require 'logger'

module Argosnap
  # Given a username and a password, fetch balance from https://www.tarsnap.com
  class Fetch
    def initialize         
      begin
        raise ArgumentError.new("Please make sure you run 'argosnap install', before running argosnap!") unless File.exists?("#{Dir.home}/.argosnap/config.yml")
        r = YAML::load_file("#{Dir.home}/.argosnap/config.yml")
        logfile = "#{Dir.home}/.argosnap/argosnap.log"
        @email, @password, @threshold, @logger, @agent = r[:email], r[:password], r[:threshold], Logger.new(logfile), Mechanize.new
      rescue ArgumentError => e
        puts e.message
        exit
      end
    end

    # Fetch balance from tarsnap using mechanize
    def balance
      begin
        page = @agent.get('https://www.tarsnap.com/account.html')
        form = page.form_with(:action => 'https://www.tarsnap.com/manage.cgi')
        form.address = @email
        form.password = @password
        panel = @agent.submit(form)
        picodollars = panel.parser.to_s.scan(/\$\d+\.\d+/)[0].scan(/\d+\.\d+/)[0].to_f.round(4) 
        @logger.info "Execution ended successfully! Picodollars: #{picodollars}" 
        picodollars
      rescue Exception => e
        @logger.error "A problem with tarsnap notification occured:"
        @logger.error "#{e}"
      end
    end
  end
end
