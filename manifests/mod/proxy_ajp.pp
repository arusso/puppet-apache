# == Class: apache::mod::proxy_ajp
#
# Installs (if necessary) and enables mod_proxy_ajp
#
class apache::mod::proxy_ajp {
  file { '/etc/httpd/conf.d/module-proxy_ajp.conf':
    ensure  => 'link',
    target  => '/etc/httpd/conf.d/proxy_ajp.conf',
    require => File['/etc/httpd/conf.d/proxy_ajp.conf'],
  }

  file { '/etc/httpd/conf.d/proxy_ajp.conf':
    ensure => 'file',
    source => 'puppet:///apache/proxy_ajp.conf',
    mode   => '0444',
    owner  => 'root',
    group  => 'root',
  }
}
