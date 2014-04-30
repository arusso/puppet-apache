define apache::namevirtualhost {
  if ! defined( Class[Apache::Params] ) {
    fail('You must include Class[Apache::Params] before using any apache resource')
  }

  $nvh_addr_port = $name

  concat::fragment { "Namevirtualhost ${nvh_addr_port}":
    ensure  => present,
    target  => $::apache::params::ports_file,
    content => template('apache/namevirtualhost.erb'),
  }
}
