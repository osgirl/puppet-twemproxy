require 'spec_helper'

$node_name = 'test1.domain'

describe 'twemproxy::autoconf', :type=>'class' do

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
        
    it { should compile.with_all_deps }        
  
    it { should create_file('/usr/local/src/autoconf-2.64.tar.gz') }

  end

end
