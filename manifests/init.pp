# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include dnsmasq
class dnsmasq (
  Hash $configs_hash,
  Hash $hosts_hash,
  Hash $dhcp_hosts_hash,
  String $package_ensure,
  Boolean $package_manage,
  Boolean $service_control,
  Boolean $purge_config_dir

) {
  include dnsmasq::params

  contain dnsmasq::install
  contain dnsmasq::config
  contain dnsmasq::service

  Class['::dnsmasq::install']
  -> Class['::dnsmasq::config']
  ~> Class['::dnsmasq::service']

  class { '::dnsmasq::reload':
    require => Class['::dnsmasq::service'],
  }

  if $::settings::storeconfigs {
    File_line <<| tag == 'dnsmasq-host' |>>
  }

  create_resources(dnsmasq::conf, $configs_hash)
  create_resources(dnsmasq::host, $hosts_hash)
  create_resources(dnsmasq::dhcp_host, $dhcp_hosts_hash)
}
