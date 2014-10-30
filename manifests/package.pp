class maven::package {

  if $install_from_package {
    package { $::maven::package_name:
      ensure  => $::maven::package_ensure
    }
  } else {
    $url_to_file = "${::maven::wget_url}/${::maven::package_ensure}/binaries/apache-maven-${::maven::package_ensure}-bin.tar.gz"
    ensure_packages(['wget']) ->
    exec { 'install_maven_from_tar_gz':
      command => "wget -O - ${url_to_file} | tar zxf -",
      cwd     => '/opt',
      creates => "/opt/apache-maven-${::maven::package_ensure}"
    }
  }

}
