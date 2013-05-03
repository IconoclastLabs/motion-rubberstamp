# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubberstamp/version'

Gem::Specification.new do |spec|
  spec.name          = "motion-rubberstamp"
  spec.version       = Rubberstamp::VERSION
  spec.authors       = ["Matt Garrison"]
  spec.email         = ["mattsgarrison@iconoclastlabs.com"]
  spec.description   = %q{Adds version and git information overlays to your iOS app icon}
  spec.summary       = %q{Adds version and git information overlays to your iOS app icon}
  spec.homepage      = "http://github.com/mattsgarrison/motion-rubberstamp"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
