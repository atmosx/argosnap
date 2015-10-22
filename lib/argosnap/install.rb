require 'fileutils'

module Argosnap

  class Install

    # Install configuration files in the system
    def install
      ensure_compatibility
      begin
        # permissions are a-rwx, u+rwx
        if File.exists? config.files[:config]
          puts "Config file exists!"
          puts "Please remove config: #{config.files[:config]} manually and re-install the configuration file." 
        else
          Dir.mkdir(File.join(Dir.home, ".argosnap"), 0700) unless File.exist? config.files[:home]
          FileUtils.touch(config.files[:logfile]) unless File.exist? config.files[:logfile]
          config = {
            email: 'tarsnap_email', 
            password: 'tarsnap_password', 
            threshold: 10, 
            seconds: 86400,
            notifications_osx: false,
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
          File.open(config.files[:config], "w") {|f| f.write(config.to_yaml)}

          puts ""
          puts "Configuration file created! To setup argosnap: "
          puts "1. Edit the configuration file: #{config.files[:config]}"
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
        config.log_and_abort("This gem is made for UNIX! Please check the website for details #{url} !")
      end
    end

    def ensure_installation
      if File.exist?(config.files[:home])
        if (File.exist?(config.files[:logfile]) && File.exist?(config.files[:config]))
          true
        else
          puts ""
          Kernel.abort("No configuration files found! Please run 'argosnap -i config'\n")
        end
      else
        puts ""
        Kernel.abort("No configuration directory found! Please run 'argosnap -i config'\n")
      end
    end

    # private methods
    private

    # Load onfiguration files
    def config
      Configuration.new
    end

  end
end
