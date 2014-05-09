# == Class: apache::service
#
# Manages the httpd service.
# This class is not intended to be called directly, and is called inside of the
# primary apache class
#
class apache::service(
  $service_ensure = 'running',
  $service_enable = true,
  $service_name   = $::apache::params::service_name,
) {
  case type( $service_ensure ) {
    boolean: { validate_bool( $service_ensure ) }
    string: { validate_re( $service_ensure, [ 'noop', 'running', 'stopped' ] ) }
    default: { fail("invalid value '${service_ensure}' for \$service_ensure") }
  }
  $ensure_r = $service_ensure ? {
    'noop'  => undef,
    default => $service_ensure,
  }

  case type( $service_enable ) {
    boolean: { validate_bool( $service_enable ) }
    string: { validate_re( $service_enable, [ 'noop', 'manual' ] ) }
    default: { fail("invalid value '${service_enable}' for \$service_enable") }
  }
  $enable_r = $service_enable ? {
    'noop'  => undef,
    default => $service_enable,
  }

  service { 'httpd':
    ensure  => $ensure_r,
    name    => $service_name,
    enable  => $enable_r,
  }

  if $ensure_r {
    # make sure we subscribe to the vhosts
    Apache::Vhost<| |> ~> Service[httpd]
    File['/etc/httpd/conf/ports.conf'] ~> Service[httpd]
    File['/etc/httpd/conf/httpd.conf'] ~> Service[httpd]
  }
}
