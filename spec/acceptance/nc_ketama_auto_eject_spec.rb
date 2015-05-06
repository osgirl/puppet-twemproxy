require 'spec_helper_acceptance'

describe 'nutcracker auto eject service testing', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do

  context 'should run puppet code to install 3 localhost redis instances' do

    before :all do
      pp = <<-EOS

        if versioncmp($::puppetversion,'3.6.1') >= 0 {
          $allow_virtual_packages = hiera('allow_virtual_packages',false)
          Package {
            allow_virtual => $allow_virtual_packages,
          }
        }

        class { 'redis':
          redis_port         => '6390',          
          version            => '2.8.19'
        }
        redis::instance { 'redis-6391':
          redis_port         => '6391',
          redis_bind_address => '127.0.0.1'
        }
        redis::instance { 'redis-6392':
          redis_port         => '6392',
          redis_bind_address => '127.0.0.1'
        }
      EOS
      apply_manifest(pp, :catch_failures => true)
    end      
   
    describe service('redis_6390') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe service('redis_6391') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe service('redis_6392') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

  end

  context 'should run puppet code to install ketama type distribution using one_at_a_time hash with auto_eject' do

    it 'when provision with ketama' do
      pp = <<-EOS

        if versioncmp($::puppetversion,'3.6.1') >= 0 {
          $allow_virtual_packages = hiera('allow_virtual_packages',false)
          Package {
            allow_virtual => $allow_virtual_packages,
          }
        }

        twemproxy::resource::nutcracker4 { 'redis-twemproxy':
          port                 => '7379',
          nutcracker_hash      => 'one_at_a_time',
          nutcracker_hash_tag  => '{}',
          distribution         => 'ketama',
          twemproxy_timeout    => '30',

          auto_eject_hosts     => true,
          server_retry_timeout => '50',
          server_failure_limit => '1',

          verbosity            => 8,
          
          log_dir              => '/var/log/nutcracker',
          pid_dir              => '/var/run/nutcracker',
          redis                => true,

          statsaddress         => '127.0.0.2',
          statsport            => 11111,
          statsinterval        => 10000,

          members              =>  [
           { 
              'ip'         => '127.0.0.1',
              'name'       => 'redis-6390',
              'redis_port' => '6390',
              'weight'     => '1'
            },
            { 
              'ip'         => '127.0.0.1',
              'name'       => 'redis-6391',
              'redis_port' => '6391',
              'weight'     => '1'
            },
            { 
              'ip'         => '127.0.0.1',
              'name'       => 'redis-6392',
              'redis_port' => '6392',
              'weight'     => '1'
            }
          ] 
        }    

      EOS

      apply_manifest(pp, :catch_failures => true)

    end

    describe service('redis-twemproxy') do
      it { is_expected.to be_enabled }
    #  it { is_expected.to be_running }
    end

    describe port('7379') do
      it { should be_listening }
    end

    describe port('11111') do
      it { should be_listening }
    end
   
  end

  context 'should interact with redis' do

    it 'when setting test data' do
      shell("printf '*3\r\n$3\r\nset\r\n$36\r\n080f21ec-479c-4019-ac0d-a84e838ba89c\r\n$12\r\ntrachybasalt\r\n' | socat - TCP:localhost:7379,shut-close", :acceptable_exit_codes => [0]) do |r|
        expect(r.stdout).to match(/\+OK/)
      end

      shell("printf '*3\r\n$3\r\nset\r\n$36\r\n2f0d04a2-39cb-49d3-ba13-70f2843ec2e2\r\n$12\r\ncrosscurrent\r\n' | socat - TCP:localhost:7379,shut-close", :acceptable_exit_codes => [0]) do |r|
        expect(r.stdout).to match(/\+OK/)
      end

      shell("printf '*3\r\n$3\r\nset\r\n$36\r\n67c7020d-e447-42ee-93f4-7e27982054fb\r\n$12\r\ncategorizing\r\n' | socat - TCP:localhost:7379,shut-close", :acceptable_exit_codes => [0]) do |r|
        expect(r.stdout).to match(/\+OK/)
      end

      shell("printf '*3\r\n$3\r\nset\r\n$36\r\n1f5afd0c-5ed3-472c-a2aa-94c04f423d60\r\n$12\r\ninstillation\r\n' | socat - TCP:localhost:7379,shut-close", :acceptable_exit_codes => [0]) do |r|
        expect(r.stdout).to match(/\+OK/)
      end

      shell("printf '*3\r\n$3\r\nset\r\n$36\r\na54c9e6b-53c5-40e4-bd4e-279e9638e3bb\r\n$12\r\nnonpardoning\r\n' | socat - TCP:localhost:7379,shut-close", :acceptable_exit_codes => [0]) do |r|
        expect(r.stdout).to match(/\+OK/)
      end

      shell("printf '*3\r\n$3\r\nset\r\n$36\r\n6486ab96-4f8e-46cd-919f-c047e7fbe786\r\n$12\r\nnutritionist\r\n' | socat - TCP:localhost:7379,shut-close", :acceptable_exit_codes => [0]) do |r|
        expect(r.stdout).to match(/\+OK/)
      end

      shell("printf '*3\r\n$3\r\nset\r\n$36\r\n602697c2-fb76-469a-96e5-d58d8034d745\r\n$12\r\nprepurposing\r\n' | socat - TCP:localhost:7379,shut-close", :acceptable_exit_codes => [0]) do |r|
        expect(r.stdout).to match(/\+OK/)
      end

      shell("printf '*3\r\n$3\r\nset\r\n$36\r\n5876470c-7aac-4b06-9d82-c36341bbc9bf\r\n$12\r\nchansonniers\r\n' | socat - TCP:localhost:7379,shut-close", :acceptable_exit_codes => [0]) do |r|
        expect(r.stdout).to match(/\+OK/)
      end

      shell("printf '*3\r\n$3\r\nset\r\n$36\r\n2f141d2d-dd49-405f-9b96-247044ce8778\r\n$12\r\nsecularising\r\n' | socat - TCP:localhost:7379,shut-close", :acceptable_exit_codes => [0]) do |r|
        expect(r.stdout).to match(/\+OK/)
      end

      shell("printf '*3\r\n$3\r\nset\r\n$36\r\n54d42574-d305-4a1a-9cfc-95118fee8c43\r\n$12\r\nhomeomorphic\r\n' | socat - TCP:localhost:7379,shut-close", :acceptable_exit_codes => [0]) do |r|
        expect(r.stdout).to match(/\+OK/)
      end
    end  

    it 'when getting test data' do
      shell("printf '*2\r\n$3\r\nget\r\n$36\r\n080f21ec-479c-4019-ac0d-a84e838ba89c\r\n' | socat - TCP:localhost:7379,shut-close", :acceptable_exit_codes => [0]) do |r|
        expect(r.stdout).to match(/trachybasalt/)
      end

      shell("printf '*2\r\n$3\r\nget\r\n$36\r\n2f0d04a2-39cb-49d3-ba13-70f2843ec2e2\r\n' | socat - TCP:localhost:7379,shut-close", :acceptable_exit_codes => [0]) do |r|
        expect(r.stdout).to match(/crosscurrent/)
      end

      shell("printf '*2\r\n$3\r\nget\r\n$36\r\n67c7020d-e447-42ee-93f4-7e27982054fb\r\n' | socat - TCP:localhost:7379,shut-close", :acceptable_exit_codes => [0]) do |r|
        expect(r.stdout).to match(/categorizing/)
      end

      shell("printf '*2\r\n$3\r\nget\r\n$36\r\n1f5afd0c-5ed3-472c-a2aa-94c04f423d60\r\n' | socat - TCP:localhost:7379,shut-close", :acceptable_exit_codes => [0]) do |r|
        expect(r.stdout).to match(/instillation/)
      end

      shell("printf '*2\r\n$3\r\nget\r\n$36\r\na54c9e6b-53c5-40e4-bd4e-279e9638e3bb\r\n' | socat - TCP:localhost:7379,shut-close", :acceptable_exit_codes => [0]) do |r|
        expect(r.stdout).to match(/nonpardoning/)
      end

      shell("printf '*2\r\n$3\r\nget\r\n$36\r\n6486ab96-4f8e-46cd-919f-c047e7fbe786\r\n' | socat - TCP:localhost:7379,shut-close", :acceptable_exit_codes => [0]) do |r|
        expect(r.stdout).to match(/nutritionist/)
      end

      shell("printf '*2\r\n$3\r\nget\r\n$36\r\n602697c2-fb76-469a-96e5-d58d8034d745\r\n' | socat - TCP:localhost:7379,shut-close", :acceptable_exit_codes => [0]) do |r|
        expect(r.stdout).to match(/prepurposing/)
      end

      shell("printf '*2\r\n$3\r\nget\r\n$36\r\n5876470c-7aac-4b06-9d82-c36341bbc9bf\r\n' | socat - TCP:localhost:7379,shut-close", :acceptable_exit_codes => [0]) do |r|
        expect(r.stdout).to match(/chansonniers/)
      end

      shell("printf '*2\r\n$3\r\nget\r\n$36\r\n2f141d2d-dd49-405f-9b96-247044ce8778\r\n' | socat - TCP:localhost:7379,shut-close", :acceptable_exit_codes => [0]) do |r|
        expect(r.stdout).to match(/secularising/)
      end

      shell("printf '*2\r\n$3\r\nget\r\n$36\r\n54d42574-d305-4a1a-9cfc-95118fee8c43\r\n' | socat - TCP:localhost:7379,shut-close", :acceptable_exit_codes => [0]) do |r|
        expect(r.stdout).to match(/homeomorphic/)
      end                  
    end  

  end  

  context 'when disabling one redis node' do

    it 'and simulating a redis reboot' do
      shell("service redis_6391 stop")
      shell("sleep 1")
      shell("tail -n 20 /var/log/nutcracker/redis-twemproxy.log")
      shell("service redis_6391 start")
      shell("sleep 1")
      shell("tail -n 20 /var/log/nutcracker/redis-twemproxy.log")
    end

    it 'should still be able to get test data' do

      shell("printf '*2\r\n$3\r\nget\r\n$36\r\n080f21ec-479c-4019-ac0d-a84e838ba89c\r\n' | socat - TCP:localhost:7379,shut-close", :acceptable_exit_codes => [0]) do |r|
        expect(r.stdout).to match(/trachybasalt/)
      end

      shell("printf '*2\r\n$3\r\nget\r\n$36\r\n2f0d04a2-39cb-49d3-ba13-70f2843ec2e2\r\n' | socat - TCP:localhost:7379,shut-close", :acceptable_exit_codes => [0]) do |r|
        expect(r.stdout).to match(/crosscurrent/)
      end

      shell("printf '*2\r\n$3\r\nget\r\n$36\r\n67c7020d-e447-42ee-93f4-7e27982054fb\r\n' | socat - TCP:localhost:7379,shut-close", :acceptable_exit_codes => [0]) do |r|
        expect(r.stdout).to match(/categorizing/)
      end

      shell("printf '*2\r\n$3\r\nget\r\n$36\r\n1f5afd0c-5ed3-472c-a2aa-94c04f423d60\r\n' | socat - TCP:localhost:7379,shut-close", :acceptable_exit_codes => [0]) do |r|
        expect(r.stdout).to match(/instillation/)
      end

      shell("printf '*2\r\n$3\r\nget\r\n$36\r\na54c9e6b-53c5-40e4-bd4e-279e9638e3bb\r\n' | socat - TCP:localhost:7379,shut-close", :acceptable_exit_codes => [0]) do |r|
        expect(r.stdout).to match(/nonpardoning/)
      end

      shell("printf '*2\r\n$3\r\nget\r\n$36\r\n6486ab96-4f8e-46cd-919f-c047e7fbe786\r\n' | socat - TCP:localhost:7379,shut-close", :acceptable_exit_codes => [0]) do |r|
        expect(r.stdout).to match(/nutritionist/)
      end

      shell("printf '*2\r\n$3\r\nget\r\n$36\r\n602697c2-fb76-469a-96e5-d58d8034d745\r\n' | socat - TCP:localhost:7379,shut-close", :acceptable_exit_codes => [0]) do |r|
        expect(r.stdout).to match(/prepurposing/)
      end

      shell("printf '*2\r\n$3\r\nget\r\n$36\r\n5876470c-7aac-4b06-9d82-c36341bbc9bf\r\n' | socat - TCP:localhost:7379,shut-close", :acceptable_exit_codes => [0]) do |r|
        expect(r.stdout).to match(/chansonniers/)
      end

      shell("printf '*2\r\n$3\r\nget\r\n$36\r\n2f141d2d-dd49-405f-9b96-247044ce8778\r\n' | socat - TCP:localhost:7379,shut-close", :acceptable_exit_codes => [0]) do |r|
        expect(r.stdout).to match(/secularising/)
      end

      shell("printf '*2\r\n$3\r\nget\r\n$36\r\n54d42574-d305-4a1a-9cfc-95118fee8c43\r\n' | socat - TCP:localhost:7379,shut-close", :acceptable_exit_codes => [0]) do |r|
        expect(r.stdout).to match(/homeomorphic/)
      end
                  
    end  

    it 'should recover all nodes' do
      shell("curl -s 127.0.0.2:11111 | python -c 'import sys, json; print json.load(sys.stdin)[\"curr_connections\"]'", :acceptable_exit_codes => [0]) do |r|
        expect(r.stdout).to match(/3/)
      end
    end

  end

end
