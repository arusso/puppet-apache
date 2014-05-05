define apache::listen {
  if ! defined( Class[Apache::Params] ) {
    fail('you must include Class[Apache::Params] before using apache resources')
  }

  $listen_addr_port = $name

  concat::fragment { "Listen ${listen_addr_port}":
    ensure  => present,
    target  => $::apache::params::ports_file,
    content => template('apache/listen.erb'),
  }
}
