# == Define: apache::vhost
#
# Defines an apache vhost
#
# === Parameters:
#
# [*document_root*]
#   VirtualHosts document root.  We do not attempt to manage this directory
#   in any way -- we just tell apache to look there.
#
#  Usage:
#    document_root = '/path/to/doc/root'
#
# [*ip*]
#    IP address to listen on for HTTP traffic. Defaults to '*'.
#
# [*is_default*]
#   Distinguishes the vhost as the default one, naming the configuration file
#   appropriately such that it will come before non-default vhosts. Multiple
#   vhosts with is_default set will resort to sorting by $name.
#
#  Usage:
#    is_default = true
#  or
#    is_default = false
#
# [*port*]
#   TCP port to listen on for HTTP traffic. Defaults to 80.
#
# [*provide_include*]
#   Provide .include files that can be used in conjunction with sudoer rules
#   that we wont override (only place if they dont exist). Default is true.
#
# [*raw*]
#   (string) arbitrary config directives to be placed in the non-ssl vhost
#
# [*server_alias*]
#   Comma seperated or array value of the hostnames that this this virtual host
#   respond to.
#
#  Usage:
#    server_alias = [ 'host1.example.com', 'host2.example.com' ]
#  or
#    server_alias = 'host1.example.com,host2.example.com'
#
# [*server_name*]
#   String indicating the primary hostname for this vhost.
#
#  Usage:
#    server_name = 'host.example.com'
#
# [*ssl*]
#   Boolean indicating whether we should enable SSL for this vhost
#
#  Usage:
#    ssl = true
#  or
#    ssl = 'true'
#
# [*ssl_crt_file*]
#   String location of the SSL certificate file
#
#  Usage:
#    ssl_crt_file = '/etc/pki/tls/certs/host.example.com.crt'
#
# [*ssl_cert_resource*]
#   Name of SSL::Cert object to depend on.  Defaults to $namevar.  If set to
#   'noset', no dependency is created.
#
# [*ssl_key_file*]
#   String location of the SSL key file
#
#  Usage:
#    ssl_key_file = '/etc/pki/tls/private/host.example.com.key'
#
# [*ssl_int_file*]
#   String location of the SSL intermediate certificate chain.  If this is not
#   set, the SSLCertificateChainFile directive is not set.  Use this when you
#   have a self-signed cert, or you haven't installed the intermediate cert from
#   your signing CA.
#
#  Usage:
#    ssl_int_file = '/etc/pki/tls/certs/intermediate.crt'
#
# [*ssl_ip*]
#   IP address to listen on for HTTPS traffic. Defaults to '*'.
#
# [*ssl_port*]
#   TCP port to listen on for HTTPS traffic. Default to 443.
#
# [*ssl_raw(]
#   (string) Arbitrary config data that can be inserted into the ssl
#   virtualhost
#
# [*vhost_conf_source*]
#   Specify the puppet filepath to a static vhost configuration file. Note that
#   if vhost_conf_template is set, this will have no effect.
#
# [*vhost_conf_template*]
#   Specify the template to use instead of the built-in vhost template
#
# === Example:
#
# apache::vhost { 'www.example.com':
#    server_alias => [ 'example.com' ],
# }
#
# apache::vhost { 'app.example.com':
#   server_alias     => [ 'app-prod.example.com' ],
#   ssl              => true,
#   ssl_key_file     => '/etc/pki/tls/private/app-prod.example.com.key',
#   ssl_crt_file     => '/etc/pki/tls/certs/app-prod.example.com.crt',
#   ssl_int_file     => '/etc/pki/tls/certs/intermediate.crt,
#   ssl_crt_resource => 'noset',
# }
define apache::vhost (
  $ip = '*',
  $is_default = $apache::params::is_default,
  $port = '80',
  $document_root = $apache::params::document_root,
  $provide_include = 'UNSET',
  $raw = 'UNSET',
  $server_alias = undef,
  $server_name = $name,
  $ssl = false,
  $ssl_ip = '*',
  $ssl_port = '443',
  $ssl_raw = 'UNSET',
  $ssl_cert_resource = $apache::params::ssl_cert_resource,
  $ssl_crt_file = undef,
  $ssl_key_file = undef,
  $ssl_int_file = undef,
  $vhost_conf_source = 'UNSET',
  $vhost_conf_template = 'UNSET',
) {
  if !defined(Class['Apache::Params']) {
    fail('You must include Class[Apache::Params] before using Apache::Vhost resource')
  }

  ensure_resource('apache::listen', "${ip}:${port}")
  ensure_resource('apache::namevirtualhost', "${ip}:${port}")

  $provide_include_r = $provide_include ? {
    'UNSET' => $::apache::params::provide_include,
    default => any2bool($provide_include),
  }
  validate_bool( $provide_include_r )

  if $document_root { validate_absolute_path( $document_root ) }

  # Let's add our server_name to the server_alias array
  $server_alias_real = is_array( $server_alias) ? {
    true => unique(flatten([ $server_name, $server_alias])),
    default => unique(flatten([ $server_name, split( $server_alias, ',' )])),
  }
  validate_array( $server_alias_real )

  # Check our SSL parameters if we've enabled ssl
  $ssl_real = type( $ssl ) ? {
    string => any2bool( $ssl ),
    boolean => $ssl,
  }
  validate_bool( $ssl_real )

  $ord = $is_default ? { true => '0', default => '1' }

  $raw_config = $raw ? {
    'UNSET' => undef,
    default => $raw,
  }
  if $raw { validate_string($raw_config) }

  if $ssl_real {
    ensure_resource('apache::listen', "${ssl_ip}:${ssl_port}")
    ensure_resource('apache::namevirtualhost', "${ssl_ip}:${ssl_port}")

    # include our class to setup the ssl module for apache
    include apache::mod::ssl

    $ssl_cert_resource_r = $ssl_cert_resource ? {
      $apache::params::ssl_cert_resource => $name, # default is to use $name
      /(?i)^noset$/                      => undef, # dont set a dependency
      default                            => $ssl_cert_resource, # user input
    }
    if $ssl_cert_resource_r {
      validate_string( $ssl_cert_resource_r )
      Ssl::Cert[$ssl_cert_resource_r]->
      File["${apache::params::vhost_dir}/vhost-${ord}-${name}.conf"]
    }

    validate_absolute_path( $ssl_key_file )
    validate_absolute_path( $ssl_crt_file )
    # if we haven't downloaded the signed cert (or its self signed), we want to
    # be able to disable the intermediate file.  So if it's empty, lets not
    # worry about if thats the case
    if ! $ssl_int_file == undef { validate_absolute_path( $ssl_int_file ) }

    $ssl_raw_config = $ssl_raw ? {
      'UNSET' => undef,
      default => $ssl_raw,
    }
    if $ssl_raw { validate_string($ssl_raw_config) }

    # Our user-editable config file
    if $provide_include_r {
      file { "${apache::params::vhost_dir}/vhost-${name}.ssl.include":
        ensure  => 'file',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/apache/vhost.include',
        replace => false,
        } # vhost.ssl.include
    }
  } # if ssl_real

  # setup our vhost configuration file
  if $vhost_conf_template != 'UNSET' {
    # user specified a custom template
    $vhost_content_r = template( $vhost_conf_template )
    $vhost_source_r = undef
  } elsif $vhost_conf_source != 'UNSET' {
    # user specified a custom file source
    $vhost_source_r = $vhost_conf_source
    $vhost_content_r = undef
  } else {
    # user didn't specify crap, let's use the default template
    $vhost_source_r = undef
    $vhost_content_r = template('apache/vhost.conf.erb')
  }
  file { "${apache::params::vhost_dir}/vhost-${ord}-${name}.conf":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    content => $vhost_content_r,
    source  => $vhost_source_r,
  }

  # Our user-editable config file
  if $provide_include_r {
    file { "${apache::params::vhost_dir}/vhost-${name}.include":
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => 'puppet:///modules/apache/vhost.include',
      replace => false,
    }
  }
}
