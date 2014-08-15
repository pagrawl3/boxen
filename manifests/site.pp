require boxen::environment
require homebrew
require gcc

Exec {
  group       => 'staff',
  logoutput   => on_failure,
  user        => $boxen_user,

  path => [
    "${boxen::config::home}/rbenv/shims",
    "${boxen::config::home}/rbenv/bin",
    "${boxen::config::home}/rbenv/plugins/ruby-build/bin",
    "${boxen::config::home}/homebrew/bin",
    '/usr/bin',
    '/bin',
    '/usr/sbin',
    '/sbin'
  ],

  environment => [
    "HOMEBREW_CACHE=${homebrew::config::cachedir}",
    "HOME=/Users/${::boxen_user}"
  ]
}

File {
  group => 'staff',
  owner => $boxen_user
}

Package {
  provider => homebrew,
  require  => Class['homebrew']
}

Repository {
  provider => git,
  extra    => [
    '--recurse-submodules'
  ],
  require  => File["${boxen::config::bindir}/boxen-git-credential"],
  config   => {
    'credential.helper' => "${boxen::config::bindir}/boxen-git-credential"
  }
}

Service {
  provider => ghlaunchd
}

Homebrew::Formula <| |> -> Package <| |>

node default {
  # core modules, needed for most things
  include git
  git::config::global {
    'user.name':
      value => 'Pratham Agrawal';
    'user.email':
      value => 'mail@prath.am';
    'github.user':
      value => 'pagrawl3';
    'color.ui':
      value => 'true';
    'core.quotepath':
      value => 'false';
    'diff.tool':
      value => 'opendiff';
    'merge.tool':
      value => 'opendiff';
    'push.default':
      value => 'simple';
    'alias.amend':
      value => 'commit --amend -C HEAD';
  }

  include hub

  # fail if FDE is not enabled
  # if $::root_encrypted == 'no' {
  #   fail('Please enable full disk encryption and try again')
  # }

  # node versions
  # include nodejs::v0_6
  # include nodejs::v0_8
  include nodejs::v0_10
  include alfred
  include bartender
  include spotify
  include dropbox
  include mongodb
  include flux
  include mplayerx
  include cinch
  include imageoptim
  include totalterminal

  include sublime_text::v2
  sublime_text::v2::package { 'Emmet':
    source => 'sergeche/emmet-sublime'
  }
  sublime_text::v2::package { 'Jade':
    source => 'davidrios/jade-tmbundle'
  }
  sublime_text::v2::package { 'SublimeAllAutocomplete':
    source => 'alienhard/SublimeAllAutocomplete'
  }
  sublime_text::v2::package { 'LESS':
    source => 'danro/Less-sublime'
  }
  sublime_text::v2::package { 'Color Scheme - Solarized':
    source => 'altercation/solarized'
  }
  file { "${boxen::config::homedir}/bin/subl":
    ensure  => link,
    target  => "/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl"
  }

  include chrome
  include wget
  include zsh
  include ohmyzsh

  repository {
      "dotfiles":
        source   => 'pagrawl3/dotfiles',
        path     => "${::boxen_srcdir}/dotfiles";
  }

  $homedir = "/Users/${::boxen_user}"
  $base = "/Users/${::boxen_user}/Library/Application Support"

  file { "${homedir}/.bash_profile":
    ensure  => link,
    target  => "${::boxen_srcdir}/dotfiles/bash_profile",
    require => Repository["dotfiles"],
  }

  file { "${homedir}/.bashrc":
    ensure  => link,
    target  => "${::boxen_srcdir}/dotfiles/bashrc",
    require => Repository["dotfiles"],
  }

  # file { "${homedir}/.zshrc":
  #   ensure  => link,
  #   target  => "${::boxen_srcdir}/dotfiles/zshrc",
  #   require => Repository["dotfiles"],
  # }

  file { "${homedir}/.gitignore":
    ensure  => link,
    target  => "${::boxen_srcdir}/dotfiles/gitignore",
    require => Repository["dotfiles"],
  }

  exec { 'Idempotent creation of User preferences directory':
    command => "mkdir -p '${base}/Sublime Text 2/Packages/User'"
  }

  file { "${base}/Sublime Text 2/Packages/User/Preferences.sublime-settings":
    ensure  => link,
    target  => "${::boxen_srcdir}/dotfiles/pref.sublime-settings",
    require => Repository["dotfiles"],
  }

  file { "/Users/${::boxen_user}/Library/Preferences/com.apple.dock.plist":
    ensure  => link,
    target  => "${::boxen_srcdir}/dotfiles/dock.plist",
    require => Repository["dotfiles"],
  }

  repository { 'package-control':
    source => 'wbond/sublime_package_control',
    path   => "${base}/Sublime Text 2/Packages/Package Control"
  }

  boxen::osx_defaults {
    "Set aqua color variant to graphite":
      ensure => present,
      key    => 'AppleAquaColorVariant',
      domain => 'NSGlobalDomain',
      user   => $::boxen_user,
      type   => 'int',
      value  => 6;
    "disables Dashboard":
      user   => $::boxen_user,
      domain => 'com.apple.dashboard',
      key    => 'mcx-disabled',
      value  => true;
  }
  include osx::global::enable_keyboard_control_access
  include osx::no_network_dsstores
  include osx::dock::autohide

  # common, useful packages
  package {
    [
      'ack',
      'findutils',
      'gnu-tar'
    ]:
  }

  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }
}
