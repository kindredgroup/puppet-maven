# == Class: maven
#
# Installs maven from package or tar.gz from upstream
# 
# === Parameters
#
# Document parameters here.
#
# [*ensure*]
#   Ensurable
#   Valid values: present, absent
#
# [*install_from_package*]
#   If tar.gz should be fetched from upstream, or package installed
#   Valid values: boolean
#
# [*package*]
#   If installing from package, name of package(s)
#   Valid values: string or array of strings
#
# [*package_ensure*]
#   If installing from package, <version>, latest, present
#   If installing from tar.gz, <version>
#   Valid values: string
#
# [*wget_url*]
#   URL to download the package from
#   Valid values: string
#
# === Examples
#
#  class { '::maven':
#    ensure         => present,
#    package_ensure => '3.1.1'
#  }
#
# === Authors
#
# Johan Lyheden <johan.lyheden@unibet.com>
#
# === Copyright
#
# Copyright 2014 North Development AB
#
class maven (
  $ensure               = 'present',
  $install_from_package = false,
  $package              = undef,
  $package_ensure       = 'present',
  $wget_url             = $maven::params::wget_url,
) inherits ::maven::params {

  anchor { '::maven::begin': } ->
  class { '::maven::package': } ->
  anchor { '::maven::end': }

}
