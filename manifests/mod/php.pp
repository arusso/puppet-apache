# == Class: apache::mod::php
#
#
class apache::mod::php {
  ::apache::mod { 'php': }

  file { '/etc/httpd/conf.d/php.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0444',
    replace => false,
    source  => 'puppet:///modules/apache/php.conf',
    notify  => Class['apache::service'],
  }

  file { '/etc/httpd/conf.d/module-php.conf':
    ensure => link,
    target => '/etc/httpd/conf.d/php.conf',
  }
}
