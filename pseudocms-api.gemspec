# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pseudocms/api/version'

Gem::Specification.new do |spec|
  spec.name          = "pseudocms-api"
  spec.version       = PseudoCMS::API::VERSION
  spec.authors       = ["David Muto"]
  spec.email         = ["david.muto@gmail.com"]
  spec.summary       = %q{A ruby library for working with the PseudoCMS API}
  spec.description   = %q{A simple wrapper around the PseudoCMS API}
  spec.homepage      = "https://github.com/pseudocms/pseudocms-api"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
