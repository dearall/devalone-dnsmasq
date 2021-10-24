# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include dnsmasq
#
# @param conf_ensure
#   Mapping to dnsmasq::conf `ensure` attribute.
#
# @param conf_priority
#   Mapping to dnsmasq::conf `priority` attribute.
#
# @param conf_source
#   Mapping to dnsmasq::conf `source` attribute.
#
# @param port
#   Mapping to dnsmasq::conf `port` attribute.
#
# @param user
#   Mapping to dnsmasq::conf `user` attribute.
#
# @param group
#   Mapping to dnsmasq::conf `group` attribute.
#
# @param domain_needed
#   Mapping to dnsmasq::conf `domain_needed` attribute.
#
# @param bogus_priv
#   Mapping to dnsmasq::conf `bogus_priv` attribute.
#
# @param dnssec
#   Mapping to dnsmasq::conf `dnssec` attribute.
#
# @param dnssec_check_unsigned
#   Mapping to dnsmasq::conf `dnssec_check_unsigned` attribute.
#
# @param filterwin2k
#   Mapping to dnsmasq::conf `filterwin2k` attribute.
#
# @param resolv_file
#   Mapping to dnsmasq::conf `resolv_file` attribute.
#
# @param strict_order
#   Mapping to dnsmasq::conf `strict_order` attribute.
#
# @param no_resolv
#   Mapping to dnsmasq::conf `no_resolv` attribute.
#
# @param no_poll
#   Mapping to dnsmasq::conf `no_poll` attribute.
#
# @param other_name_servers
#   Mapping to dnsmasq::conf `other_name_servers` attribute.
#
# @param ptr_nameservers
#   Mapping to dnsmasq::conf `ptr_nameservers` attribute.
#
# @param local_only_domains
#   Mapping to dnsmasq::conf `local_only_domains` attribute.
#
# @param domains_force_to_ip
#   Mapping to dnsmasq::conf `domains_force_to_ip` attribute.
#
# @param ipset
#   Mapping to dnsmasq::conf `ipset` attribute.
#
#
# @param queries_via_eth
#   Mapping to dnsmasq::conf `queries_via_eth` attribute.
#
# @param queries_via_ip
#   Mapping to dnsmasq::conf `queries_via_ip` attribute.
#
# @param interfaces
#   Mapping to dnsmasq::conf `interfaces` attribute.
#
# @param except_interfaces
#   Mapping to dnsmasq::conf `except_interfaces` attribute.
#
# @param listen_addresses
#   Mapping to dnsmasq::conf `listen_addresses` attribute.
#
# @param no_dhcp_interfaces
#   Mapping to dnsmasq::conf `no_dhcp_interfaces` attribute.
#
# @param bind_interfaces
#   Mapping to dnsmasq::conf `bind_interfaces` attribute.
#
# @param no_hosts
#   Mapping to dnsmasq::conf `no_hosts` attribute.
#
# @param addn_hosts
#   Mapping to dnsmasq::conf `addn_hosts` attribute.
#
# @param expand_hosts
#   Mapping to dnsmasq::conf `expand_hosts` attribute.
#
# @param domain
#   Mapping to dnsmasq::conf `domain` attribute.
#
# @param domain_for_subnet
#   Mapping to dnsmasq::conf `domain_for_subnet` attribute.
#
# @param domain_for_range
#   Mapping to dnsmasq::conf `domain_for_range` attribute.
#
#
#
#
#
#
#
#
#
#
#
#
#
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

  # Mapping to dnsmasq::conf attributes
  Enum['present','file','absent'] $conf_ensure,
  Integer                         $conf_priority,
  Optional[Stdlib::Absolutepath]  $conf_source,
  Optional[String[1]]             $port,
  Optional[String[1]]             $user,
  Optional[String[1]]             $group,
  Boolean                         $domain_needed,
  Boolean                         $bogus_priv,
  Boolean                         $dnssec,
  Boolean                         $dnssec_check_unsigned,
  Boolean                         $filterwin2k,
  Optional[Stdlib::Absolutepath]  $resolv_file,
  Boolean                         $strict_order,
  Boolean                         $no_resolv,
  Boolean                         $no_poll,
  Optional[Array[String]]         $other_name_servers,
  Optional[Array[String]]         $ptr_nameservers,
  Optional[Array[String]]         $local_only_domains,
  Optional[Array[String]]         $domains_force_to_ip,
  Optional[String[1]]             $ipset,
  Optional[Array[String]]         $queries_via_eth,
  Optional[Array[String]]         $queries_via_ip,
  Optional[Array[String]]         $interfaces,
  Optional[Array[String]]         $except_interfaces,
  Optional[Array[String]]         $listen_addresses,
  Optional[Array[String]]         $no_dhcp_interfaces,
  Boolean                         $bind_interfaces,
  Boolean                         $no_hosts,
  Optional[Array[String]]         $addn_hosts,
  Boolean                         $expand_hosts,
  Optional[String[1]]             $domain,
  Optional[String[1]]             $domain_for_subnet,
  Optional[String[1]]             $domain_for_range,

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
    ensure                => $conf_ensure,
    priority              => $conf_priority,
    source                => $conf_source,

    port                  => $port,
    user                  => $user,
    group                 => $group,
    domain_needed         => $domain_needed,
    bogus_priv            => $bogus_priv,
    dnssec                => $dnssec,
    dnssec_check_unsigned => $dnssec_check_unsigned,
    resolv_file           => $resolv_file,
    strict_order          => $strict_order,
    no_resolv             => $no_resolv,
    no_poll               => $no_poll,
    other_name_servers    => $other_name_servers,
    ptr_nameservers       => $ptr_nameservers,
    local_only_domains    => $local_only_domains,
    domains_force_to_ip   => $domains_force_to_ip,
    ipset                 => $ipset,
    queries_via_eth       => $queries_via_eth,
    queries_via_ip        => $queries_via_ip,
    interfaces            => $interfaces,
    except_interfaces     => $except_interfaces,
    listen_addresses      => $listen_addresses,
    no_dhcp_interfaces    => $no_dhcp_interfaces,
    bind_interfaces       => $bind_interfaces,
    no_hosts              => $no_hosts,
    addn_hosts            => $addn_hosts,
    expand_hosts          => $expand_hosts,
    domain                => $domain,
    domain_for_subnet     => $domain_for_subnet,
    domain_for_range      => $domain_for_range,
  }
}
