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
      :members   => []

    }}     
        
    it { should compile.with_all_deps }        
    it { should contain_class('twemproxy::install') }
  
  
  end

end
