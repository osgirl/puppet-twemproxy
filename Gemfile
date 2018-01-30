source ENV['GEM_SOURCE'] || "https://rubygems.org"

gem 'katip'

group :development do
  gem 'guard'
  gem 'guard-rspec', require: false
  gem 'guard-rubocop'
  gem 'pry-doc'
end

group :development, :test do
  gem 'rspec-puppet',
    :git => 'https://github.com/rodjek/rspec-puppet.git',
    :ref => '',
    :require => false
  gem 'rake',                    :require => false
  gem 'puppet-lint',             :require => false
  gem 'puppet-syntax',           :require => false
  gem 'puppetlabs_spec_helper',  :require => false
  gem 'puppet-blacksmith',       :require => false
  gem 'metadata-json-lint',      :require => false
  gem 'pry',                     :require => false
end

group :system_tests do
  gem 'beaker-rspec',  :require => false
  gem 'serverspec',    :require => false
end

if puppetversion = ENV['PUPPET_GEM_VERSION'] 
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', '~> 3.6.2', :require => false
end

# vim:ft=ruby
#
# export PUPPET_GEM_VERSION="3.7.2"


