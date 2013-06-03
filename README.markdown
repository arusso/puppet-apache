# apache Module #

This module manages apache, with emphasis on setting up virtual hosts and
managing ssl.

# Examples #

<pre><code>
  class { 'apache':
    ensure       => running,
    server_admin => 'webmaster@example.com',
    start        => true,
    version      => present,
  }

  apache::vhost { 'www.example.com':
    server_name  => 'www.example.com',
    server_alias => [ 'www-2.example.com',
                      'blog.example.com' ],
    ssl          => false,
  }
</code></pre>
 

License
-------

None

Contact
-------

Aaron Russo <arusso@berkeley.edu>

Support
-------

Please log tickets and issues at the
[Projects site](https://github.com/arusso/puppet-apache/issues/)
