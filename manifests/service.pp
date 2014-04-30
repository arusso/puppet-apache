# == Class: apache::service
#
# Manages the httpd service.
# This class is not intended to be called directly, and is called inside of the
# primary apache class
#
class apache::service {
  require ::apache
  $service = $apache::service_name

  case bool2str( $apache::enable, false) {
    'true','false': { $enable = $apache::enable }
    /(noop|absent)/: { $enable = undef }
    default: { fail("invalid value for apache::enable: ${apache::enable}")}
  }

  case bool2str( $apache::start, false ) {
    'true': { $ensure = 'running' }
    'false': { $ensure = 'stopped' }
    /(noop|absent)/: { $ensure = undef }
    default: { fail("invalid value for apache::start: ${apache::start}")}
  }

  service { 'httpd':
    ensure  => $ensure,
    name    => $service,
    enable  => $enable,
    require => Class['apache::config'],
  }
}
