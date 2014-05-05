# == Class: apache::mod::ssl
#
# Installs and enables the mod_ssl module
#
class apache::mod::ssl {
  ::apache::mod { 'ssl': }

  file { 'ssl.conf':
    ensure  => present,
    path    => "${::apache::confd_dir}/ssl.conf",
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    content => template('apache/ssl.conf.erb'),
    require => Apache::Mod[ssl],
    before  => File['module-ssl.conf'],
  }

  file { 'module-ssl.conf':
    ensure => 'link',
    path   => "${::apache::confd_dir}/module-ssl.conf",
    target => "${::apache::confd_dir}/ssl.conf",
  }
}
