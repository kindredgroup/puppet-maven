define maven::settings (
  $user,
  $path,
  $source = undef,
  $ensure = 'present'
) {

  validate_re($ensure, ['present', 'absent'], "Unsupport ensure value ${ensure}. Valid values: present, absent")

  $directory_ensure = $ensure ? {
    present => directory,
    default => $ensure
  }

  $directory = dirname($path)

  file { $directory:
    ensure  => $directory_ensure,
    owner   => $user,
    group   => $user,
    mode    => '0755'
  }

  exec { "validate_${name}":
    command     => "xmllint --noout ${path}",
    path        => ['/bin', '/usr/bin'],
    refreshonly => true,
  }

  case $source {
    undef: {
      concat { $path:
        ensure  => $ensure,
        owner   => $user,
        group   => $user,
        require => File[$directory],
        notify  => Exec["validate_${name}"]
      }

      @concat::fragment { "01_${name}":
        target  => $path,
        content => template("${module_name}/01_settings_header_xml.erb"),
        order   => '01',
        tag     => $name
      }

      @concat::fragment { "02_${name}":
        target  => $path,
        content => template("${module_name}/02_settings_mirror_start_xml.erb"),
        order   => '02',
        tag     => $name
      }

      @concat::fragment { "04_${name}":
        target  => $path,
        content => template("${module_name}/04_settings_mirror_stop_xml.erb"),
        order   => '04',
        tag     => $name
      }

      @concat::fragment { "05_${name}":
        target  => $path,
        content => template("${module_name}/05_settings_profile_start_xml.erb"),
        order   => '05',
        tag     => $name
      }

      @concat::fragment { "07_${name}":
        target  => $path,
        content => template("${module_name}/07_settings_profile_stop_xml.erb"),
        order   => '07',
        tag     => $name
      }

      @concat::fragment { "08_${name}":
        target  => $path,
        content => template("${module_name}/08_settings_server_start_xml.erb"),
        order   => '08',
        tag     => $name
      }

      @concat::fragment { "10_${name}":
        target  => $path,
        content => template("${module_name}/10_settings_server_stop_xml.erb"),
        order   => '10',
        tag     => $name
      }
 
      @concat::fragment { "99_${name}":
        target  => $path,
        content => template("${module_name}/99_settings_footer_xml.erb"),
        order   => '99',
        tag     => $name
      }

      if $ensure == present {
        Concat::Fragment <| tag == $name |>
      }
    }
    default: {
      file { $path:
        ensure  => $ensure,
        owner   => $user,
        group   => $user,
        mode    => '0644',
        source  => $source,
        notify  => Exec["validate_${name}"]
      }
    }
  }

}
