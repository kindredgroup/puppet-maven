define maven::settings::server (
  $id,
  $path,
  $username,
  $password,
  $tag_name,
  $ensure = 'present',
) {

  @concat::fragment { "09_${name}":
    target  => $path,
    content => template("${module_name}/09_settings_server_block_xml.erb"),
    order   => '09',
    tag     => $tag_name
  }

}
