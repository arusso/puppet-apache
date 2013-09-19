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
class apache(
  $enable = params_lookup( 'enable', false),
  $server_admin = params_lookup( 'server_admin', false ),
  $start = params_lookup( 'start', false ),
) inherits apache::params {
  class { 'apache::install': } ->
  class { 'apache::config': } ~>
  class { 'apache::service': } ->
  Class['apache']
}
