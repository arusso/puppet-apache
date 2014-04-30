# == Class: apache::mod::ssl
#
# Installs and enables the mod_ssl module
#
class apache::mod::ssl {
  require ::apache
  require ::apache::params

  validate_array($::apache::listen_ips)
  $listen_ipaddrs = $::apache::listen_ips

  package { 'mod_ssl': ensure => 'installed' }

  file { "${apache::params::conf_d_dir}/ssl.conf":
    owner  => 'root',
    group  => 'root',
    mode   => '0444',
    content => template('apache/ssl.conf.erb'),
  }

  file { "${apache::params::conf_d_dir}/module-ssl.conf":
    ensure => 'link',
    target => "${apache::params::conf_d_dir}/ssl.conf",
  }
}
