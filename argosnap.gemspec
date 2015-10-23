# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'argosnap/version'

Gem::Specification.new do |spec|
  spec.name          = "argosnap"
  spec.version       = Argosnap::VERSION
  spec.authors       = ["Panagiotis Atmatzidis"]
  spec.email         = ["atma@convalesco.org"]
  spec.summary       = %q{Read your tarsnap picoUSD amount in cli and display notifications when it runs out!.}
  spec.description   = %q{A ruby script that displays tarsnap current ballance in picoUSD. The script can send notifications when the acount balance falls below the predefined threshold. Argosnap supports email, pushover and OSX notifications.}
  spec.homepage      = "https://github.com/atmosx/argosnap"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
