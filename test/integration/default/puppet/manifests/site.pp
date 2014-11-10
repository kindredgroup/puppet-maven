# install java
$java_packages = $::osfamily ? {
  redhat  => 'java-1.7.0-openjdk',
  debian  => ['openjdk-7-jdk', 'openjdk-7-jre']
}
package { $java_packages: ensure => installed }

# install requirements to maven class
package { ['tar', 'gzip', 'wget']: ensure => present } ->
class { '::maven':
  package_ensure  => '3.1.1'
}

# construct a settings.xml for root user
::maven::settings { 'root':
  ensure  => present,
  path    => '/',
  mirrors => [
    {
      id        => 'UK',
      name      => 'UK Central',
      url       => 'http://uk.maven.org/maven2',
      mirror_of => 'central'
    }
  ],

  #
  # Profiles
  #
  profiles  => [
    {
      id                => 'default',
      active_by_default => true,

  #
  # Profile properties
  #
      properties        => [
        {
          key   => 'maven.test.error.ignore',
          value => 'true'
        },
        {
          key   => 'maven.test.failure.ignore',
          value => 'true'
        }
      ],

  #
  # Profile repositories
  #
      repositories    => [
        {
          id        => 'releases-internal-snapshots',
          url       => 'http://nexus.company.com/nexus/content/repositories/snapshots',
          layout    => 'default',
          releases  => false,
          snapshots => true
        },
        {
          id        => 'releases-internal-releases',
          url       => 'http://nexus.company.com/nexus/content/groups/releases',
          layout    => 'default',
          releases  => true,
          snapshots => false
        },
        {
          id        => 'releases-public',
          url       => 'http://nexus.company.com/nexus/content/groups/public',
          layout    => 'default',
          releases  => true,
          snapshots => false
        }
      ],

  #
  # Profile plugin repositories
  #
      plugin_repositories => [
        {
          id        => 'releases-plugins-internal-snapshots',
          url       => 'http://nexus.company.com/nexus/content/repositories/snapshots',
          layout    => 'default',
          releases  => false,
          snapshots => true
        },
        {
          id        => 'releases-plugins-internal-releases',
          url       => 'http://nexus.company.com/nexus/content/groups/releases',
          layout    => 'default',
          releases  => true,
          snapshots => false
        }
      ]
    }
  ],

  #
  # Servers
  #
  servers   => [
    {
      id        => 'm2-internal-official',
      username  => 'USERNAME',
      password  => 'PASSWORD'
    },
    {
      id        => 'm2-internal-devel',
      username  => 'USERNAME',
      password  => 'PASSWORD'
    }
  ]
}
