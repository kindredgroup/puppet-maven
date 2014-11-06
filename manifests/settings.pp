# == Define: maven::settings
#
# Manages settings.xml for a user
#
# === Parameters
#
# [*namevar*]
#   Name of user
#
# [*path*]
#   Base path to user home directory
#   If home dir for user is /home/user, this should be set to /home
#
# [*source*]
#   Optional file source to settings.xml
#
# [*mirrors*]
#   Array of hashes, each element is a separate mirror
#   These keys must exist: id, name, url, mirror_of
#
# [*profiles*]
#   Array of hashes, each element is a separate profile
#   See example usage
#
# [*servers*]
#   Array of hashes, each element is a separate server section
#   These keys must exist: id, username, password
#
# === Example usage
#
#  ::maven::settings { 'johndoe':
#    ensure  => present,
#    path    => '/home',
#    mirrors => [
#      {
#        id        => 'central-proxy',
#        name      => 'Central proxy',
#        url       => 'http://nexus.company.com/nexus/content/groups/public/',
#        mirror_of => '*,!releases-internal-releases,!releases-internal-snapshots,!releases-plugins-internal-releases,!releases-plugins-internal-snapshots'
#      }
#    ],
#
#    #
#    # Profiles
#    #
#    profiles  => [
#      {
#        id                => 'default',
#        active_by_default => true,
#
#    #
#    # Profile properties
#    #
#        properties        => [
#          {
#            key   => 'maven.test.error.ignore',
#            value => 'true'
#          },
#        ],
#
#    #
#    # Profile repositories
#    #
#        repositories    => [
#          {
#            id        => 'releases-internal-snapshots',
#            url       => 'http://nexus.company.com/path/snapshots',
#            layout    => 'default',
#            releases  => false,
#            snapshots => true
#          },
#          {
#            id        => 'releases-internal-releases',
#            url       => 'http://nexus.company.com/path/releases',
#            layout    => 'default',
#            releases  => true,
#            snapshots => false
#          }
#        ],
#
#    #
#    # Profile plugin repositories
#    #
#        plugin_repositories => [
#          {
#            id        => 'releases-plugins-internal-snapshots',
#            url       => 'http://nexus.company.com/path/snapshots',
#            layout    => 'default',
#            releases  => false,
#            snapshots => true
#          },
#          {
#            id        => 'releases-plugins-internal-releases',
#            url       => 'http://nexus.company.com/path/releases',
#            layout    => 'default',
#            releases  => true,
#            snapshots => false
#          }
#        ]
#      }
#    ],
#
#    #
#    # Servers
#    #
#    servers   => [
#      {
#        id        => 'some-id',
#        username  => 'username',
#        password  => 'password'
#      }
#    ]
#  }
#
define maven::settings (
  $path,
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

  $directory_path = "${path}/${user}/.m2"
  $settings_xml_path = "${directory_path}/settings.xml"

  file { $directory_path:
    ensure => $directory_ensure,
    owner  => $user,
    group  => $user,
    mode   => '0755'
  }

  file { $settings_xml_path:
    ensure       => $ensure,
    owner        => $user,
    group        => $user,
    mode         => '0644',
    validate_cmd => '/usr/bin/env xmllint --noout %'
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

}
