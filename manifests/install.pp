class twemproxy::install (
  $version        = '0.4.0',
  $cflags_opts    = '-ggdb3 -O0',
  $debug_mode     = false,
  $debug_opts     = 'full'
){

  include stdlib
  include twemproxy::params
  include twemproxy::package
  include twemproxy::autoconf

  $prefix = $twemproxy::params::default_prefix

  validate_string($version)
  validate_string($cflags_opts)
  validate_bool($debug_mode)
  validate_string($debug_opts)

  $resource = "twemproxy-${version}"

  if $debug_mode {
    $cfgcmd = "CFLAGS=${cflags_opts} ./configure --enable-debug=${debug_opts}"
  } else {
    $cfgcmd = "CFLAGS=${cflags_opts} ./configure"
  }

  file { "${prefix}/src":
    ensure  => 'directory'
  } ->
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
  exec { "autoconf-${resource}":
    command => 'autoreconf -fvi',
    cwd     => "${prefix}/src/${resource}",
    creates => "${prefix}/src/${resource}/configure",
    path    => '/bin/:/usr/bin'
  } ->
  exec { "configure-${resource}":
    command => $cfgcmd,
    cwd     => "${prefix}/src/${resource}",
    creates => "${prefix}/src/${resource}/config.status",
    path    => '/bin/:/usr/bin'
  } ->
  exec { "make-${resource}":
    command => 'make && make install',
    cwd     => "${prefix}/src/${resource}",
    creates => "${prefix}/src/${resource}/src/nutcracker",
    path    => '/bin/:/usr/bin'
  }

}