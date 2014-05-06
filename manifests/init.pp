# == Class: apache
#
# Apache management class
#
# === Parameters
#
# [*server_admin*]
#   Email address of the admin for this server.  Used by apache to provide an
#   email address when the server encounters an error.
#
#  Usage:
#     server_admin = 'email@domain.com'
#
# [*service_enable*]
#   Whether to enable this service on boot or not. Setting to 'noop' will
#   instruct Puppet to leave the apache service alone.
#
#  Usage:
#     enable = '<true|false|noop>'
#
# [*service_ensure*]
#   Whether puppet should start the apache service if its not running.  To
#   have puppet not mess with the service, use 'noop'
#
#  Usage:
#     start = '<true|false|noop>'
#
# [*ports_file*]
#   File to store listen/namevirtualhost ports configuration in.
#   Defaults to /etc/httpd/conf/ports.conf
#
# [*config_file*]
#   Location of main httpd.conf file. Defaults to /etc/httpd/conf/httpd.conf
#
# [*config_template*]
#   Template to use when generating httpd.conf file. Defaults to os-specific erb
#   template based on which platform we're running on.
#
class apache(
  $server_admin = $::apache::params::server_admin,
  $service_enable = true,
  $service_ensure = 'running',
  $service_name = $::apache::params::service_name,
  $ports_file = $::apache::params::ports_file,
  $config_file = $::apache::params::config_file,
  # TODO: combine httpd.conf.* into a single httpd.conf
  $config_template = $::apache::params::config_template,
) inherits apache::params {
  anchor { 'apache::start':
    before => Package['httpd'],
  }
  ensure_packages(['httpd'])

  # only notify the service if we are managing the run state
  $service_notify = $service_ensure ? {
    'noop'  => undef,
    default => 'Class[apache::service]',
  }

  concat { $ports_file:
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => $service_notify,
    require => Package['httpd'],
  }

  class { '::apache::service':
    service_ensure => $service_ensure,
    service_enable => $service_enable,
    service_name   => $service_name,
  }

  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
  }
  exec { "mkdir ${confd_dir}":
    creates => $confd_dir,
    require => Package['httpd'],
  }
  file { $confd_dir:
    ensure  => 'directory',
    force   => true,
    purge   => true,
    recurse => true,
    notify  => $service_notify,
    require => Package['httpd'],
  }

  file { $config_file:
    ensure  => 'file',
    content => template( $config_template ),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File[$confd_dir],
  }

  anchor { 'apache::end':
    require => File[$config_file],
  }
}
