require 'spec_helper_acceptance'

describe 'default nutcracker service testing', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do

  describe 'running puppet code for default install' do
    it 'should provision with defaults' do
      pp = <<-EOS

        if versioncmp($::puppetversion,'3.6.1') >= 0 {
          $allow_virtual_packages = hiera('allow_virtual_packages',false)
          Package {
            allow_virtual => $allow_virtual_packages,
          }
        }

        twemproxy::resource::nutcracker { 'test.a.nut.msm.internal':
          auto_eject_hosts     => false,
          distribution         => 'ketama',
          ensure               => 'present',
          log_dir              => '/var/log/nutcracker',
          members              => '',
          nutcracker_hash      => 'fnv1a_64',
          nutcracker_hash_tag  => '',
          pid_dir              => '/var/run/nutcracker',
          port                 => '22111',
          redis                => true,
          server_retry_timeout => '2000',
          server_failure_limit => '3',
          statsport            => '21111',
          twemproxy_timeout    => '300'
        }        
        
      EOS

      apply_manifest(pp, :catch_failures => true)

    end
  end

  describe 'should run service nutcracker' do
  end


end
