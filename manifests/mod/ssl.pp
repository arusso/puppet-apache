# == Class: apache::mod::ssl
#
# Installs and enables the mod_ssl module
#
class apache::mod::ssl {
  package { 'mod_ssl': ensure => 'installed' }

  file { "${apache::params::conf_d_dir}/ssl.conf":
    owner  => 'root',
    group  => 'root',
    mode   => '0444',
    source => 'puppet:///apache/ssl.conf',
  }

  file { "${apache::params::conf_d_dir}/module-ssl.conf":
    ensure => 'link',
    target => "${apache::params::conf_d_dir}/ssl.conf",
  }
}
