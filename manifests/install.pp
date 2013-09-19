# == Class: apache::install
#
# Manages the required packages for apache.
#
# This class should not be called directly, and is called inside of the primary
# apache class
#
class apache::install {
  package { $apache::package_name: ensure => 'present' }
}
