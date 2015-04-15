require 'spec_helper'

$node_name = 'test1.domain'

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
      :name                 => 'nutcracker',
      :port                 => 7777,
      :nutcracker_hash      => 'one_at_a_time',
      :nutcracker_hash_tag  => 'banana',
      :distribution         => 'random',
      :twemproxy_timeout    => 400,
      :auto_eject_hosts     => false,
      :server_retry_timeout => 1000,
      :server_failure_limit => 5,
      :redis                => true,


      :members              => {}
 
    }}     
        
    it { should compile.with_all_deps }        
    it { should contain_class('twemproxy::install') }
  
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

  end

end
