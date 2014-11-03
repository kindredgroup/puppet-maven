define maven::settings::profile (
  $id,
  $path,
  $tag_name,
  $ensure               = 'present',
  $active_by_default    = true,
  $properties           = {},
  $repositories         = {},
  $plugin_repositories  = {}
) {

  @concat::fragment { "06_${name}":
    target  => $path,
    content => template("${module_name}/06_settings_profile_block_xml.erb"),
    order   => '06',
    tag     => $tag_name
  }

}
