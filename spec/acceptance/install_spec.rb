require 'spec_helper_acceptance'

describe 'default twemproxy install testing', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do

  describe 'running puppet code for default install' do
    it 'should provision with defaults' do
      pp = <<-EOS

        if versioncmp($::puppetversion,'3.6.1') >= 0 {
          $allow_virtual_packages = hiera('allow_virtual_packages',false)
          Package {
            allow_virtual => $allow_virtual_packages,
          }
        }

        class { 'twemproxy::install': }
        
      EOS

      apply_manifest(pp, :catch_failures => true)

    end
  end

  describe 'should install autoconf-2.64' do
    it 'should create autoconf-2.64 data directory' do
      shell("test -d /usr/local/src/autoconf-2.64", :acceptable_exit_codes => 0)
    end
  end

  describe 'should install twemproxy-0.4.0' do
    it 'should create twemproxy-0.4.0 data directory' do
      shell("test -d /usr/local/src/twemproxy-0.4.0", :acceptable_exit_codes => 0)
    end
  end

end
