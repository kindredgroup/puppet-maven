define maven::settings (
  $directory,
  $source = undef,
  $mirrors = [],
  $profiles = [],
  $servers = [],
  $ensure = 'present'
) {

  validate_re($ensure, ['present', 'absent'], "Unsupport ensure value ${ensure}. Valid values: present, absent")

  $user = $name

  $directory_ensure = $ensure ? {
    present => directory,
    default => $ensure
  }

  $directory_path = "${directory}/${user}/.m2"
  $settings_xml_path = "${directory_path}/settings.xml"

  file { $directory_path:
    ensure  => $directory_ensure,
    owner   => $user,
    group   => $user,
    mode    => '0755'
  }

  file { $settings_xml_path:
    ensure  => $ensure,
    owner   => $user,
    group   => $user,
    mode    => '0644',
    notify  => Exec["validate_settings_xml_${name}"]
  }

  if $source {
    File[$settings_xml_path] {
      source  => $source
    }
  } else {
    File[$settings_xml_path] {
      content => template("${module_name}/settings_xml.erb")
    }
  }

  exec { "validate_settings_xml_${name}":
    command     => "xmllint --noout ${path}",
    path        => ['/bin', '/usr/bin'],
    refreshonly => true,
  }

}
