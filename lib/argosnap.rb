# argosnap module

require_relative File.expand_path("../argosnap/version", __FILE__)
require 'mechanize'
require 'yaml'
require 'terminal-notifier'
require 'logger'
require 'plist'

module Argosnap

  # Handles configuration files (launchd, cron and yml)
  class Action

    # Creates launchd script with user's variables
    def cron user, time_interval
      raise ArgumentError.new("Please make sure you run 'asnap install' in order to install configuration files, before running asnap!") unless File.exists?("#{Dir.home}/.argosnap/config.yml")
      user = ENV['USER']
      c = "#{Dir.home}/.argosnap/config.yml"
      r = YAML::load_file(c)
      time_interval = r[:seconds]
      begin
        launch_agents = "/Users/#{user}/Library/LaunchAgents/"
        start_script = File.expand_path("../lib/files/argosnap.sh")
        if Dir.exists?(launch_agents)
          filename = "org.#{user}.argosnap.plist"
          hash = {"Label"=>"#{filename.a.scan(/(.+)(?:\.[^.]+)/).flatten[0]}", "ProgramArguments"=>["/Users/atma/Code/scripts/local.sh"], "StartInterval"=> time_interval, "RunAtLoad"=>true} 
          File.open("#{launch_agents}/#{filename}", 'w') {|f| f.write(hash.to_plist)}
        end
      rescue Exception => e
        puts e.message
        puts e.backtrace
      end
    end

    # Runs installation
    def install
      url = 'http://somehwere.com'
      raise ArgumentError.new("This gem is made for Darwin! Please check the website for details #{url} !") unless Gem::Platform.local.os == 'darwin'
      begin
        Dir.mkdir(File.join(Dir.home, ".argosnap"), 0700) unless Dir.exists?("/Users/#{ENV['USER']}/.argosnap")# permissions are a-rwx,u+rwx
        config = {email: 'tarsnap_email', password: 'tarsnap_password', threshold: 10, seconds: 7200}
        File.open("#{Dir.home}/.argosnap/config.yml", "w") {|f| f.write(config.to_yaml)}
        puts "Installation was successful"
        puts "1. Edit the configuration file: #{Dir.home}/.argosnap/config.yml"
        puts "2. Launch argosnap by typing in the terminal: <CMD here>"
      rescue Exception => e
        puts e.message
      end

    end
  end

    # Argos class handles execution after configuration is done
    class Argos
      def initialize         
        user = ENV['USER']
        raise ArgumentError.new("Please make sure you run 'asnap install' in order to install configuration files, before running asnap!") unless File.exists?("#{Dir.home}/.argosnap/config.yml")
        r = YAML::load_file("#{Dir.home}/.argosnap/config.yml")
        logfile = "#{Dir.home}/.argosnap/argosnap.log"
        @email, @password, @threshold, @logger, @agent = r[:email], r[:password], r[:threshold], Logger.new(logfile), Mechanize.new
      end
      def balance
        begin
          page = @agent.get('https://www.tarsnap.com/account.html')
          form = page.form_with(:action => 'https://www.tarsnap.com/manage.cgi')
          form.address = @email
          form.password = @password
          panel = @agent.submit(form)
          picodollars = panel.parser.to_s.scan(/\$\d+\.\d+/)[0].scan(/\d+\.\d+/)[0].to_f.round(4) # I'm sure this can be done way prettier
          TerminalNotifier.notify("Current balance: #{picodollars}", :title => 'TarSnap', :subtitle => 'balance running out') if picodollars < @threshold.to_i
          @logger.error "Execution ended successfully! Picodollars: #{picodollars}" 
        rescue Exception => e
          # TerminalNotifier.notify("Can not check balance! View logs!", :title => 'TarSnap', :subtitle => 'error')
          @logger.error "A problem with tarsnap notification occured:"
          @logger.error "#{e}"
        end
      end
    end

end
