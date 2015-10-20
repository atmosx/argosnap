require 'logger'
require 'yaml'

module Argosnap

  class Install

    attr_reader :home, :config, :url
    def initialize
      @config = "#{Dir.home}/.argosnap/config.yml"
      @home   = "#{Dir.home}/.argosnap"
      @url    = 'http://atmosx.github.com/argosnap'
    end

    # Install configuration files in the system
    def config
      ensure_compatibility
      begin
        # permissions are a-rwx, u+rwx
        if File.exist?(config)
          puts "Config file exists!"
          puts "Please remove config: #{config} if you want to re-installing" 
        else
          Dir.mkdir(File.join(Dir.home, ".argosnap"), 0700) unless Dir.exists?(config)
          config = {
            email: 'tarsnap_email', 
            password: 'tarsnap_password', 
            threshold: 10, 
            seconds: 86400,
            notifications_email: false,
            smtp: {
              email_delivery_method: 'smtp', 
              smtpd_address: "gmail.google.com", 
              smtpd_port: 587, 
              smtpd_from: 'user@host.domain.com', 
              smtpd_to: 'your@email.com', 
              format: 'txt'},
            notifications_pushover: false,
            pushover: {
              key: 'user_key',
              token: 'app_token'}
          }

          File.open(config, "w") {|f| f.write(config.to_yaml)}
          puts "1. Edit the configuration file: #{config}"
          puts "2. Launch argosnap by typing in the terminal: argosnap -p"
        end
      rescue Exception => e
        puts "You found a bug!"
        puts "Please open a ticket at https://github.com/atmosx/argosnap/issues" 
        puts "Give details like: what command you issued, OS version, argosnap version and ruby version. Include the following message:"
        puts e.message
        puts e.backtrace
      end
    end

    # Check OS support and configuration file
    def ensure_compatibility
      # Check the operating system. Windows is not supported at this time.
      if %w{ darwin linux freebsd openbsd netbsd }.include? Gem::Platform.local.os 
        Kernel.abort("Please make sure you run 'argosnap install', before running argosnap!") unless File.exists?(config)
      else
        Kernel.abort "This gem is made for UNIX! Please check the website for details #{url} !"
      end
    end

  end
end
