# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   dnsmasq::conf { 'namevar': }
define dnsmasq::conf (
  $ensure   = 'present',
  $prio     = 10,
  $source   = undef,

  # conf params
  $port     = undef,

) {

  include ::dnsmasq

  File {
    owner => 'root',
    group => 'root',
  }

  if $source {
    file { "${dnsmasq::params::config_dir}${prio}-${name}.conf":
      ensure => $ensure,
      source => $source,
      notify => Class['dnsmasq::service'],
    }
  }
  else {
    file { "${dnsmasq::params::config_dir}${prio}-${name}.conf":
      ensure  => $ensure,
      content => template('dnsmasq/dnsmasq.conf.erb'),
      notify  => Class['dnsmasq::service'],
    }
  }
}
