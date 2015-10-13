require_relative File.expand_path('../balance', __FILE__)

# OSX specific libraries
require 'terminal-notifier'
require 'plist'

module Argosnap

  # Display notifications under OSX
  class OSXNotifications
    attr_reader :logger, :picodollars, :time_interval
    def initialize
      begin

        config = "#{Dir.home}/.argosnap/config.yml"
        logfile = "#{Dir.home}/.argosnap/argosnap.log"
        data = YAML::load_file(config)

        @logger        = Logger.new(logfile)
        @picodollars   = Argosnap::Fetch.new.balance
        @threshold     = data[:threshold]
        @time_interval = data[:time_interval]
        
      rescue ArgumentError => e

        puts e.message
        exit
      end
    end

    # Creates launchd script with user's variables
    def install_launchd_script 
      Argosnap::Install.new.ensure_compatibility
      # Gem::Platform.local.os # => osx
      user = ENV['USER']
      begin
        launch_agents = "/Users/#{user}/Library/LaunchAgents/"
        # start_script loads the RVM environment.
        # FIX THIS: NOT EVERYONE RUNS RVM!
        start_script = File.expand_path('../../../files/local.sh', __FILE__)
        if Dir.exists?(launch_agents)
          filename = "org.#{user}.argosnap.plist"
          if File.exist?("#{launch_agents}#{filename}")
            puts "Please delete file: #{launch_agents}#{filename} before proceeding!"
          else
            hash = {"Label"=>"#{filename.scan(/(.+)(?:\.[^.]+)/).flatten[0]}", "ProgramArguments"=>["#{start_script}"], "StartInterval"=> time_interval, "RunAtLoad"=>true} 
            File.open("#{launch_agents}#{filename}", 'w') {|f| f.write(hash.to_plist)}
            puts "Launchd script is installed. Type 'launchctl load -w #{launch_agents}#{filename}' to load the plist."
          end
        else
          puts "No '#{launch_agents}' directory found! Aborting installation."
        end
      rescue Exception => e
        puts e.message
      end
    end

    # Display current ballance in OSX style notifications
    def display_osx_notification
      TerminalNotifier.notify("Current balance: #{picodollars}", :title => 'TarSnap', :subtitle => 'balance running out') 
    end
  end
end
