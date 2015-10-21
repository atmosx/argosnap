require 'yaml'

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
  end
end
