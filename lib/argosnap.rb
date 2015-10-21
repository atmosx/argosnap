# argosnap module

require_relative File.expand_path("../argosnap/version", __FILE__)
require_relative File.expand_path("../argosnap/install", __FILE__)
require_relative File.expand_path("../argosnap/config", __FILE__)
require_relative File.expand_path("../argosnap/balance", __FILE__)
require_relative File.expand_path("../argosnap/notifications", __FILE__)
require_relative File.expand_path("../argosnap/osxnotify", __FILE__) if Gem::Platform.local.os == 'darwin'
