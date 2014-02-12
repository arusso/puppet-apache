# == Class: apache::mod::secure_cookie
#
# Enables secure cookies in the HTML header using the method for apache2 < v2.2.24
#
class apache::mod::secure_cookie {
  file { '/etc/httpd/conf.d/secure_cookie.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0444',
    replace => false,
    source  => 'puppet:///modules/apache/secure_cookie.conf',
    notify  => Class['apache::service'],
  }

  file { '/etc/httpd/conf.d/module-secure_cookie.conf':
    ensure => link,
    target => '/etc/httpd/conf.d/secure_cookie.conf',
  }
}
