define twemproxy::resource::nutcracker (
  $ensure               = 'present',
  $port                 = '22111',
  $nutcracker_hash      = 'fnv1a_64',
  $nutcracker_hash_tag  = '{}',
  $distribution         = 'ketama',
  $twemproxy_timeout    = '300',
  $auto_eject_hosts     = false,
  $server_retry_timeout = '2000',
  $server_failure_limit = '3',
  $redis                = true,
  
  $log_dir              = '/var/log/nutcracker',
  $pid_dir              = '/var/run/nutcracker',
  $statsport            = '21111',
  $members              = undef,

  $service_enable       = true,
  $service_manage       = true,
  $service_ensure       = 'running'
) {

  include stdlib
  include twemproxy::install

  #
  # installed service name derived from $name
  # i.e. File[/etc/init.d/nutcracker]/notify: subscribes to Service[twemproxy]
  #

  if !is_integer($port) {
    fail('$port must be an integer.')
  }
  validate_string($nutcracker_hash)
  validate_string($nutcracker_hash_tag)
  validate_string($distribution)
  if !is_integer($twemproxy_timeout) {
    fail('$twemproxy_timeout must be an integer.')
  }
  validate_bool($auto_eject_hosts)
  if !is_integer($server_retry_timeout) {
    fail('$server_retry_timeout must be an integer.')
  }
  if !is_integer($server_failure_limit) {
    fail('$server_failure_limit must be an integer.')
  }
  validate_bool($redis)
  validate_absolute_path($log_dir)
  validate_absolute_path($pid_dir)
  if !is_integer($statsport) {
    fail('$statsport must be an integer.')
  }
  validate_array($members)
  validate_bool($service_enable)
  validate_bool($service_manage)

  class { '::twemproxy::service':
    service_name   => $name,
    service_enable => $service_enable,
    service_manage => $service_manage,
    service_ensure => $service_ensure
  }

  notify { "Working with ${distribution} ${nutcracker_hash} on ${port}": }

  if ! defined(File['/etc/nutcracker']) {
    file { '/etc/nutcracker':
      ensure => 'directory',
      mode   => '0755'
    }
  }

  if ! defined(File[$log_dir]) {
    file { $log_dir:
      ensure => 'directory',
      mode   => '0755'
    }
  }

  if ! defined(File[$pid_dir]) {
    file { $pid_dir:
      ensure => 'directory',
      mode   => '0755'
    }
  }

  $service_template_os_specific = $::osfamily ? {
    'RedHat' => 'twemproxy/nutcracker-redhat.erb',
    'Debian' => 'twemproxy/nutcracker.erb',
    default  => 'twemproxy/nutcracker.erb',
  }

  file { "/etc/nutcracker/${name}.yml":
    ensure  => present,
    content => template('twemproxy/pool.erb', 'twemproxy/members.erb')
  } ->
  file { "/etc/init.d/${name}":
    ensure  => present,
    mode    => '0755',
    content => template($service_template_os_specific),
    require => [ Anchor['twemproxy::install::end'], File[$log_dir], File[$pid_dir] ]
  } ->
  Service[$::twemproxy::params::default_service_name]
}