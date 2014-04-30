# == Class: apache
#
# Apache management class
#
# === Parameters
#
# [*enable*]
#   Whether to enable this service on boot or not. Setting to 'noop' will
#   instruct Puppet to leave the apache service alone.
#
#  Usage:
#     enable = '<true|false|noop>'
#
# [*server_admin*]
#   Email address of the admin for this server.  Used by apache to provide an
#   email address when the server encounters an error.
#
#  Usage:
#     server_admin = 'email@domain.com'
#
# [*start*]
#   Whether puppet should start the apache service if its not running.  To
#   have puppet not mess with the service, use 'noop'
#
#  Usage:
#     start = '<true|false|noop>'
#
# [*listen_ips*]
#   The IP addresses puppet should configure apache to listen on. Provide as an
#   array. The default will have Apache listen on all configured IP addresses.
#
#  Usage:
#     listen_ips = ['127.0.0.1', ...]
#
class apache(
  $enable = $apache::params::enable,
  $server_admin = $apache::params::server_admin,
  $start = $apache::params::start,
  $listen_ips = $apache::params::listen_ips,
) inherits apache::params {
  include apache::install,apache::config,apache::service

  anchor { 'apache::start': }
  anchor { 'apache::end': }

  Anchor[apache::start] ->
    Class[apache::install] ->
    Class[apache::config] ~>
    Class[apache::service] ->
    Anchor[apache::end]
}
