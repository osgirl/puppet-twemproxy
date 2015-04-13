class twemproxy::autoconf {

  include twemproxy::params

  $prefix = $twemproxy::params::default_prefix

  # at least for centos 6.5 & 6.6 this is the minimum required version
  $resource = 'autoconf-2.64'

  file { "${prefix}/src/${resource}.tar.gz":
    ensure => 'file',
    source => "puppet:///modules/twemproxy/${resource}.tar.gz"
  } ->
  exec { "tar-xvfz-${resource}":
    command => "tar xvzf ${resource}.tar.gz",
    cwd     => "${prefix}/src",
    creates => "${prefix}/src/${resource}",
    path    => '/bin/:/usr/bin'
  } ->
  exec { "configure-${resource}":
    command => './configure',
    cwd     => "${prefix}/src/${resource}",
    creates => "${prefix}/src/${resource}/config.status",
    path    => '/bin/:/usr/bin'
  } ->
  exec { "make-${resource}":
    command => 'make && make install',
    cwd     => "${prefix}/src/${resource}",
    creates => "${prefix}/src/${resource}/bin/autoconf",
    path    => '/bin/:/usr/bin'
  }

}