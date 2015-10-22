module Argosnap

  # Helper Class
  class Helpers

    # Creates launchd script with user's variables
    def install_plist
      if configuration.gem_available?('plist')
        require 'plist'
        time_interval = configuration.data[:seconds]
        # Gem::Platform.local.os # => osx
        user = ENV['USER']
        launch_agents = "/Users/#{user}/Library/LaunchAgents/"
        # start_script loads ruby - optimized for 'rvm'
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
      else
        configuration.log_and_abort("Please install plist!")
      end
    end

    # private
    private
    def configuration
      Configuration.new
    end

  end

end
