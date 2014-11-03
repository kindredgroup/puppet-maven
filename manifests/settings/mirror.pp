define maven::settings::mirror (
  $path,
  $id,
  $url,
  $mirror_of,
  $tag_name,
  $ensure = 'present'
) {

  @concat::fragment { "03_${name}":
    target  => $path,
    content => template("${module_name}/03_settings_mirror_block_xml.erb"),
    order   => '03',
    tag     => $tag_name
  }

}
