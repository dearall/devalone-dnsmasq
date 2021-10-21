# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   dnsmasq::conf { 'namevar': }
define dnsmasq::conf (
  String[1] $ensure,
  Integer $prio,
  Stromg[1] $source,
  String[1] $content = template('dnsmasq/dnsmasq.conf.erb'),

  # conf params
  String[2] $port = undef,
) {
  include ::dnsmasq

  file { "${dnsmasq::params::config_dir}${prio}-${name}.conf":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    source  => $source,
    content => $content,
    notify  => Class['dnsmasq::service'],
  }
}
