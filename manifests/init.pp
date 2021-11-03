# @summary Manage dnsmasq package install, configure file and service.
#
# The dnsmasq module install, config, and run the service. The main class is dnsmasq, and it
# has a defined type dnsmasq::conf, you can use either of them to control the dnsmasq package.
#
# @example
#   class { 'dnsmasq':
#     resolv_file        => '/etc/resolv.conf.dnsmasq',
#     local_only_domains => ['/example.org/'],
#   }
#
# @param package_manage
#   Whether to manage the dnsmasq package.
#
# @param package_ensure
#   Whether to install the dnsmasq package, and what version to install. Values: 'present', 'installed',
#   'absent', 'purged', 'disabled','latest', or a specific version number.
#
# @param service_control
#    Whether to manage the dnsmasq service.
#
# @param purge_config_dir
#   Whether to purge the config directory: '/etc/dnsmasq.d/'.
#
# @param conf_ensure
#   Whether the config file should exist. Possible values are present, absent, and file.
#
#   Mapping to dnsmasq::conf `ensure` attribute.
#
# @param conf_priority
#   The priority of file in /etc/dnsmasq.d/ directory, which is part of the configuration file name.
#
#   Mapping to dnsmasq::conf `priority` attribute.
#
# @param conf_source
#   A source file, which will be copied into the configuration file. If this attribute is not `undef`, the
#   other detail attributes that based on template to build the configuration file's content are ignored. 
#   This attribute is for you that have some validate configuration files.
#   Allowed values are:
#     - `puppet`: URIs, which point to files in modules or Puppet file server mount points.
#     - Fully qualified paths to locally available files (including files on NFS shares or Windows mapped drives).
#     - `file`: URIs, which behave the same as local file paths.
#     - `http(s)`: URIs, which point to files served by common web servers.
#
#   Mapping to dnsmasq::conf `source` attribute.
#
# @param port
#   Listen on this specific port instead of the standard DNS port (53). Setting this to zero completely disables
#   DNS function, leaving only DHCP and/or TFTP.
#
#   Mapping to dnsmasq::conf `port` attribute.
#
# @param user
#   Specify the userid  to which dnsmasq will change after startup. Dnsmasq must normally be started as root, 
#   but it will drop root privileges after startup by changing id to another user. Normally this user is "dnsmasq"
#   but that can be over-ridden with this switch.
#
#   Mapping to dnsmasq::conf `user` attribute.
#
# @param group
#   Specify the group which dnsmasq will run as. The default is "dnsmasq".
#
#   Mapping to dnsmasq::conf `group` attribute.
#
# @param domain_needed
#   Tells dnsmasq to never forward A or AAAA queries for plain names, without dots or domain parts, to
#   upstream nameservers. If the name is not known from /etc/hosts or DHCP then a "not found" answer is returned. 
#
#   Mapping to dnsmasq::conf `domain_needed` attribute.
#
# @param bogus_priv
#   Bogus private reverse lookups. All reverse lookups for private IP ranges (ie 192.168.x.x, etc) 
#   which are not found in /etc/hosts or the DHCP leases file are answered with "no such domain" 
#   rather than being forwarded upstream. The set of prefixes affected is the list given in RFC6303,
#   for IPv4 and IPv6. 
#
#   Mapping to dnsmasq::conf `bogus_priv` attribute.
#
# @param dnssec
#   Enable DNSSEC validation and caching.
#
#   Mapping to dnsmasq::conf `dnssec` attribute.
#
# @param dnssec_check_unsigned
#   Replies which are not DNSSEC signed may be legitimate, because the domain is unsigned, or may be forgeries. 
#   Setting this option tells dnsmasq to check that an unsigned reply is OK, by finding a secure proof that a DS
#   record somewhere between the root and the domain does not exist.
#   The cost of setting this is that even queries in unsigned domains will need one or more extra DNS queries to verify.
#
#   Mapping to dnsmasq::conf `dnssec_check_unsigned` attribute.
#
# @param filterwin2k
#   Setup this attr true to filter useless windows-originated DNS requests which can trigger dial-on-demand links 
#   needlessly. Note that (amongst other things) this blocks all SRV requests, so don't use it if you use eg Kerberos,
#   SIP, XMMP or Google-talk. This option only affects forwarding, SRV records originating for dnsmasq (via srv-host= 
#   lines) are not suppressed by it.
#
#   Mapping to dnsmasq::conf `filterwin2k` attribute.
#
# @param resolv_file
#   Read the IP addresses of the upstream nameservers from <file>, instead of /etc/resolv.conf. For the
#   format of this file see resolv.conf(5). 
#   The only lines relevant to dnsmasq are nameserver ones. Dnsmasq can be told to poll more than one 
#   resolv.conf file, the first file name specified overrides the default, subsequent ones add to the 
#   list. This is only allowed when polling; the file with the currently latest modification time is 
#   the one used. 
#   Change this line if you want dns to get its upstream servers from somewhere other that /etc/resolv.conf. 
#   For example, set this attr's value: '/etc/resolv.conf.dnsmasq':
#
#   resolv_file => '/etc/resolv.conf.dnsmasq',
#
#   Mapping to dnsmasq::conf `resolv_file` attribute. 
#
# @param strict_order
#   By  default,  dnsmasq  will  send queries to any of the upstream servers it knows about and
#   tries to favour servers to are  known to  be  up. Uncommenting this forces dnsmasq to try
#   each query with  each  server  strictly in the order they appear in /etc/resolv.conf
#   严格按照 resolv.conf 中的顺序进行查找
#
#   Mapping to dnsmasq::conf `strict_order` attribute.
#
# @param no_resolv
#   If you don't want dnsmasq to read /etc/resolv.conf or any other file, getting its servers
#   from this file instead (see below). Get upstream servers only from the command line or the
#   dnsmasq configuration file.
#   不读取 resolv-file 来确定上游服务器
#
#   Mapping to dnsmasq::conf `no_resolv` attribute.
#
# @param no_poll
#   If you don't want dnsmasq to poll /etc/resolv.conf or other resolv files for changes and 
#   re-read them then set this attribute true.
#   不检测 /etc/resolv.conf 的变化
#
#   Mapping to dnsmasq::conf `no_poll` attribute.
#
# @param other_name_servers
#   Add other name servers here, with domain specs if they are for non-public domains.
#   e.g:
#       other_name_servers => ['/subdomain1.example.org/192.168.0.1', '/subdomain2.example.org/192.168.0.2'],
#
#   Mapping to dnsmasq::conf `other_name_servers` attribute.
#
# @param ptr_nameservers
#   Example of routing PTR queries to nameservers: this will send all address->name queries for 192.168.3/24 to
#   nameserver 10.1.2.3, 192.168.4/24 to nameserver 10.1.2.4:
#     ptr_nameservers => ['/3.168.192.in-addr.arpa/10.1.2.3', '/4.168.192.in-addr.arpa/10.1.2.4'],
#
#   Mapping to dnsmasq::conf `ptr_nameservers` attribute.
#
# @param local_only_domains
#   Add local-only domains here, queries in these domains are answered from /etc/hosts or DHCP only.
#   e.g:
#       local_only_domains => ['/local-example1.org/', '/local-example2.org/'], 
#
#   Mapping to dnsmasq::conf `local_only_domains` attribute.
#
# @param domains_force_to_ip
#   Add domains which you want to force to an IP address here.
#   The example below send any host in double-click.net to a local web-server.
#     domains_force_to_ip => ['/double-click.net/127.0.0.1'],
#   
#   work with IPv6 addresses too.
#     domains_force_to_ip => ['/www.thekelleys.org.uk/fe80::20d:60ff:fe36:f83'],
#
#   Mapping to dnsmasq::conf `domains_force_to_ip` attribute.
#
# @param ipset
#   Places the resolved IP addresses of queries for one or more domains in the specified Netfilter
#   IP set. If multiple setnames are given, then the addresses are placed in each of them, subject
#   to the limitations of an IP set (IPv4 addresses cannot be stored in an IPv6 IP set and vice versa).
#   Domains and subdomains are matched in the same way as --address. These IP sets must already exist.
#   See ipset(8) for more details.
#   e.g. add the IPs of all queries to yahoo.com, google.com, and their subdomains to the vpn and
#   search ipsets:
#
#     ipset => '/yahoo.com/google.com/vpn,search',
#
#   Mapping to dnsmasq::conf `ipset` attribute.
#
# @param queries_via_eth
#   You can control how dnsmasq talks to a server by this attribute, or the `queries_via_ip` attribute
#   shows below. e.g this forces queries to 10.1.2.3 to be routed via eth1:
#
#     queries_via_eth => ['10.1.2.3@eth1'],
#
#   Mapping to dnsmasq::conf `queries_via_eth` attribute.
#
# @param queries_via_ip
#   This sets the source (ie local) address used to talk to 10.1.2.3 to 192.168.1.1 port 55 (there
#   must be an interface with that IP on the machine, obviously).
#
#     queries_via_ip => ['10.1.2.3@192.168.1.1#55'],
#
#   Mapping to dnsmasq::conf `queries_via_ip` attribute.
#
# @param interfaces
#   If you want dnsmasq to listen for DHCP and DNS requests only on specified interfaces (and the
#   loopback) give the name of the interface (eg eth0, eth1) here.
#
#     interfaces => ['eth0', 'eth1'],
#
#   Mapping to dnsmasq::conf `interfaces` attribute.
#
# @param except_interfaces
#   Or you can specify which interface _not_ to listen on
#
#     except_interfaces => ['eth1'],
#
#   Mapping to dnsmasq::conf `except_interfaces` attribute.
#
# @param listen_addresses
#   Or which to listen on by address (remember to include 127.0.0.1 if you use this.)
#
#     listen_addresses => ['192.168.0.2,127.0.0.1'],
#
#   Mapping to dnsmasq::conf `listen_addresses` attribute.
#
# @param no_dhcp_interfaces
#   If you want dnsmasq to provide only DNS service on an interface, configure it as shown above,
#   and then use the following line to disable DHCP and TFTP on it.
#
#     no_dhcp_interfaces => ['eth0, eth1'],
#
#   Mapping to dnsmasq::conf `no_dhcp_interfaces` attribute.
#
# @param bind_interfaces
#   On systems which support it, dnsmasq binds the wildcard address, even when it is listening on
#   only some interfaces. It then discards requests that it shouldn't reply to. This has the advantage
#   of working even when interfaces come and go and change address. If you want dnsmasq to really bind
#   only the interfaces it is listening on, uncomment this option. About the only time you may need this
#   is when running another nameserver on the same machine.
#
#   Mapping to dnsmasq::conf `bind_interfaces` attribute.
#
# @param no_hosts
#   If you don't want dnsmasq to read /etc/hosts, set no_hosts to true.
#
#   Mapping to dnsmasq::conf `no_hosts` attribute.
#
# @param addn_hosts
#   Additional hosts file. Read the specified file as well as /etc/hosts. If `no_hosts` is given,
#   read only the specified file. This option may be repeated for more than one additional hosts file.
#   If a directory is given, then read all the files contained in that directory in alphabetical order. 
#   e.g
#
#     addn_hosts => ['/etc/banner_add_hosts1', '/etc/banner_add_hosts2'],
#
#   Mapping to dnsmasq::conf `addn_hosts` attribute.
#
# @param expand_hosts
#   Set this (and domain: see below) if you want to have a domain automatically added to simple names
#   in a hosts-file.
#
#   Mapping to dnsmasq::conf `expand_hosts` attribute.
#
# @param domain
#   Mapping to dnsmasq::conf `domain` attribute.
#
# @param dhcp_range
#   Mapping to dnsmasq::conf `dhcp_range` attribute.
#
# @param dhcp_enable_ra
#   Mapping to dnsmasq::conf `dhcp_enable_ra` attribute.
#
# @param dhcp_host
#   Mapping to dnsmasq::conf `dhcp_host` attribute.
#
# @param dhcp_ignore
#   Mapping to dnsmasq::conf `dhcp_ignore` attribute.
#
# @param dhcp_vendorclass
#   Mapping to dnsmasq::conf `dhcp_vendorclass` attribute.
#
# @param dhcp_userclass
#   Mapping to dnsmasq::conf `dhcp_userclass` attribute.
#
# @param dhcp_mac
#   Mapping to dnsmasq::conf `dhcp_mac` attribute.
#
# @param read_ethers
#   Mapping to dnsmasq::conf `read_ethers` attribute.
#
# @param dhcp_option
#   Mapping to dnsmasq::conf `dhcp_option` attribute.
#
# @param dhcp_option_force
#   Mapping to dnsmasq::conf `dhcp_option_force` attribute.
#
# @param dhcp_boot
#   Mapping to dnsmasq::conf `dhcp_boot` attribute.
#
# @param dhcp_match
#   Mapping to dnsmasq::conf `dhcp_match` attribute.
#
# @param pxe_prompt
#   Mapping to dnsmasq::conf `pxe_prompt` attribute.
#
# @param pxe_service
#   Mapping to dnsmasq::conf `pxe_service` attribute.
#
# @param enable_tftp
#   Mapping to dnsmasq::conf `enable_tftp` attribute.
#
# @param tftp_root
#   Mapping to dnsmasq::conf `tftp_root` attribute.
#
# @param tftp_no_fail
#   Mapping to dnsmasq::conf `tftp_no_fail` attribute.
#
# @param tftp_secure
#   Mapping to dnsmasq::conf `tftp_secure` attribute.
#
# @param tftp_no_blocksize
#   Mapping to dnsmasq::conf `tftp_no_blocksize` attribute.
#
# @param dhcp_lease_max
#   Mapping to dnsmasq::conf `dhcp_lease_max` attribute.
#
# @param dhcp_leasefile
#   Mapping to dnsmasq::conf `dhcp_leasefile` attribute.
#
# @param dhcp_authoritative
#   Mapping to dnsmasq::conf `dhcp_authoritative` attribute.
#
# @param dhcp_rapid_commit
#   Set the DHCP server to enable DHCPv4 Rapid Commit Option per RFC 4039. In this mode it will
#   respond to a DHCPDISCOVER message including a Rapid Commit option with a DHCPACK including a
#   Rapid Commit option and fully committed address and configuration information. This must only
#   be enabled if either the server is the only server for the subnet, or multiple servers are present
#   and they each commit a binding for all clients.
#
#   Mapping to dnsmasq::conf `dhcp_rapid_commit` attribute.
#
# @param dhcp_script
#   Mapping to dnsmasq::conf `dhcp_script` attribute.
#
# @param cache_size
#   Mapping to dnsmasq::conf `cache_size` attribute.
#
# @param no_negcache
#   Mapping to dnsmasq::conf `no_negcache` attribute.
#
# @param local_ttl
#   Mapping to dnsmasq::conf `local_ttl` attribute.
#
# @param bogus_nxdomain
#   Mapping to dnsmasq::conf `bogus_nxdomain` attribute.
#
# @param dns_alias
#   Mapping to dnsmasq::conf `dns_alias` attribute.
#
# @param mx_host
#   Mapping to dnsmasq::conf `mx_host` attribute.
#
# @param mx_target
#   Mapping to dnsmasq::conf `mx_target` attribute.
#
# @param localmx
#   Mapping to dnsmasq::conf `localmx` attribute.
#
# @param selfmx
#   Mapping to dnsmasq::conf `selfmx` attribute.
#
# @param dns_srv_host
#   Mapping to dnsmasq::conf `dns_srv_host` attribute.
#
# @param ptr_record
#   Mapping to dnsmasq::conf `ptr_record` attribute.
#
# @param txt_record
#   Mapping to dnsmasq::conf `txt_record` attribute.
#
# @param dns_cname
#   Mapping to dnsmasq::conf `dns_cname` attribute.
#
# @param log_queries
#   Mapping to dnsmasq::conf `log_queries` attribute.
#
# @param log_dhcp
#   Mapping to dnsmasq::conf `log_dhcp` attribute.
#
# @param dhcp_name_match
#   Mapping to dnsmasq::conf `dhcp_name_match` attribute.
#
# @param dhcp_ignore_names
#   Mapping to dnsmasq::conf `dhcp_ignore_names` attribute.
#
#
class dnsmasq (
  Boolean                               $package_manage,
  String                                $package_ensure,
  Boolean                               $service_control,
  Boolean                               $purge_config_dir,

  # Mapping to dnsmasq::conf attributes
  Enum['present','file','absent']       $conf_ensure,
  Integer                               $conf_priority,
  Optional[Stdlib::Absolutepath]        $conf_source,
  Optional[String[1]]                   $port,
  Optional[String[1]]                   $user,
  Optional[String[1]]                   $group,
  Boolean                               $domain_needed,
  Boolean                               $bogus_priv,
  Boolean                               $dnssec,
  Boolean                               $dnssec_check_unsigned,
  Boolean                               $filterwin2k,
  Optional[Stdlib::Absolutepath]        $resolv_file,
  Boolean                               $strict_order,
  Boolean                               $no_resolv,
  Boolean                               $no_poll,
  Optional[Array[String[1]]]            $other_name_servers,
  Optional[Array[String[1]]]            $ptr_nameservers,
  Optional[Array[String[1]]]            $local_only_domains,
  Optional[Array[String[1]]]            $domains_force_to_ip,
  Optional[String[1]]                   $ipset,
  Optional[Array[String[1]]]            $queries_via_eth,
  Optional[Array[String[1]]]            $queries_via_ip,
  Optional[Array[String[1]]]            $interfaces,
  Optional[Array[String[1]]]            $except_interfaces,
  Optional[Array[String[1]]]            $listen_addresses,
  Optional[Array[String[1]]]            $no_dhcp_interfaces,
  Boolean                               $bind_interfaces,
  Boolean                               $no_hosts,
  Optional[Array[Stdlib::Absolutepath]] $addn_hosts,
  Boolean                               $expand_hosts,
  Optional[Array[String[1]]]            $domain,

  # dhcp config
  Optional[Array[String[1]]]            $dhcp_range,

  Boolean                               $dhcp_enable_ra,
  Optional[Array[String[1]]]            $dhcp_host,
  Optional[Array[String[1]]]            $dhcp_ignore,
  Optional[Array[String[1]]]            $dhcp_vendorclass,
  Optional[Array[String[1]]]            $dhcp_userclass,
  Optional[Array[String[1]]]            $dhcp_mac,
  Boolean                               $read_ethers,
  Optional[Array[String[1]]]            $dhcp_option,
  Optional[Array[String[1]]]            $dhcp_option_force,
  Optional[Array[String[1]]]            $dhcp_boot,
  Optional[Array[String[1]]]            $dhcp_match,
  Optional[String[1]]                   $pxe_prompt,
  Optional[Array[String[1]]]            $pxe_service,
  Optional[Array[String[1]]]            $enable_tftp,
  Optional[String[1]]                   $tftp_root,
  Boolean                               $tftp_no_fail,
  Boolean                               $tftp_secure,
  Boolean                               $tftp_no_blocksize,
  Optional[Integer]                     $dhcp_lease_max,
  Optional[String[1]]                   $dhcp_leasefile,
  Boolean                               $dhcp_authoritative,
  Boolean                               $dhcp_rapid_commit,
  Optional[String[1]]                   $dhcp_script,
  Optional[Integer]                     $cache_size,
  Boolean                               $no_negcache,
  Optional[Integer]                     $local_ttl,
  Optional[Array[String[1]]]            $bogus_nxdomain,
  Optional[Array[String[1]]]            $dns_alias,
  Optional[Array[String[1]]]            $mx_host,
  Optional[String[1]]                   $mx_target,
  Boolean                               $localmx,
  Boolean                               $selfmx,
  Optional[Array[String[1]]]            $dns_srv_host,
  Optional[String[1]]                   $ptr_record,
  Optional[Array[String[1]]]            $txt_record,
  Optional[Array[String[1]]]            $dns_cname,
  Variant[Boolean, Enum['extra']]       $log_queries,
  Boolean                               $log_dhcp,
  Optional[Array[String[1]]]            $dhcp_name_match,
  Optional[String[1]]                   $dhcp_ignore_names,
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

    # dhcp config
    dhcp_range            => $dhcp_range,

    dhcp_enable_ra        => $dhcp_enable_ra,
    dhcp_host             => $dhcp_host,
    dhcp_ignore           => $dhcp_ignore,
    dhcp_vendorclass      => $dhcp_vendorclass,
    dhcp_userclass        => $dhcp_userclass,
    dhcp_mac              => $dhcp_mac,
    read_ethers           => $read_ethers,
    dhcp_option           => $dhcp_option,
    dhcp_option_force     => $dhcp_option_force,
    dhcp_boot             => $dhcp_boot,
    dhcp_match            => $dhcp_match,
    pxe_prompt            => $pxe_prompt,
    pxe_service           => $pxe_service,
    enable_tftp           => $enable_tftp,
    tftp_root             => $tftp_root,
    tftp_no_fail          => $tftp_no_fail,
    tftp_secure           => $tftp_secure,
    tftp_no_blocksize     => $tftp_no_blocksize,
    dhcp_lease_max        => $dhcp_lease_max,
    dhcp_leasefile        => $dhcp_leasefile,
    dhcp_authoritative    => $dhcp_authoritative,
    dhcp_rapid_commit     => $dhcp_rapid_commit,
    dhcp_script           => $dhcp_script,
    cache_size            => $cache_size,
    no_negcache           => $no_negcache,
    local_ttl             => $local_ttl,
    bogus_nxdomain        => $bogus_nxdomain,
    dns_alias             => $dns_alias,
    mx_host               => $mx_host,
    mx_target             => $mx_target,
    localmx               => $localmx,
    selfmx                => $selfmx,
    dns_srv_host          => $dns_srv_host,
    ptr_record            => $ptr_record,
    txt_record            => $txt_record,
    dns_cname             => $dns_cname,
    log_queries           => $log_queries,
    log_dhcp              => $log_dhcp,
    dhcp_name_match       => $dhcp_name_match,
    dhcp_ignore_names     => $dhcp_ignore_names,
  }
}
