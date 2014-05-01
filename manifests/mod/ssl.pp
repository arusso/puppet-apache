# == Class: apache::mod::ssl
#
# Installs and enables the mod_ssl module
#
class apache::mod::ssl {
  # this shouldn't be needed, but it'll prevent any mis-configurations by
  # failing early if for some reason apache isn't defined first. this code
  # should be re-evaluted once we get to Puppet 3.x
  if !defined( Class['Apache'] ) {
    fail('you must include apache first!')
  }

  package { 'mod_ssl': ensure => 'installed' }

  anchor { 'apache::ssl::start':
    require => Class[apache],
    before  => File['ssl.conf'],
  }

  file { 'ssl.conf':
    ensure  => present,
    path    => "${::apache::confd_dir}/ssl.conf",
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    content => template('apache/ssl.conf.erb'),
    before  => File['module-ssl.conf'],
  }

  file { 'module-ssl.conf':
    ensure => 'link',
    path   => "${::apache::confd_dir}/module-ssl.conf",
    target => "${::apache::confd_dir}/ssl.conf",
  }

  anchor { 'apache::ssl::end':
    require => File['module-ssl.conf'],
  }
}
