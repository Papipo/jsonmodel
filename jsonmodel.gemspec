# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jsonmodel/version'

Gem::Specification.new do |gem|
  gem.name    = "jsonmodel"
  gem.version = JSONModel::VERSION
  gem.authors = ["Rodrigo Alvarez"]
  gem.email   = ["papipo@gmail.com"]
  gem.description = "This gem allows you to create dynamic classes (models) based on a JSON Schema, providing validations and being compliant with ActiveModel."
  gem.summary = "Dynamic Active Model compliant models via JSON Schema"
  gem.homepage = "http://github.com/Papipo/jsonmodel"
  
  gem.files = `git ls-files`.split($/)
  gem.licenses = ["MIT"]
  gem.require_paths = ["lib"]
  gem.executables = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files  = gem.files.grep(%r{^(test|spec|features)/})
  
  gem.add_runtime_dependency "activemodel"
  gem.add_runtime_dependency "activesupport"
end

