require 'logger'
require 'yaml'

module Argosnap
  class Install
    # Install 'config.yml'
    def config
      url = 'http://atmosx.github.com/argosnap'
      raise ArgumentError.new("This gem is made for UNIX! Please check the website for details #{url} !") unless %w{ darwin linux freebsd openbsd netbsd }.include? Gem::Platform.local.os 
      begin
        Dir.mkdir(File.join(Dir.home, ".argosnap"), 0700) unless Dir.exists?("/Users/#{ENV['USER']}/.argosnap")# permissions are a-rwx,u+rwx
        config = {email: 'tarsnap_email', password: 'tarsnap_password', threshold: 10, seconds: 7200, email_notifications: false, email_delivery_method: 'smtp', smtpd_address: "gmail.google.com", smtpd_port: 587, smtpd_from: 'user@host.domain.com', smtpd_to: 'your@email.com'}
        File.open("#{Dir.home}/.argosnap/config.yml", "w") {|f| f.write(config.to_yaml)}
        puts "1. Edit the configuration file: #{Dir.home}/.argosnap/config.yml"
        puts "2. Launch argosnap by typing in the terminal: argosnap -p"
      rescue Exception => e
        puts e.message
      end
    end
  end
end
