class { '::maven':
  package_ensure  => '3.1.1'
}

maven::settings { 'vagrant_settings_xml':
  ensure  => present,
  user    => 'vagrant',
  path    => '/home/vagrant/.m2/settings.xml'
}

maven::settings::mirror { 'Local Proxy of central repo':
  id        => 'central-proxy',
  url       => 'http://repo.example.com/repo/content/groups/public',
  mirror_of => '*,!releases-internal-releases,!releases-internal-snapshots,!releases-plugins-internal-releases,!releases-plugins-internal-snapshots',
  path      => '/home/vagrant/.m2/settings.xml',
  tag_name  => 'vagrant_settings_xml'
}

maven::settings::profile { 'vagrant_settings_profile':
  id                => 'default',
  path              => '/home/vagrant/.m2/settings.xml',
  tag_name          => 'vagrant_settings_xml',
  active_by_default => true,
  properties        => [
    {
      key   => 'releases.repository.url',
      value => 'http://repo.example.com/repo/content/repositories/releases-hosted'
    },
    {
      key   => 'snapshots.repository.url',
      value => 'http://repo.example.com/repo/content/repositories/snapshots'
    },
    {
      key   => 'maven.test.error.ignore',
      value => 'true'
    },
    {
      key   => 'maven.test.failure.ignore',
      value => 'true'
    }
  ],
  repositories      => [
    {
      id        => 'releases-internal-snapshots',
      url       => 'http://repo.example.com/repo/content/repositories/snapshots',
      layout    => 'default',
      releases  => false,
      snapshots => true
    },
    {
      id        => 'releases-internal-releases',
      url       => 'http://repo.example.com/repo/content/groups/releases',
      layout    => 'default',
      releases  => true,
      snapshots => false
    },
    {
      id        => 'releases-public',
      url       => 'http://repo.example.com/repo/content/groups/public',
      layout    => 'default',
      releases  => true,
      snapshots => false
    }
  ],
  plugin_repositories => [
    {
      id        => 'releases-plugins-internal-snapshots',
      url       => 'http://repo.example.com/repo/content/repositories/snapshots',
      layout    => 'default',
      releases  => false,
      snapshots => true
    },
    {
      id        => 'releases-plugins-internal-releases',
      url       => 'http://repo.example.com/repo/content/groups/releases',
      layout    => 'default',
      releases  => true,
      snapshots => false
    }
  ]
}

maven::settings::server { 'm2-internal-official':
  id        => 'm2-internal-official',
  username  => 'username',
  password  => 'password',
  path      => '/home/vagrant/.m2/settings.xml',
  tag_name  => 'vagrant_settings_xml'
}

maven::settings::server { 'm2-internal-devel':
  id        => 'm2-internal-devel',
  username  => 'username',
  password  => 'password',
  path      => '/home/vagrant/.m2/settings.xml',
  tag_name  => 'vagrant_settings_xml'
}
