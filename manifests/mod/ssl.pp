# == Class: apache::mod::ssl
#
# Installs and enables the mod_ssl module
#
class apache::mod::ssl {
  if !defined( Class['Apache'] ) {
    fail('you must include apache first!')
  }

  package { 'mod_ssl': ensure => 'installed' }

  file { "${::apache::confd_dir}/ssl.conf":
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    content => template('apache/ssl.conf.erb'),
  }

  file { "${::apache::confd_dir}/module-ssl.conf":
    ensure => 'link',
    target => "${::apache::confd_dir}/ssl.conf",
  }
}
