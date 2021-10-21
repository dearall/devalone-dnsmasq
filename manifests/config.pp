# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include dnsmasq::config
class dnsmasq::config {
  File {
    owner => 'root',
    group => 'root',
  }

  file { $::dnsmasq::params::config_file:
    mode   => '0644',
    source => 'puppet:///modules/dnsmasq/dnsmasq.conf',
  }
}
