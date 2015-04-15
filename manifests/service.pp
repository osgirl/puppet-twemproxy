class twemproxy::service (
  $service_ensure = 'running',
  $service_name   = undef,
  $service_enable = true,
  $service_manage = true,
) {

  validate_re($service_ensure, '^(running|stopped)$',
      "Invalid service_ensure value '${service_ensure}'. Expected 'running' or 'stopped'")
  validate_string($service_name)
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
    service { $::twemproxy::params::default_service_name:
      ensure => $_service_ensure,
      name   => $service_name,
      enable => $service_enable,
    }
  }
}
