# == Class: apache::namevirtualhost
#
# Sets up NameVirtualHost entries
#
class apache::namevirtualhost {
  $conf_d_dir = params_lookup('conf_d_dir', false, $apache::params::conf_d_dir)

  # not technically a module, but we really just need it to load before all the
  # virtual host definitions
  file { "${conf_d_dir}/module-namevirtualhost.conf":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    content => "NameVirtualHost *:80\nNameVirtualHost *:443\n",
    notify  => Class['apache::service'],
  }
}
