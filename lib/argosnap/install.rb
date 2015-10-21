require 'fileutils'
require 'yaml'

module Argosnap

  class Install

    # Load onfiguration files
    def files
      Configuration.new.files
    end

    # Install configuration files in the system
    def install
      ensure_compatibility
      begin
        # permissions are a-rwx, u+rwx
        if File.exists? files[:config]
          puts "Config file exists!"
          puts "Please remove config: #{config} manually and re-install the configuration file." 
        else
          Dir.mkdir(File.join(Dir.home, ".argosnap"), 0700) unless File.exist? files[:home]
          FileUtils.touch(files[:logfile]) unless File.exist? files[:logfile]
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
          File.open(files[:config], "w") {|f| f.write(config.to_yaml)}

          puts ""
          puts "Configuration file created! To setup argosnap: "
          puts "1. Edit the configuration file: #{files[:config]}"
          puts "2. Run argosnap by typing in the terminal 'argosnap -p' to fetch current balance"
          puts "3. To configure notifications see: <link>"
          puts ""

        end
      rescue Errno::ENOENT => e
        puts "Can't locate file!"
        puts e.message
        puts e.backtrace
      end
    end

    def cron_entry
      puts "\nA standard cron entry looks like this:\n"
      puts "\n5 8 * * 6 <user> <command>\n"
      puts "\nFor detailed instructions see here: <wiki-link>"
      puts ""
    end

    # Check OS support and configuration file
    def ensure_compatibility
      # Check the operating system. Windows is not supported at this time.
      unless %w{ darwin linux freebsd openbsd netbsd }.include? Gem::Platform.local.os 
        Kernel.abort "This gem is made for UNIX! Please check the website for details #{url} !"
      end
    end
  end
end
