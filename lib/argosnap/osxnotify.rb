require 'terminal-notifier'
require_relative File.expand_path('../balance', __FILE__)
require 'yaml'

module Argosnap
  class OSXNotifications
    def initialize
      begin
        user = ENV['USER']
        raise ArgumentError.new("This command is made for Darwin! Please check the website for details #{url} !") unless Gem::Platform.local.os == 'darwin'
        r = YAML::load_file("#{Dir.home}/.argosnap/config.yml")
        logfile = "#{Dir.home}/.argosnap/argosnap.log"
        @threshold, @logger, @picodollars, @time_interval = r[:threshold], Logger.new(logfile), Argosnap::Fetch.new.balance, r[:seconds]
      rescue ArgumentError => e
        puts e.message
        # puts e.backtrace
        exit
      end
    end

    # Creates launchd script with user's variables
    def install_launchd_script 
      raise ArgumentError.new("Please make sure you run 'argosnap install' in order to install configuration files, before running asnap!") unless File.exists?("#{Dir.home}/.argosnap/config.yml")
      user = ENV['USER']
      c = "#{Dir.home}/.argosnap/config.yml"
      begin
        launch_agents = "/Users/#{user}/Library/LaunchAgents/"
        # start_script loads the RVM environment.
        start_script = File.expand_path('../../../files/local.sh', __FILE__)
        if Dir.exists?(launch_agents)
          filename = "org.#{user}.argosnap.plist"
          if File.exist?("#{launch_agents}#{filename}")
            puts "Please delete file: #{launch_agents}#{filename} before proceeding!"
          else
            hash = {"Label"=>"#{filename.scan(/(.+)(?:\.[^.]+)/).flatten[0]}", "ProgramArguments"=>["#{start_script}"], "StartInterval"=> @time_interval, "RunAtLoad"=>true} 
            File.open("#{launch_agents}#{filename}", 'w') {|f| f.write(hash.to_plist)}
            puts "Launchd script is installed. Type 'launchctl load -w #{launch_agents}#{filename}' to load the plist."
          end
        else
          puts "No '#{launch_agents}' directory found! Aborting installation."
        end
      rescue Exception => e
        puts e.message
        # puts e.backtrace
      end
    end

    # Display notifications
    def display
      TerminalNotifier.notify("Current balance: #{@picodollars}", :title => 'TarSnap', :subtitle => 'balance running out') if @picodollars < @threshold.to_i
    end
  end
end
