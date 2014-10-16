# == Class: git
#
# Install git package. And include configs from hierra.
#
# === Parameters
#
# Document parameters here.
#
# [*git_config*]
#   Hash of git::config values.
#
#
# === Examples
#
#  class { 'git':
#  }
#
#  class { 'git':
#    git_config = {
#      color.ui => {
#        value  => true,
#      }
#    }
#  }
#
#  ---
#  gitconfig:
#      alias.ci:
#          value: 'commit'
#          user: 'foobar'
#
# === Authors
#
# Remi Sauvat <remi.sauvat+puppet@inetprocess.com>
#
# === Copyright
#
# Copyright 2014 iNet Process
#
class git (
  $git_config = hiera_hash('gitconfig', {}),
) {
    package {'git-core':
      ensure => present,
    }

    create_resources('git::config', $git_config)
}
