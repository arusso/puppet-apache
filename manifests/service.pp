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
  service { 'httpd':
    ensure  => $service_ensure,
    name    => $service_name,
    enable  => $service_enable,
  }
}
