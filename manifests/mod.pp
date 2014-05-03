# == define: apache::mod
#
# Handles installing packages and ensuring that apache is loaded prior to
# reaching this point in the code, which is important.
#
define apache::mod {
  # we need to ensure Class[apache] is loaded first before we get here. This
  # will fail when you've included an apache module (ie. apache::mod::ssl) prior
  # to the loading of apache itself (either "include apache" or
  # "class { 'apache': }").
  #
  # The solution is to a) write a wrapper that ensures you load apache first
  # before any other apache sub classes/defines, or b) always declare your
  # apache class higher in the manifest file before any sub classes.
  #
  # Example of Good:
  #
  # class { 'apache': }
  # apache::vhost { 'www.example.com': }
  # include apache::mod::ssl
  #
  # Example of Bad:
  #
  # include apache::mod::ssl
  # class { 'apache': }
  if ! defined( Class[apache] ) {
    fail('You must ensure apache is defined prior to declaring other apache resources')
  }

  $mod_name = $title ? {
    'proxy_ajp'     => undef,
    'php'           => 'php',
    'secure_cookie' => undef,
    default         => "mod_${title}",
  }

  if $mod_name {
    ensure_packages( flatten( [ $mod_name ] ) )
  }
}
