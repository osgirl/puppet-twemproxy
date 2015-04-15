class twemproxy::service (
  $service_name   = $::twemproxy::params::default_service_name,
  $service_enable = true,
  $service_ensure = 'running',
  $service_manage = true,
) {

  validate_bool($service_enable)
  validate_bool($service_manage)

  case $service_ensure {
    true, false, 'running', 'stopped': {
      $_service_ensure = $service_ensure
    }
    default: {
      $_service_ensure = undef
    }
  }
  if $service_manage {
    service { 'nutcracker':
      ensure => $_service_ensure,
      name   => $service_name,
      enable => $service_enable,
    }
  }
}
