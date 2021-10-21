# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include dnsmasq::install
class dnsmasq::install {
  if $dnsmasq::package_manage {
      package { $dnsmasq::params::package_name:
      ensure => $dnsmasq::package_ensure,
    }
  }

  if $dnsmasq::purge_config_dir {
    file { $dnsmasq::params::config_dir:
      ensure  => 'directory',
      recurse => true,
      purge   => true,
      force   => true,
    }
  } else {
    file { $dnsmasq::params::config_dir:
      ensure => 'directory',
    }
  }
}
