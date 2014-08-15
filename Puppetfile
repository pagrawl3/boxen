# This file manages Puppet module dependencies.
#
# It works a lot like Bundler. We provide some core modules by
# default. This ensures at least the ability to construct a basic
# environment.

# Shortcut for a module from GitHub's boxen organization
def github(name, *args)
  options ||= if args.last.is_a? Hash
    args.last
  else
    {}
  end

  if path = options.delete(:path)
    mod name, :path => path
  else
    version = args.first
    options[:repo] ||= "boxen/puppet-#{name}"
    mod name, version, :github_tarball => options[:repo]
  end
end

# Shortcut for a module under development
def dev(name, *args)
  mod name, :path => "#{ENV['HOME']}/src/boxen/puppet-#{name}"
end

# Includes many of our custom types and providers, as well as global
# config. Required.

github "boxen", "3.6.2"

# Support for default hiera data in modules

github "module_data", "0.0.3", :repo => "ripienaar/puppet-module-data"

# Core modules for a basic development environment. You can replace
# some/most of these if you want, but it's not recommended.

github "foreman",     "1.2.0"
github "gcc",         "2.1.1"
github "git",         "2.5.0"
github "homebrew",    "1.9.4"
github "hub",         "1.3.0"
github "inifile",     "1.1.1", :repo => "puppetlabs/puppetlabs-inifile"
github "nodejs",      "3.8.1"
github "openssl",     "1.0.0"
github "phantomjs",   "2.3.0"
github "pkgconfig",   "1.0.0"
github "repository",  "2.3.0"
github "stdlib",      "4.2.1", :repo => "puppetlabs/puppetlabs-stdlib"
github "sudo",        "1.0.0"

# Optional/custom modules. There are tons available at
# https://github.com/boxen.
github "alfred",          "1.3.0"
github "bartender",       "1.0.0"
github "spotify",         "1.0.2"
github "dropbox",         "1.3.0"
github "mongodb",         "2.6.1"
github "flux",            "1.0.1"
github "mplayerx",        "1.0.2"
github "cinch",           "1.0.1"
github "imageoptim",      "0.0.2"
github "sublime_text",    "1.0.1"
github "chrome",          "1.1.1"
github "wget",            "1.0.0"
github "prezto",          "1.0.1", :repo => "archfear/puppet-prezto"
github "totalterminal",   "1.0.0", :repo => "phatblat/puppet-totalterminal"
