# == Class: apache::mod::ssl
#
# Installs and enables the mod_ssl module
#
class apache::mod::ssl {
  require ::apache::params

  ::apache::mod { 'ssl': }

  file { 'ssl.conf':
    ensure  => present,
    path    => "${::apache::params::confd_dir}/ssl.conf",
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    content => template('apache/ssl.conf.erb'),
    require => Apache::Mod[ssl],
    before  => File['module-ssl.conf'],
  }

  file { 'module-ssl.conf':
    ensure => 'link',
    path   => "${::apache::params::confd_dir}/module-ssl.conf",
    target => "${::apache::params::confd_dir}/ssl.conf",
  }
}
