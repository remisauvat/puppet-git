# == Class: git::params
#
# Configure default parameters for the git module.
#
class git::params {
  $su = '/bin/su'
  $svn = 'git-svn'
  $bin = '/usr/bin/git'

  case $::osfamily {
    Debian: {
      if $::operatingsystem == 'Ubuntu' and versioncmp($::operatingsystemrelease, '12') >= 0 {
        $package_name = 'git'
      } elsif $::operatingsystem == 'Debian' and versioncmp($::operatingsystemrelease, '6') >= 0 {
        $package_name = 'git'
      } else {
        $package_name = 'git-core'
      }
    }
    RedHat, ArchLinux: {
        $package_name = 'git'
    }
    default: {
      fail("The inet-git module is not supported on an ${::operatingsystem} distribution.")
    }
  }
}
