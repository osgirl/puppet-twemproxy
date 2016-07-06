require 'spec_helper'

$node_name = 'test1.domain'

describe 'twemproxy::install', :type=>'class' do

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
    it { should contain_class('twemproxy::params') }
    it { should contain_class('twemproxy::package') }
    it { should contain_class('twemproxy::autoconf') }

    it { should contain_package('automake') }
    it { should contain_package('libtool') }

    it { should create_file('/usr/local/src') }
    it { should create_file('/usr/local/src/twemproxy-0.4.1.tar.gz') }

    it { should contain_exec('tar-xvfz-twemproxy-0.4.1') }
    it { should contain_exec('autoconf-twemproxy-0.4.1') }
    it { should contain_exec('configure-twemproxy-0.4.1') }
    it { should contain_exec('make-twemproxy-0.4.1') }

  end

  context 'on a Centos 6.5 OS with debug true' do
    let(:facts) {{
      :osfamily => 'RedHat',
      :operatingsystem => 'Centos',
      :operatingsystemrelease => '6.5',
      :kernel => 'Linux'
    }}
    let(:params) {{
      :debug_mode   =>  true
    }}

    it { should compile.with_all_deps }

  end

end
