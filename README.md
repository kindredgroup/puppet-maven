# maven

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with maven](#setup)
    * [What maven affects](#what-maven-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with maven](#beginning-with-maven)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)

## Overview

Simple Puppet module for managing Apache Maven. Tested on osfamily Redhat

## Module Description

Installs Maven from system package or tar.gz, manages a users settings.xml

## Setup

### What maven affects

* By default, maven installation in /opt/apache-maven-VERSION
* $HOME/.m2/settings.xml for user

### Setup Requirements

Maven is java based and thus requires java to be installed to function.
When installing from tar.gz the module also requires wget, tar and gzip
To minimize the dependencies these are expected to be installed outside
of the maven scope

### Beginning with maven

```
puppet module install unibet-maven
```

## Usage

Install maven from upstream:
```
class { '::maven':
  package_ensure  => '3.1.1'
}
```

Install maven from some custom package:
```
class { '::maven':
  install_from_package  => true,
  package               => 'my-maven-package',
  package_ensure        => present
}
```

Manage settings.xml for user1:
```

::maven::settings { 'user1':
  path    => '/home',
  mirrors => [
    {
      id        => 'proxy',
      name      => 'My proxy',
      url       => 'http://nexus.example.com/path',
      mirror_of => '*'
    }
  ],
  profiles  => [
    {
      id                => 'default',
      active_by_default => true
      properties        => [
        {
          key   => 'property1',
          value => 'value1'
        }
      ],
      repositories  => [
        {
          id        => 'my-repo', 
          url       => 'http://nexus.example.com/my-repo',
          layout    => 'default',
          releases  => true,
          snapshots => false
        }
      ],
      plugin_repositories => [
        {
          id        => 'my-plugin-repo',
          url       => 'http://nexus.example.com/my-plugin-repo',
          layout    => 'default',
          releases  => true,
          snapshots => false
        }
      ],
    },
  ],
  servers => [
    {
      id  => 'my-repo',
      username  => 'LOGIN',
      password  => 'PW'
    }
  ],
}
```

## Reference

* Classes: maven
* Defines: maven::settings

See class / define docs and usage

## Limitations

Only tested on OS family Redhat

## Development

Pull requests are welcome.
