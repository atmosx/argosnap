require 'fileutils'

module Argosnap

  class Install

    # Install configuration files in the system
    def install
      ensure_compatibility
      begin
        # permissions are a-rwx, u+rwx
        if File.exists? configuration.files[:config]
          puts "Config file exists!"
          puts "Please remove config: #{configuration.files[:config]} manually and re-install the configuration file." 
        else
          Dir.mkdir(File.join(Dir.home, ".argosnap"), 0700) unless File.exist? configuration.files[:home]
          FileUtils.touch(configuration.files[:logfile]) unless File.exist? configuration.files[:logfile]
          config = {
            email: 'tarsnap_email', 
            password: 'tarsnap_password', 
            threshold: 10, 
            seconds: 86400,
            notifications_osx: false,
            notifications_email: false,
            smtp: {
              email_delivery_method: 'sendmail', 
              smtpd_user: 'username',
              smtpd_password: 'password',
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
          File.open(configuration.files[:config], "w") {|f| f.write(config.to_yaml)}

          puts ""
          puts "Configuration file created! To setup argosnap: "
          puts "1. Edit the configuration file: #{configuration.files[:config]}"
          puts "2. Run argosnap by typing in the terminal 'argosnap -p' to fetch current balance"
          puts "3. To configure notifications see: <link>"
          puts ""

        end
      rescue Errno::ENOENT => e
        puts "Can't configuration locate file!"
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
        Kernel.abort("\nThis gem is made for UNIX! Please check the website for details #{url} !\n\n")
      end
    end

    def ensure_installation
      if File.exist?(configuration.files[:home])
        if (File.exist?(configuration.files[:logfile]) && File.exist?(configuration.files[:config]))
          true
        else
          Kernel.abort("\nNo configuration files found! Please run 'argosnap -i config'\n\n")
        end
      else
        Kernel.abort("\nNo configuration directory found! Please run 'argosnap -i config'\n\n")
      end
    end

    # private methods
    private

    # Load onfiguration files
    def configuration
      Configuration.new
    end

  end
end
