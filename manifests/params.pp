# == Class: apache::params
#
# This class keeps all the class defaults, as well as serves the purpose of
# containing a large portion of the OS logic required for this module
#
class apache::params {

  case $::osfamily {
    #
    # RedHat Family OSes
    #
    'RedHat': {
      case $::operatingsystemrelease {
          /^5\.[0-9]+$/: { $config_template = 'apache/httpd.conf.erb.el5' }
          /^6\.[0-9]+$/: { $config_template = 'apache/httpd.conf.erb.el6' }
          default: { fail("Unsupported ${::osfamily} version!") }
      }
      $server_root = '/etc/httpd'
      $conf_dir = "${server_root}/conf"
      $confd_dir = "${server_root}/conf.d"
      $vhost_dir = $confd_dir
      $config_file = "${conf_dir}/httpd.conf"
      $package_name = 'httpd'
      $service_name = 'httpd'
    }

    #
    # Unsupported OSes
    #
    default: {
      fail("\${::osfamily} = '${::osfamily}' not supported!")
    } # case default
  } # case $::osfamily

  $is_default = false
  $server_admin = 'root@localhost'
  $document_root = '/var/www/html'
  $ssl = false
  $ssl_cert_resource = 'UNSET'
  $provide_include = true
  $ports_file = "${conf_dir}/ports.conf"

} # $apache::params
