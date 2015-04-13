require 'rubygems'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppetlabs_spec_helper/module_spec_helper'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'

begin
  require 'puppet_blacksmith/rake_tasks'
rescue LoadError
end

PuppetLint.configuration.fail_on_warnings
PuppetLint.configuration.relative = true

PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.send('disable_class_inherits_from_params_class')
PuppetLint.configuration.send('disable_class_parameter_defaults')
PuppetLint.configuration.send('disable_documentation')
PuppetLint.configuration.send('disable_single_quote_string_with_variables')

Rake::Task[:lint].clear
PuppetLint::RakeTask.new :lint do |config|
  config.ignore_paths = ["**/spec/**/*.pp", "**/vendor/**/*.pp"]
  config.log_format = '%{path}:%{linenumber}:%{KIND}: %{message}'
end

PuppetSyntax.exclude_paths = ["**/spec/**/*", "**/vendor/**/*"]

task :metadata do
  sh "bundle exec metadata-json-lint metadata.json"
end

task :init do
  unless Dir.exist?('spec/fixtures/manifests')
    sh "bundle exec rspec-puppet-init"
  end
end

desc 'Run syntax, lint, and spec tests.'
task :test => [
  :init,
  :syntax,
  :lint,
  :metadata,
  :spec,
]
