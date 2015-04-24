require 'rubygems'
require 'rspec-puppet'
require 'erb'
require 'hiera'

def loadTemplateContent(path)
  template = ERB.new File.new("#{path_to_fixtures}/modules/ifetoolbelt/templates/#{path.partition('/').last}").read, nil, "%"
  template.result(binding)
end

def path_to_fixtures
  File.expand_path(File.join(__FILE__, '..', 'fixtures'))
end

RSpec.configure do |c|
  c.module_path = File.join(path_to_fixtures, 'modules')
  c.manifest_dir = File.join(path_to_fixtures, 'manifests')
end

if ENV['PUPPET_DEBUG']
  Puppet::Util::Log.level = :debug
  Puppet::Util::Log.newdestination(:console)
end

