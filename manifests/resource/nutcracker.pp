define twemproxy::resource::nutcracker (
  $auto_eject_hosts     = false,
  $distribution         = 'ketama',
  $ensure               = 'present',
  $log_dir              = '/var/log/nutcracker',
  $members              = '',
  $nutcracker_hash      = 'fnv1a_64',
  $nutcracker_hash_tag  = '',
  $pid_dir              = '/var/run/nutcracker',
  $port                 = '22111',
  $redis                = true,
  $server_retry_timeout = '2000',
  $server_failure_limit = '3',
  $statsport            = '21111',
  $twemproxy_timeout    = '300'
) {

  if ! defined(File['/etc/nutcracker']) {
    file { '/etc/nutcracker':
      ensure  => 'directory',
      mode    => '0755',
    }
  }

  if ! defined(File["${log_dir}"]) {
    file { "${log_dir}":
      ensure  => 'directory',
      mode    => '0755',
    }
  }

  if ! defined(File["${pid_dir}"]) {
    file { "${pid_dir}":
      ensure  => 'directory',
      mode    => '0755',
    }
  }

  file { "/etc/nutcracker/${name}.yml":
    ensure  => present,
    content => template('twemproxy/pool.erb', 'twemproxy/members.erb')
  }



}