# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include dnsmasq
#
# @param local_only_domains
#   Mirror to dnsmasq::conf `local_only_domains` attribute.
#
# @param domains_force_to_ip
#   Mirror to dnsmasq::conf `domains_force_to_ip` attribute.
#
# @param ipset
#   Mirror to dnsmasq::conf `ipset` attribute.
#
#
class dnsmasq (
  # Hash $configs_hash,
  # Hash $hosts_hash,
  # Hash $dhcp_hosts_hash,
  String[1] $package_ensure,
  Boolean   $package_manage,
  Boolean   $service_control,
  Boolean   $purge_config_dir,

  Optional[Array[String]] $local_only_domains,
  Optional[Array[String]] $domains_force_to_ip,
  Optional[String[1]]     $ipset,

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

  # create_resources(dnsmasq::conf, $configs_hash)
  # create_resources(dnsmasq::host, $hosts_hash)
  # create_resources(dnsmasq::dhcp_host, $dhcp_hosts_hash)

  dnsmasq::conf { 'dns-server':
    priority      => 10,
    resolv_file   => '/etc/resolv.dnsmasq',
    # user  => 'root',
    # group => 'root',
    # port   => '5353',
    # source => 'puppet:///modules/dnsmasq/dnsmasq.conf',
    domain_needed => true,
    bogus_priv    => true,
    # dnssec => true,
    # dnssec_check_unsigned => true,
    filterwin2k   => true,
    strict_order  => true,
    # no_resolv   => true,
    # no_poll     => true,
    # other_name_servers => ['/subdomain1.example.org/192.168.0.1', '/subdomain2.example.org/192.168.0.2'],
    # ptr_nameservers => ['/3.168.192.in-addr.arpa/10.1.2.3', '/4.168.192.in-addr.arpa/10.1.2.4'],
    local_only_domains  => $local_only_domains,
    domains_force_to_ip => $domains_force_to_ip,
    ipset               => $ipset,
  }
}
