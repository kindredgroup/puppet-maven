class maven::package {

  if $::maven::install_from_package {
    package { $::maven::package:
      ensure  => $::maven::package_ensure
    }
  } else {
    $url_to_file = "${::maven::wget_url}/${::maven::package_ensure}/binaries/apache-maven-${::maven::package_ensure}-bin.tar.gz"
    ensure_packages(['wget'])
    exec { 'install_maven_from_tar_gz':
      command => "wget -O - ${url_to_file} | tar zxf -",
      path    => ['/bin', '/usr/bin', '/usr/local/bin'],
      cwd     => '/opt',
      creates => "/opt/apache-maven-${::maven::package_ensure}",
      require => Package['wget']
    }
  }

}
