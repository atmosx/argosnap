require 'yaml'
require 'logger'

module Argosnap
  class Configuration
    # configuration files
    def files
      {
        config: "#{Dir.home}/.argosnap/config.yml", 
        home: "#{Dir.home}/.argosnap/", 
        logfile: "#{Dir.home}/.argosnap/argosnap.log"
      }
    end

    # logger object
    def logger
      Logger.new(files[:logfile], 10, 1024000)
    end

    # Config data in hash 
    def data
      YAML::load_file(files[:config])
    end

    # Check if gem is available
    def gem_available?(name)
         Gem::Specification.find_by_name(name)
    rescue Gem::LoadError
         false
    rescue
         Gem.available?(name)
    end

    # Log and Abort!
    def log_and_abort(msg)
      logger.error(msg)
      Kernel.abort(msg)
    end
  end
end
