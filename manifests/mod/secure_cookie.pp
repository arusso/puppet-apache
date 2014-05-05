# == Class: apache::mod::secure_cookie
#
# Enables secure cookies in the HTML header using the method for apache < 2.2.24
# This is actually a hack since this isn't actually a module, and should be
# remove when we build it into the apache class.
#
class apache::mod::secure_cookie {
  ::apache::mod { 'secure_cookie': }

  file { "${::apache::confd_dir}/secure_cookie.conf":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0444',
    replace => false,
    source  => 'puppet:///modules/apache/secure_cookie.conf',
    notify  => Class['apache::service'],
  }

  file { "${::apache::confd_dir}/module-secure_cookie.conf":
    ensure => link,
    target => "${::apache::confd_dir}/secure_cookie.conf",
  }
}
