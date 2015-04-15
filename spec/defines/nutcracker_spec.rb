require 'spec_helper'

$node_name = 'nutcracker'

describe 'twemproxy::resource::nutcracker', :type=>'define' do

  let(:node) { $node_name }
  let(:title) { $node_name }
  let(:facts) {{
    :osfamily => 'RedHat',
    :operatingsystem => 'Centos',
    :operatingsystemrelease => '6.5',
    :kernel => 'Linux'
  }}

  context 'on a Centos 6.5 OS with default values' do
    let(:facts) {{
      :osfamily => 'RedHat',
      :operatingsystem => 'Centos',
      :operatingsystemrelease => '6.5',
      :kernel => 'Linux'
    }}

    let(:params) {{
      :port                 => 7777,
      :nutcracker_hash      => 'one_at_a_time',
      :nutcracker_hash_tag  => 'banana',
      :distribution         => 'random',
      :twemproxy_timeout    => 400,
      :auto_eject_hosts     => false,
      :server_retry_timeout => 1000,
      :server_failure_limit => 5,
      :redis                => true,
      :members => [
           { 
              'ip'         => '127.0.0.1',
              'name'       => 'server1',
              'redis_port' => '6390',
              'weight'     => '1'
            },
            { 
              'ip'         => '127.0.0.1',
              'name'       => 'server2',
              'redis_port' => '6391',
              'weight'     => '1'
            },
            { 
              'ip'         => '127.0.0.1',
              'name'       => 'server3',
              'redis_port' => '6392',
              'weight'     => '1'
            }
      ]
        
    }}     
        
    it { should compile.with_all_deps }        
    it { should contain_class('twemproxy::install') }
    it { should contain_class('twemproxy::service') }

    it { is_expected.to contain_service("twemproxy").with(
       'name'   => 'nutcracker',
       'ensure' => 'running',
       'enable' => 'true'
     )
    }   
  
    it { should create_file('/var/log/nutcracker') }
    it { should create_file('/var/run/nutcracker') }

    it { should create_file('/etc/nutcracker') }
    it { should create_file('/etc/nutcracker/nutcracker.yml') }
    it { should contain_file('/etc/nutcracker/nutcracker.yml').with_content(/nutcracker:/) }    
    it { should contain_file('/etc/nutcracker/nutcracker.yml').with_content(/  listen: 0.0.0.0:7777/) }    
    it { should contain_file('/etc/nutcracker/nutcracker.yml').with_content(/  hash: one_at_a_time/) }    
    it { should contain_file('/etc/nutcracker/nutcracker.yml').with_content(/  hash_tag: "banana"/) }    
    it { should contain_file('/etc/nutcracker/nutcracker.yml').with_content(/  distribution: random/) }    
    it { should contain_file('/etc/nutcracker/nutcracker.yml').with_content(/  timeout: 400/) }    
    it { should contain_file('/etc/nutcracker/nutcracker.yml').with_content(/  auto_eject_hosts: false/) }    
    it { should contain_file('/etc/nutcracker/nutcracker.yml').with_content(/  server_retry_timeout: 1000/) } 
    it { should contain_file('/etc/nutcracker/nutcracker.yml').with_content(/  server_failure_limit: 5/) } 
    it { should contain_file('/etc/nutcracker/nutcracker.yml').with_content(/  redis: true/) } 

    it { should contain_file('/etc/nutcracker/nutcracker.yml').with_content(/    - 127.0.0.1:6390:1 server1/) } 
    it { should contain_file('/etc/nutcracker/nutcracker.yml').with_content(/    - 127.0.0.1:6391:1 server2/) } 
    it { should contain_file('/etc/nutcracker/nutcracker.yml').with_content(/    - 127.0.0.1:6392:1 server3/) }    

    it { should create_file('/etc/init.d/nutcracker') }
    it { should contain_file('/etc/init.d/nutcracker').with_content(/NAME=nutcracker/) }    
         
  end

end
