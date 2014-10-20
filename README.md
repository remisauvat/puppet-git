# inet-git

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with git](#setup)
    * [What git affects](#what-git-affects)
    * [Beginning with git](#beginning-with-git)
4. [Usage - Configuration options](#usage)
5. [Reference](#reference)

## Overview

Git client installation and configuration. Tested on Debian and ubuntu, and should work on RedHat family.

## Module Description

Uses the `git config` command to apply configuration in various places.

## Setup

### What git affects

* git package.
* git configuration.

### Beginning with git

`include ::git` is enough to install git and fetch configuration from hiera.

## Usage

Specific configurations: 
```
class { 'git':
    git_config => {
        "color.ui" => {
            value => 'auto',
        }
    }
}
```

You can also use a hiera hash to manage your configuration.
```
---
git_config:
    color.ui:
        value: auto
        user: foobar
    alias.ci:
        value: commit
    alias.add_hooks
        user: foo
        dir: '/var/www'
        value: ".hooks/add_hooks.sh"
    alias.stop
        ensure: absent
        zone: global
        user: bar
```

## Reference

### Class: git
#### Parameters
`git_config` Pass a hash to create git::config resources.
### Type: git::config

`title`
 Can be in the form section.key.

`ensure`
 Manage the presence of the configuration key.

`dir`
 Specify a git repository to which apply the configuration.

`key`
 Configuration key to manage. Default guessed from title.

`section`
 Configuration section for the key to manage. Default guessed from title.

`user`
 Apply the configuration for the user. Default 'root'.

`value`
 Value of the configuration. This string must escape single and double
 quotes with a backslash.

`zone`
 Which configuration file to modify.
 If dir is set, zone is not used.
 Default : 'system' if no user is specified, else 'global'.


#### Examples

````
git::config { 'color.ui':
  value => true,
}

git::config { 'color.ui':
  value => true,
  user  => bar,
}
```

