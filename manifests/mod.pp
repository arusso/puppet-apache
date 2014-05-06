# == define: apache::mod
#
# Handles installing packages and ensuring that apache is loaded prior to
# reaching this point in the code, which is important.
#
define apache::mod {
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
