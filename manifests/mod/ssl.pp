# == Class: apache::mod::ssl
#
# Installs and enables the mod_ssl module
#
class apache::mod::ssl {
  # we use the anchor pattern here to make sure our resources dont go floating
  # off. we should re-evalute this when we are ready to drop 2.x support.
  anchor { 'apache::ssl::start':
    require => Class[apache],
    before  => [ File['ssl.conf'], Package['mod_ssl'] ],
  }

  package { 'mod_ssl': ensure => 'installed' }

  file { 'ssl.conf':
    ensure  => present,
    path    => "${::apache::confd_dir}/ssl.conf",
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    content => template('apache/ssl.conf.erb'),
    require => Package['mod_ssl'],
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
