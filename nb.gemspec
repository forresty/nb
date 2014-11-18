# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nb'

Gem::Specification.new do |spec|
  spec.name          = "nb"
  spec.version       = NaiveBayes::VERSION
  spec.authors       = ["Forrest Ye"]
  spec.email         = ["afu@forresty.com"]
  spec.summary       = %q{ yet another Naive Bayes library }
  spec.homepage      = "https://github.com/forresty/nb"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
end
