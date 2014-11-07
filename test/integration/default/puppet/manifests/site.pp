package { ['tar', 'gzip]: ensure => present } ->
class { '::maven':
  package_ensure  => '3.1.1'
}

user { 'test1':
  ensure      => present,
  home        => '/home/test1',
  managehome  => true
}

  ::maven::settings { 'test1':
    ensure  => present,
    path    => '/home',
    mirrors => [
      {
        id        => 'central-proxy',
        name      => 'Local Proxy of central repo',
        url       => 'http://nexus.company.com/nexus/content/groups/public/',
        mirror_of => '*,!releases-internal-releases,!releases-internal-snapshots,!releases-plugins-internal-releases,!releases-plugins-internal-snapshots'
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
            key   => 'releases.repository.url',
            value => 'http://nexus.company.com/nexus/content/repositories/releases-hosted'
          },
          {
            key   => 'snapshots.repository.url',
            value => 'http://nexus.company.com/nexus/content/repositories/snapshots'
          },
          {
            key   => 'sonar.jdbc.url',
            value => 'jdbc:oracle:thin:@db.company.com/site_standard.db.company.com'
          },
          {
            key   => 'sonar.jdbc.driver',
            value => 'oracle.jdbc.driver.OracleDriver'
          },
          {
            key   => 'sonar.jdbc.username',
            value => 'USERNAME'
          },
          {
            key   => 'sonar.jdbc.password',
            value => 'PASSWORD'
          },
          {
            key   => 'maven.test.error.ignore',
            value => 'true'
          },
          {
            key   => 'maven.test.failure.ignore',
            value => 'true'
          },
          {
            key   => 'sonar.host.url',
            value => 'http://sonar.company.com'
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
