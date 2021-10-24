# @summary The `dnsmasq::conf` defined type is to config dnsmasq, it is the details of configuration file for dnsmasq.
#
# Manage dnsmasq server configuration details. If the `source` attribute is `undef`(default) or unmanaged, the
# configuration file's content is determined by the other attributes. Otherwise, the configuration file's content
# copied from the `soure` url.
#
# The dnsmasq::conf defined type can have multiple instances with different titles(the name attribute defaut value),
# which corresponding to their own configuration files. Options which accept just a single value, the entry in the
# configuration file with the `priority` value, bigger value takes precedence. For options which accept a list of
# values, entries are collected as they occur in files sorted by `priority` values.
#
# @example
#   dnsmasq::conf { 'dnsmasq': }
#
# @param ensure
#   Whether the file should exist. Possible values are present, absent, and file.
#
#   Default value: 'present'
#
# @param priority
#   The priority of file in /etc/dnsmasq.d/ directory, which is part of the configuration file name.
#
#   Default value: 10
#
# @param source
#   A source file, which will be copied into the configuration file. If this attribute is not `undef`, the
#   other detail attributes that based on template to build the configuration file's content are ignored. 
#   This attribute is for you that have some validate configuration files.
#   Allowed values are:
#     - `puppet`: URIs, which point to files in modules or Puppet file server mount points.
#     - Fully qualified paths to locally available files (including files on NFS shares or Windows mapped drives).
#     - `file`: URIs, which behave the same as local file paths.
#     - `http(s)`: URIs, which point to files served by common web servers.
#
#   Default value: undef
#
# @param port
#   Listen on this specific port instead of the standard DNS port (53). Setting this to zero completely disables
#   DNS function, leaving only DHCP and/or TFTP.
#
#   Default value: undef
#
# @param user
#   Specify the userid  to which dnsmasq will change after startup. Dnsmasq must normally be started as root, 
#   but it will drop root privileges after startup by changing id to another user. Normally this user is "dnsmasq"
#   but that can be over-ridden with this switch.
#
#   Default value: undef
#
# @param group
#   Specify the group which dnsmasq will run as. The default is "dnsmasq".
#
#   Default value: undef
#
# @param domain_needed
#   Never forward plain names (without a dot or domain part)
#
#   Default value: true
#
# @param bogus_priv
#   Never forward addresses in the non-routed address spaces.
#
#   Default value: true
#
# @param dnssec
#   Enable DNSSEC validation and caching.
#
#   Default value: false
#
# @param dnssec_check_unsigned
#   Replies which are not DNSSEC signed may be legitimate, because the domain is unsigned, or may be forgeries. 
#   Setting this option tells dnsmasq to check that an unsigned reply is OK, by finding a secure proof that a DS
#   record somewhere between the root and the domain does not exist.
#   The cost of setting this is that even queries in unsigned domains will need one or more extra DNS queries to verify.
#
#   Default value: false
#
# @param filterwin2k
#   Setup this attr true to filter useless windows-originated DNS requests which can trigger dial-on-demand links 
#   needlessly. Note that (amongst other things) this blocks all SRV requests, so don't use it if you use eg Kerberos,
#   SIP, XMMP or Google-talk. This option only affects forwarding, SRV records originating for dnsmasq (via srv-host= 
#   lines) are not suppressed by it.
#
#   Default value: false
#
# @param resolv_file
#   Change this line if you want dns to get its upstream servers from somewhere other that /etc/resolv.conf. 
#   for example, set this attr's value: '/etc/resolv.dnsmasq'
#
#   Default value: undef
#
# @param strict_order
#   By  default,  dnsmasq  will  send queries to any of the upstream servers it knows about and
#   tries to favour servers to are  known to  be  up. Uncommenting this forces dnsmasq to try
#   each query with  each  server  strictly in the order they appear in /etc/resolv.conf
#   严格按照 resolv.conf 中的顺序进行查找
#
#   Default value: false
#
# @param no_resolv
#   If you don't want dnsmasq to read /etc/resolv.conf or any other file, getting its servers
#   from this file instead (see below). Get upstream servers only from the command line or the
#   dnsmasq configuration file.
#   不读取 resolv-file 来确定上游服务器
#
#   Default value: false
#
# @param no_poll
#   If you don't want dnsmasq to poll /etc/resolv.conf or other resolv files for changes and 
#   re-read them then set this attribute true.
#   不检测 /etc/resolv.conf 的变化
#
#   Default value: false
#
# @param other_name_servers
#   Add other name servers here, with domain specs if they are for non-public domains.
#   e.g:
#       other_name_servers => ['/subdomain1.example.org/192.168.0.1', '/subdomain2.example.org/192.168.0.2'],
#
#   Default value: undef
#
# @param ptr_nameservers
#   Example of routing PTR queries to nameservers: this will send all address->name queries for 192.168.3/24 to
#   nameserver 10.1.2.3, 192.168.4/24 to nameserver 10.1.2.4:
#     ptr_nameservers => ['/3.168.192.in-addr.arpa/10.1.2.3', '/4.168.192.in-addr.arpa/10.1.2.4'],
#
#   Default value: undef
#
# @param local_only_domains
#   Add local-only domains here, queries in these domains are answered from /etc/hosts or DHCP only.
#   e.g:
#       local_only_domains => ['/local-example1.org/', '/local-example2.org/'], 
#
#   Default value: undef
#
# @param domains_force_to_ip
#   Add domains which you want to force to an IP address here.
#   The example below send any host in double-click.net to a local web-server.
#     domains_force_to_ip => ['/double-click.net/127.0.0.1'],
#   
#   work with IPv6 addresses too.
#     domains_force_to_ip => ['/www.thekelleys.org.uk/fe80::20d:60ff:fe36:f83'],
#
#   Default value: undef
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
#   Default value: undef
#
# @param queries_via_eth
#   The optional string after the @ character tells dnsmasq how to set the source of the queries to 
#   this nameserver. It can either be an ip-address, an interface name or both. The ip-address should
#   belong to the machine on which dnsmasq is running, otherwise this server line will be logged and
#   then ignored. If an interface name is given, then queries to the server will be forced via that
#   interface; if an ip-address is given then the source address of the queries will be set to that
#   address; and if both are given then a combination of ip-address and interface name will be used
#   to steer requests to the server. The query-port flag is ignored for any servers which have a source
#   address specified but the port may be specified directly as part of the source address. Forcing
#   queries to an interface is not implemented on all platforms supported by dnsmasq. 
#
#   You can control how dnsmasq talks to a server by this attribute, or the `queries_via_ip` attribute
#   shows below. e.g this forces queries to 10.1.2.3 to be routed via eth1:
#
#     queries_via_eth => ['10.1.2.3@eth1'],
#
#   Default value: undef
#
# @param queries_via_ip
#   This sets the source (ie local) address used to talk to 10.1.2.3 to 192.168.1.1 port 55 (there
#   must be an interface with that IP on the machine, obviously).
#
#     queries_via_ip => ['10.1.2.3@192.168.1.1#55'],
#
#   Default value: undef
#
# @param interfaces
#   If you want dnsmasq to listen for DHCP and DNS requests only on specified interfaces (and the
#   loopback) give the name of the interface (eg eth0, eth1) here.
#
#     interfaces => ['eth0', 'eth1'],
#
#   Default value: undef
#
# @param except_interfaces
#   Or you can specify which interface _not_ to listen on
#
#     except_interfaces => ['eth1'],
#
#   Default value: undef
#
# @param listen_addresses
#   Or which to listen on by address (remember to include 127.0.0.1 if you use this.)
#
#     listen_addresses => ['192.168.0.2,127.0.0.1'],
#
#   Default value: undef
#
# @param no_dhcp_interfaces
#   If you want dnsmasq to provide only DNS service on an interface, configure it as shown above,
#   and then use the following line to disable DHCP and TFTP on it.
#
#     no_dhcp_interfaces => ['eth0, eth1'],
#
#   Default value: undef
#
# @param bind_interfaces
#   On systems which support it, dnsmasq binds the wildcard address, even when it is listening on
#   only some interfaces. It then discards requests that it shouldn't reply to. This has the advantage
#   of working even when interfaces come and go and change address. If you want dnsmasq to really bind
#   only the interfaces it is listening on, uncomment this option. About the only time you may need this
#   is when running another nameserver on the same machine.
#
#   Default value: false
#
# @param no_hosts
#   If you don't want dnsmasq to read /etc/hosts, set no_hosts to true.
#
#   Default value: false
#
# @param addn_hosts
#   Additional hosts file. Read the specified file as well as /etc/hosts. If `no_hosts` is given,
#   read only the specified file. This option may be repeated for more than one additional hosts file.
#   If a directory is given, then read all the files contained in that directory in alphabetical order. 
#   e.g
#
#     addn_hosts => ['/etc/banner_add_hosts1', '/etc/banner_add_hosts2'],
#
#   Default value: undef
#
# @param expand_hosts
#   Set this (and domain: see below) if you want to have a domain automatically added to simple names
#   in a hosts-file.
#
# @param domain
#   Set the domain for dnsmasq. this is optional, but if it is set, it does the following things.
#   1) Allows DHCP hosts to have fully qualified domain names, as long as the domain part matches
#      this setting.
#   2) Sets the "domain" DHCP option thereby potentially setting the domain of all systems configured
#      by DHCP
#   3) Provides the domain part for "expand-hosts"
#
# @param domain_for_subnet
#
#   Set a different domain for a particular subnet
#   e.g
#      domain_for_subnet => 'wireless.thekelleys.org.uk,192.168.2.0/24',
#
#   Default value: undef
#
# @param domain_for_range
#
#   Same idea, but range rather then subnet
#   e.g
#     domain_for_range => 'reserved.thekelleys.org.uk,192.68.3.100,192.168.3.200',
#
#   Default value: undef
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
define dnsmasq::conf (
  Enum['present','file','absent'] $ensure               = 'present',
  Integer                         $priority             = 10,
  Optional[Stdlib::Absolutepath]  $source               = undef,

  # conf params
  Optional[String[1]]             $port                  = undef,
  Optional[String[1]]             $user                  = undef,
  Optional[String[1]]             $group                 = undef,
  Boolean                         $domain_needed         = true,
  Boolean                         $bogus_priv            = true,
  Boolean                         $dnssec                = false,
  Boolean                         $dnssec_check_unsigned = false,
  Boolean                         $filterwin2k           = false,
  Optional[Stdlib::Absolutepath]  $resolv_file           = undef,
  Boolean                         $strict_order          = false,
  Boolean                         $no_resolv             = false,
  Boolean                         $no_poll               = false,
  Optional[Array[String]]         $other_name_servers    = undef,
  Optional[Array[String]]         $ptr_nameservers       = undef,
  Optional[Array[String]]         $local_only_domains    = undef,
  Optional[Array[String]]         $domains_force_to_ip   = undef,
  Optional[String[1]]             $ipset                 = undef,
  Optional[Array[String]]         $queries_via_eth       = undef,
  Optional[Array[String]]         $queries_via_ip        = undef,
  Optional[Array[String]]         $interfaces            = undef,
  Optional[Array[String]]         $except_interfaces     = undef,
  Optional[Array[String]]         $listen_addresses      = undef,
  Optional[Array[String]]         $no_dhcp_interfaces    = undef,
  Boolean                         $bind_interfaces       = false,
  Boolean                         $no_hosts              = false,
  Optional[Array[String]]         $addn_hosts            = undef,
  Boolean                         $expand_hosts          = false,
  Optional[String[1]]             $domain                = undef,
  Optional[String[1]]             $domain_for_subnet     = undef,
  Optional[String[1]]             $domain_for_range      = undef,








) {

  include ::dnsmasq

  File {
    owner => 'root',
    group => 'root',
  }

  if $source {
    file { "${dnsmasq::params::config_dir}${priority}-${name}.conf":
      ensure => $ensure,
      source => $source,
      notify => Class['dnsmasq::service'],
    }
  }
  else {
    file { "${dnsmasq::params::config_dir}${priority}-${name}.conf":
      ensure  => $ensure,
      content => template('dnsmasq/dnsmasq.conf.erb'),
      notify  => Class['dnsmasq::service'],
    }
  }
}
