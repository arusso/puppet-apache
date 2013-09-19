# == Class: apache::params
#
# This class keeps all the class defaults, as well as serves the purpose of
# containing a large portion of the OS logic required for this module
#
class apache::params {
  $start = true
  $enable = true
  $server_admin = "root@localhost"

  # DISTRO/VERSION DEPENDANT PARAMETER LOGIC

  case $::osfamily {
    # 
    # RedHat Family OSes
    #
    'RedHat': {
      case $::operatingsystemrelease {
          /^5\.[0-9]+$/: { $config_template = 'apache/httpd.conf.erb.el5' }
          /^6\.[0-9]+$/: { $config_template = 'apache/httpd.conf.erb.el6' }
      } 
      $package_name = 'httpd'
      $service_name = 'httpd'
      $server_root = '/etc/httpd'
      $conf_d_dir = "${server_root}/conf.d"
      $vhost_dir = "${server_root}/conf.d"
      $config_file = "${server_root}/conf/httpd.conf"
    }

    #
    # Unsupported OSes
    #
    default: {
      fail("\${::osfamily} = '${::osfamily}' not supported!")
    } # case default
  } # case $::osfamily
} # $apache::params
