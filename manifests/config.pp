#== Class: apache::config
#
# Manages the apache conf.d directory, as well as the
# primary apache configuration file (httpd.conf).
#
# This class should not be called directly, and is called
# inside of the primary apache class.
#
class apache::config {
  require ::apache::params

  $config_template = $apache::params::config_template
  $config_file = $apache::params::config_file
  validate_array($apache::listen_ips)
  $listen_ipaddrs = $apache::listen_ips
  $conf_d_dir = $apache::params::conf_d_dir

  file { $conf_d_dir:
    ensure  => 'directory',
    force   => true,
    purge   => true,
    recurse => true,
  }

  file { $config_file:
    ensure  => 'file',
    content => template( $config_template ),
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
  }
}
