# == Resource type git::config
#
# Full description of class git here.
#
# === Parameters
#
# [*title*]
#   Can be in the form section.key.
#
# [*ensure*]
#   Manage the presence of the configuration key.
#
# [*dir*]
#   Specify a git repository to which apply the configuration.
#
# [*key*]
#   Configuration key to manage. Default guessed from title.
#
# [*section*]
#   Configuration section for the key to manage. Default guessed from title.
#
# [*user*]
#   Apply the configuration for the user. Default 'root'.
#
# [*value*]
#   Value of the configuration. This string must escape single and double
#   quotes with a backslash.
#
# [*zone*]
#   Which configuration file to modify.
#   If dir is set, zone is not used.
#   Default : 'system' if no user is specified, else 'global'.
#
#
# === Examples
#
#  git::config { 'color.ui':
#    value => true,
#  }
#
#  git::config { 'color.ui':
#    value => true,
#  }
#
# === Authors
#
# Remi Sauvat <remi.sauvat+puppet@inetprocess.com>
#
# === Copyright
#
# Copyright 2014 iNet Process
#
define git::config (
  $ensure   = 'present',
  $dir      = undef,
  $key      = regsubst($title, '^([^\.]+)\.([^\.]+)$','\2'),
  $section  = regsubst($title, '^([^\.]+)\.([^\.]+)$','\1'),
  $user     = undef,
  $value    = "",
  $zone     = undef,
) {

  include $::git::params

  $_zone_tpl = "<%=
  unless @dir
    if @zone
      '--' << @zone
    else
      if @user
        '--global'
      else
        '--system'
      end
    end
  end
  -%>"
  # Login as the specified user to set the HOME variable
  $command_prefix = "${::git::params::su} -l -c \"${::git::params::bin} config "
  $command_suffix = "\" '<%= @user ? @user : 'root' %>'"

  # Various commands 
  $get_value_command = " --get <%=@section%>.<%=@key%> '^<%=@value%>$'"
  $get_command = " --get <%=@section%>.<%=@key%>"
  $set_command = " <%=@section%>.<%=@key%> '<%=@value%>'"
  $unset_command = ' --unset-all <%=@section%>.<%=@key%>'


  if $ensure == 'present' {
    $unless = inline_template($command_prefix, $_zone_tpl, $get_value_command, $command_suffix)
    $command = inline_template($command_prefix, $_zone_tpl, $set_command, $command_suffix)
  } else {
    $onlyif = inline_template($command_prefix, $_zone_tpl, $get_command, $command_suffix)
    $command = inline_template($command_prefix, $_zone_tpl, $unset_command, $command_suffix)
  }

  exec{"git_config_$title" :
    command => $command,
    path     => ['/usr/bin', '/bin', '/usr/local/bin'],
    onlyif   => $onlyif,
    unless   => $unless,
    cwd      => $dir,
    require  => Package[$::git::params::package_name],
  }
}

