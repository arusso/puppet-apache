# apache Module #

This module manages apache with particular emphasis on providing mechanisms to
allow for unmanaged (by Puppet) configuration of virtual hosts.

# Examples #

```puppet
  # configure the global apache
  class { 'apache':
    start        => true,
    enable       => true,
    server_admin => 'webmaster@example.com',
  }

  # setup a vhost for www.example.com, mark it as the default vhost and
  # add a few aliases.
  apache::vhost { 'www.example.com':
    is_default   => true,
    server_name  => 'www.example.com',
    server_alias => [ 'www-2.example.com',
                      'blog.example.com' ],
    ssl          => false,
  }

  # if server_name is not specified, the $namevar is used. So in this case
  # server_name = 'www2.example.com'.  This one has ssl setup using a
  # self-signed cert (since not intermedaite cert is provided).
  apache::vhost { 'www2.example.com':
    ssl          => true,
    ssl_key_file => '/etc/pki/tls/private/private.key',
    ssl_crt_file => '/etc/pki/tls/certs/public.crt',
  }

  # another ssl example, this time with an intermediate cert being provided
  apache::vhost { 'www3.example.com:
    ssl          => true,
    ssl_key_file => '/etc/pki/tls/private/private.key',
    ssl_crt_file => '/etc/pki/tls/certs/public.crt',
    ssl_int_file => '/etc/pki/tls/certs/intermediate.crt',
  }
```
 
License
-------

See LICENSE file

Copyright
---------

Copyright &copy; 2013 The Regents of the University of California

Contact
-------

Aaron Russo <arusso@berkeley.edu>

Support
-------

Please log tickets and issues at the
[Projects site](https://github.com/arusso/puppet-apache/issues/)
