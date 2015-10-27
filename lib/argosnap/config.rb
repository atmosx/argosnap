require 'yaml'
require 'logger'

# main module
module Argosnap

  # Handle configuration files and create 'logger' object
  class Configuration
    def files
      {
        config: "#{Dir.home}/.argosnap/config.yml", 
        home: "#{Dir.home}/.argosnap/", 
        logfile: "#{Dir.home}/.argosnap/argosnap.log"
      }
    end

    # Create the logger object
    def logger
      Logger.new(files[:logfile], 10, 1024000)
    end

    # Load configuration data as a hash 
    def data
      YAML::load_file(files[:config])
    end

    def gem_available?(name)
         Gem::Specification.find_by_name(name)
    rescue Gem::LoadError
         false
    rescue
         Gem.available?(name)
    end

    def log_and_abort(msg)
      logger.error(msg)
      Kernel.abort(msg)
    end
  end
end
