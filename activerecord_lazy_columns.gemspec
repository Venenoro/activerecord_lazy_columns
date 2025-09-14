# frozen_string_literal: true

require_relative "lib/activerecord_lazy_columns/version"

Gem::Specification.new do |spec|
  spec.name = "activerecord_lazy_columns"
  spec.version = ActiveRecordLazyColumns::VERSION
  spec.authors = ["fatkodima"]
  spec.email = ["fatkodima123@gmail.com"]

  spec.summary = "Adds support for lazy-loading columns in Active Record models"
  spec.homepage = "https://github.com/fatkodima/activerecord_lazy_columns"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/master/CHANGELOG.md"

  spec.files = Dir["**/*.{md,txt}", "{lib}/**/*"]
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", ">= 7.2"
end
