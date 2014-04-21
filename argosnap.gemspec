# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'argosnap/version'

Gem::Specification.new do |spec|
  spec.name          = "argosnap"
  spec.version       = Argosnap::VERSION
  spec.authors       = ["Panagiotis Atmatzidis"]
  spec.email         = ["atma@convalesco.org"]
  spec.summary       = %q{Display osx notifications when tarsnap account runs out of picodollars}
  spec.description   = %q{A ruby script displays OSX notifications with current ballance. If the balance of picodollars falls bellow a specific threshold}
  spec.homepage      = "https://github.com/atmosx/argosnap"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
