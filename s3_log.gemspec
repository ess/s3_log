# -*- encoding: utf-8 -*-
require File.expand_path('../lib/s3_log/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Dennis Walters"]
  gem.email         = ["dennis@elevatorup.com"]
  gem.summary       = %q{Log misc events to Amazon S3}
  gem.description   = <<-EOD
    Log misc events to Amazon S3
  EOD
  gem.homepage      = "http://github.com/ess/s3_log"
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "s3_log"
  gem.require_paths = ["lib"]
  gem.version       = S3Log::VERSION

  gem.add_dependency 'fog-aws', '~> 0.1.1'
  gem.add_development_dependency 'rspec', '~> 3.2.0'
end
