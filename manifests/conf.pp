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
#   dnsmasq::conf { 'dnsmasq': 
#     resolv_file        => '/etc/resolv.conf.dnsmasq',
#     local_only_domains => ['/example.org/'],
#   }
#
# @param ensure
#   Whether the config file should exist. Possible values are present, absent, and file.
#
# @param priority
#   The priority of file in /etc/dnsmasq.d/ directory, which is part of the configuration file name.
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
# @param port
#   Listen on this specific port instead of the standard DNS port (53). Setting this to zero completely disables
#   DNS function, leaving only DHCP and/or TFTP.
#
# @param user
#   Specify the userid  to which dnsmasq will change after startup. Dnsmasq must normally be started as root, 
#   but it will drop root privileges after startup by changing id to another user. Normally this user is "dnsmasq"
#   but that can be over-ridden with this switch.
#
# @param group
#   Specify the group which dnsmasq will run as. The default is "dnsmasq".
#
# @param domain_needed
#   Tells dnsmasq to never forward A or AAAA queries for plain names, without dots or domain parts, to
#   upstream nameservers. If the name is not known from /etc/hosts or DHCP then a "not found" answer is returned. 
#
# @param bogus_priv
#   Bogus private reverse lookups. All reverse lookups for private IP ranges (ie 192.168.x.x, etc) 
#   which are not found in /etc/hosts or the DHCP leases file are answered with "no such domain" 
#   rather than being forwarded upstream. The set of prefixes affected is the list given in RFC6303,
#   for IPv4 and IPv6. 
#
# @param dnssec
#   Enable DNSSEC validation and caching.
#
# @param dnssec_check_unsigned
#   Replies which are not DNSSEC signed may be legitimate, because the domain is unsigned, or may be forgeries. 
#   Setting this option tells dnsmasq to check that an unsigned reply is OK, by finding a secure proof that a DS
#   record somewhere between the root and the domain does not exist.
#   The cost of setting this is that even queries in unsigned domains will need one or more extra DNS queries to verify.
#
# @param filterwin2k
#   Setup this attr true to filter useless windows-originated DNS requests which can trigger dial-on-demand links 
#   needlessly. Note that (amongst other things) this blocks all SRV requests, so don't use it if you use eg Kerberos,
#   SIP, XMMP or Google-talk. This option only affects forwarding, SRV records originating for dnsmasq (via srv-host= 
#   lines) are not suppressed by it.
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
# @param strict_order
#   By  default,  dnsmasq  will  send queries to any of the upstream servers it knows about and
#   tries to favour servers to are  known to  be  up. Uncommenting this forces dnsmasq to try
#   each query with  each  server  strictly in the order they appear in /etc/resolv.conf
#   严格按照 resolv.conf 中的顺序进行查找
#
# @param no_resolv
#   If you don't want dnsmasq to read /etc/resolv.conf or any other file, getting its servers
#   from this file instead (see below). Get upstream servers only from the command line or the
#   dnsmasq configuration file.
#   不读取 resolv-file 来确定上游服务器
#
# @param no_poll
#   If you don't want dnsmasq to poll /etc/resolv.conf or other resolv files for changes and 
#   re-read them then set this attribute true.
#   不检测 /etc/resolv.conf 的变化
#
# @param other_name_servers
#   Add other name servers here, with domain specs if they are for non-public domains.
#   e.g:
#       other_name_servers => ['/subdomain1.example.org/192.168.0.1', '/subdomain2.example.org/192.168.0.2'],
#
# @param ptr_nameservers
#   Example of routing PTR queries to nameservers: this will send all address->name queries for 192.168.3/24 to
#   nameserver 10.1.2.3, 192.168.4/24 to nameserver 10.1.2.4:
#     ptr_nameservers => ['/3.168.192.in-addr.arpa/10.1.2.3', '/4.168.192.in-addr.arpa/10.1.2.4'],
#
#
# @param local_only_domains
#   Add local-only domains here, queries in these domains are answered from /etc/hosts or DHCP only.
#   e.g:
#       local_only_domains => ['/local-example1.org/', '/local-example2.org/'], 
#
#
# @param domains_force_to_ip
#   Add domains which you want to force to an IP address here.
#   The example below send any host in double-click.net to a local web-server.
#     domains_force_to_ip => ['/double-click.net/127.0.0.1'],
#   
#   work with IPv6 addresses too.
#     domains_force_to_ip => ['/www.thekelleys.org.uk/fe80::20d:60ff:fe36:f83'],
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
# @param queries_via_ip
#   This sets the source (ie local) address used to talk to 10.1.2.3 to 192.168.1.1 port 55 (there
#   must be an interface with that IP on the machine, obviously).
#
#     queries_via_ip => ['10.1.2.3@192.168.1.1#55'],
#
#
# @param interfaces
#   If you want dnsmasq to listen for DHCP and DNS requests only on specified interfaces (and the
#   loopback) give the name of the interface (eg eth0, eth1) here.
#
#     interfaces => ['eth0', 'eth1'],
#
#
# @param except_interfaces
#   Or you can specify which interface _not_ to listen on
#
#     except_interfaces => ['eth1'],
#
#
# @param listen_addresses
#   Or which to listen on by address (remember to include 127.0.0.1 if you use this.)
#
#     listen_addresses => ['192.168.0.2,127.0.0.1'],
#
# @param no_dhcp_interfaces
#   If you want dnsmasq to provide only DNS service on an interface, configure it as shown above,
#   and then use the following line to disable DHCP and TFTP on it.
#
#     no_dhcp_interfaces => ['eth0, eth1'],
#
#
# @param bind_interfaces
#   On systems which support it, dnsmasq binds the wildcard address, even when it is listening on
#   only some interfaces. It then discards requests that it shouldn't reply to. This has the advantage
#   of working even when interfaces come and go and change address. If you want dnsmasq to really bind
#   only the interfaces it is listening on, uncomment this option. About the only time you may need this
#   is when running another nameserver on the same machine.
#
#
# @param no_hosts
#   If you don't want dnsmasq to read /etc/hosts, set no_hosts to true.
#
#
# @param addn_hosts
#   Additional hosts file. Read the specified file as well as /etc/hosts. If `no_hosts` is given,
#   read only the specified file. This option may be repeated for more than one additional hosts file.
#   If a directory is given, then read all the files contained in that directory in alphabetical order. 
#   e.g
#
#     addn_hosts => ['/etc/banner_add_hosts1', '/etc/banner_add_hosts2'],
#
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
#   e.g
#     domain => ['sansovo.org'],
#
#   Set a different domain for a particular subnet
#   e.g
#      domain => ['wireless.thekelleys.org.uk,192.168.2.0/24'],
#
#   Same idea, but range rather then subnet
#   e.g
#     domain => ['reserved.thekelleys.org.uk,192.68.3.100,192.168.3.200'],
#
# @param dhcp_range
#    Enable the DHCP server. Addresses will be given out from the range <start-addr> to <end-addr>
#    and from statically defined addresses given in `dhcp_host` options. If the lease time is given,
#    then leases will be given for that length of time. The lease time is in seconds, or minutes (eg
#    45m) or hours (eg 1h) or days (2d) or weeks (1w) or "infinite". If not given, the default lease
#    time is one hour for IPv4 and one day for IPv6. The minimum lease time is two minutes. For IPv6
#    ranges, the lease time maybe "deprecated"; this sets the preferred lifetime sent in a DHCP lease
#    or router advertisement to zero, which causes clients to use other addresses, if available, for
#    new connections as a prelude to renumbering.
#
#    This attribute may be has one or more items in the arrary, with different addresses, to enable
#    DHCP service to more than one network.
#
#    Example:
#
#     dhcp_range => ['192.168.0.50,192.168.0.100,12h','192.168.0.101,192.168.0.150,2d'],
#
#   For directly connected networks (ie, networks on which the machine running dnsmasq has an
#   interface) the netmask is optional: dnsmasq will determine it from the interface configuration.
#   For networks which receive DHCP service via a relay agent, dnsmasq cannot determine the netmask
#   itself, so it should be specified, otherwise dnsmasq will have to guess, based on the class
#   (A, B or C) of the network address. The broadcast address is always optional.
#   e.g
#
#     dhcp_range => ['192.168.0.100,192.168.0.150,255.255.255.0,12h'],
#
#   The optional set:<tag> sets an alphanumeric label which marks this network so that DHCP options
#   may be specified on a per-network basis. When it is prefixed with 'tag:' instead, then its meaning
#   changes from setting a tag to matching it. Only one tag may be set, but more than one tag may be
#   matched.
#   e.g
#     dhcp_range => ['set:red,192.168.0.50,192.168.0.99', 'tag:green,192.168.0.100,192.168.0.150,12h'],
#
#   Specify a subnet which can't be used for dynamic address allocation, is available for hosts with
#   matching --dhcp-host lines. Note that dhcp-host declarations will be ignored unless there is a
#   dhcp-range of some type for the subnet in question. In this case the netmask is implied (it comes
#   from the network configuration on the machine running dnsmasq) it is possible to give an explicit
#   netmask instead.
#   e.g
#     dhcp_rang => ['192.168.0.0, static'],
#
#   Enable DHCPv6. Note that the prefix-length does not need to be specified and defaults to 64 if
#   missing.
#   e.g
#     dhcp_range => ['1234::2, 1234::500, 64, 12h'],
#
#   `ra-only` tells dnsmasq to offer Router Advertisement only on this subnet, and not DHCP. Optional
#   set the lifetime to n hours. (Note: minimum lifetime is 2 hours.)
#   e.g
#       dhcp_range => ['1234::, ra-only', '4567::, ra-only, 48h'],
#
#   `ra-names` enables a mode which gives DNS names to dual-stack hosts which do SLAAC for IPv6.
#   Dnsmasq uses the host's IPv4 lease to derive the name, network segment and MAC address and
#   assumes that the host will also have an IPv6 address calculated using the SLAAC algorithm,
#   on the same network segment. The address is pinged, and if a reply is received, an AAAA record
#   is added to the DNS for this IPv6 address. Note that this is only happens for directly-connected
#   networks, (not one doing DHCP via a relay) and it will not work if a host is using privacy
#   extensions. ra-names can be combined with ra-stateless and slaac. 
#   e.g
#     dhcp_range => ['1234::, ra-names'],
#
#   `slaac` tells dnsmasq to offer Router Advertisement on this subnet and to set the A bit in the
#   router advertisement, so that the client will use SLAAC addresses. When used with a DHCP range
#   or static DHCP address this results in the client having both a DHCP-assigned and a SLAAC address.
#   e.g
#     dhcp_range => ['1234::2, 1234::500, slaac'],
#
#   ra-stateless sends router advertisements with the O and A bits set, and provides a stateless
#   DHCP service. The client will use a SLAAC address, and use DHCP for other configuration information.
#   e.g
#     dhcp_range =>  => ['1234::, ra-stateless'],
#
#   Do stateless DHCP, SLAAC, and generate DNS names for SLAAC addresses from DHCPv4 leases.
#   
#     dhcp_range => ['1234::, ra-stateless, ra-names'],
#
# @param dhcp_enable_ra
#   Enable dnsmasq's IPv6 Router Advertisement feature. DHCPv6 doesn't handle complete network
#   configuration in the same way as DHCPv4. Router discovery and (possibly) prefix discovery
#   for autonomous address creation are handled by a different protocol. When DHCP is in use,
#   only a subset of this is needed, and dnsmasq can handle it, using existing DHCP configuration
#   to provide most data. When RA is enabled, dnsmasq will advertise a prefix for each --dhcp-range,
#   with default router as the relevant link-local address on the machine running dnsmasq. By
#   default, the "managed address" bits are set, and the "use SLAAC" bit is reset. This can be
#   changed for individual subnets with the mode keywords described in --dhcp-range. RFC6106 DNS
#   parameters are included in the advertisements. By default, the relevant link-local address of
#   the machine running dnsmasq is sent as recursive DNS server. If provided, the DHCPv6 options
#   dns-server and domain-search are used for the DNS server (RDNSS) and the domain search list (DNSSL). 
#
#
# @param dhcp_host
#   Specify per host parameters for the DHCP server. This allows a machine with a particular
#   hardware address to be always allocated the same hostname, IP address and lease time. A hostname
#   specified like this overrides any supplied by the DHCP client on the machine. It is also allowable
#   to omit the hardware address and include the hostname, in which case the IP address and lease times
#   will apply to any machine claiming that name. 
#
#   Supply parameters for specified hosts using DHCP. There are lots of valid alternatives, so we will
#   give examples of each. You can use these syntaxs to add `dhcp_host` array items to setup `dhcp-host`
#   option. Note that IP addresses DO NOT have to be in the range given above, they just need to
#   be on the same network. The order of the parameters in these do not matter, it's permissible
#   to give name, address and MAC in any order.
#
#   Show one item per example, but they can be as multiple items in the `dhcp_host` attribute.
#
#   e.g Always allocate the host with Ethernet address 11:22:33:44:55:66, the IP address 192.168.0.60
#
#       dhcp_host => ['11:22:33:44:55:66,192.168.0.60'],
#
#   e.g Always set the name of the host with hardware address, 11:22:33:44:55:66 to be "fred"
#
#       dhcp_host => ['11:22:33:44:55:66,fred'],
#
#   e.g Always give the host with Ethernet address 11:22:33:44:55:66, the name fred and IP address
#   192.168.0.60 and lease time 45 minutes
#
#       dhcp_host => ['11:22:33:44:55:66,fred,192.168.0.60,45m'],
#
#   Example:
#     Give a host with Ethernet address 11:22:33:44:55:66 or 12:34:56:78:90:12 the IP address
#     192.168.0.60. Dnsmasq will assume that these two Ethernet interfaces will never be in use
#     at the same time, and give the IP address to the second, even if it is already in use by
#     the first. Useful for laptops with wired and wireless addresses.
#
#       dhcp_host => ['11:22:33:44:55:66,12:34:56:78:90:12,192.168.0.60'],
#
#   Example:
#     Give the machine which says its name is "bert" IP address 192.168.0.70 and an infinite lease
#
#       dhcp_host => ['bert,192.168.0.70,infinite'],
#
#   Example:
#     Always give the host with client identifier 01:02:02:04, the IP address 192.168.0.60
#
#       dhcp_host => ['id:01:02:02:04,192.168.0.60'],
#
#   Example:
#     Always give the InfiniBand interface with hardware address 
#     80:00:00:48:fe:80:00:00:00:00:00:00:f4:52:14:03:00:28:05:81
#     the ip address 192.168.0.61. The client id is derived from the prefix
#     ff:00:00:00:00:00:02:00:00:02:c9:00 and the last 8 pairs of hex digits of the hardware address.
#
#       dhcp_host => ['id:ff:00:00:00:00:00:02:00:00:02:c9:00:f4:52:14:03:00:28:05:81,192.168.0.61'],
#
#   Example:
#     Always give the host with client identifier "marjorie" the IP address 192.168.0.60
#
#       dhcp_host => ['id:marjorie,192.168.0.60'],
#
#   Example:
#     Enable the address given for "judge" in /etc/hosts to be given to a machine presenting the name
#    "judge" when it asks for a DHCP lease.
#
#       dhcp_host => ['judge'],
#
#   Example:
#     Never offer DHCP service to a machine whose Ethernet address is 11:22:33:44:55:66
#
#       dhcp_host => ['11:22:33:44:55:66,ignore'],
#
#   Example:
#     Ignore any client-id presented by the machine with Ethernet address 11:22:33:44:55:66. This is
#     useful to prevent a machine being treated differently when running under different OS's or between
#     PXE boot and OS boot.
#
#       dhcp_host => ['11:22:33:44:55:66,id:*'],
#
#   Example:
#     Send extra options which are tagged as "red" to the machine with Ethernet address 11:22:33:44:55:66
#
#       dhcp_host => ['11:22:33:44:55:66,set:red'],
#
#   Example:
#      Send extra options which are tagged as "red" to any machine with Ethernet address starting
#      11:22:33:
#
#       dhcp_host => ['11:22:33:*:*:*,set:red'],
#
#   Example:
#     Give a fixed IPv6 address and name to client with DUID 00:01:00:01:16:d2:83:fc:92:d4:19:e2:d8:b2
#     Note the MAC addresses CANNOT be used to identify DHCPv6 clients.
#     Note also that the [] around the IPv6 address are obligatory.
#
#       dhcp_host => ['id:00:01:00:01:16:d2:83:fc:92:d4:19:e2:d8:b2, fred, [1234::5]'],
#
# @param dhcp_ignore
#   When all the given tags appear in the tag set ignore the host and do not allocate it a DHCP lease. 
#   Ignore any clients which are not specified in dhcp-host lines or /etc/ethers. Equivalent to ISC 
#   "deny unknown-clients".
#   e.g
#     dhcp_ignore => ['tag:!known', 'tag:black'],
#
# @param dhcp_vendorclass
#   Map from a vendor-class string to a tag. Most DHCP clients provide a "vendor class" which
#   represents, in some sense, the type of host. This option maps vendor classes to tags, so that
#   DHCP options may be selectively delivered to different classes of hosts. For example,
#
#     dhcp_vendorclass => ['set:printers,Hewlett-Packard JetDirect'],
#
#   will allow options to be set only for HP printers like so: dhcp_option => ['tag:printers,3,192.168.4.4'].
#   The vendor-class string is substring matched against the vendor-class supplied by the client, to
#   allow fuzzy matching. The set: prefix is optional but allowed for consistency.
#
#   Note that in IPv6 only, vendorclasses are namespaced with an IANA-allocated enterprise number.
#   This is given with enterprise: keyword and specifies that only vendorclasses matching the
#   specified number should be searched. 
#
#   Item syntax in this attribute::
#
#     set:<tag>,[enterprise:<IANA-enterprise number>,]<vendor-class>
#
#   e.g
#
#     dhcp_vendorclass => ['set:red,Linux'],
#
#
# @param dhcp_userclass
#   Map from a user-class string to a tag (with substring matching, like vendor classes).
#   Most DHCP clients provide a "user class" which is configurable. This option maps user classes
#   to tags, so that DHCP options may be selectively delivered to different classes of hosts. It
#   is possible, for instance to use this to set a different printer server for hosts in the
#   class "accounts" than for hosts in the class "engineering".
#
#   Item syntax in this attribute::
#
#     set:<tag>,<user-class>
#
#   e.g
#
#     dhcp_userclass => ['set:red,accounts'],
#
#
# @param dhcp_mac
#   Map from a MAC address to a tag. The MAC address may include wildcards. For example,
#
#     dhcp_mac => ['set:3com,01:34:23:*:*:*'],
#
#   will set the tag "3com" for any host whose MAC address matches the pattern. 
#
#   Item syntax in this attribute::
#
#     set:<tag>,<MAC address>
#
#
# @param read_ethers
#   Read /etc/ethers for information about hosts for the DHCP server. The format of /etc/ethers is
#   a hardware address, followed by either a hostname or dotted-quad IP address. When read by dnsmasq
#   these lines have exactly the same effect as `dhcp_host` options containing the same information.
#   /etc/ethers is re-read when dnsmasq receives SIGHUP. IPv6 addresses are NOT read from /etc/ethers. 
#
#
# @param dhcp_option
#   Specify different or extra options to DHCP clients. By default, dnsmasq sends some standard options
#   to DHCP clients, the netmask and broadcast address are set to the same as the host running dnsmasq,
#   and the DNS server and default route are set to the address of the machine running dnsmasq. 
#   (Equivalent rules apply for IPv6.) If the domain name option has been set, that is sent. This
#   configuration allows these defaults to be overridden, or other options specified. The option,
#   to be sent may be given as a decimal number or as "option:<option-name>" The option numbers are
#   specified in RFC2132 and subsequent RFCs. The set of option-names known by dnsmasq can be
#   discovered by running "dnsmasq --help dhcp". For example, to set the default route option to
#   192.168.4.4, do dhcp_option => ['3,192.168.4.4'] or dhcp_option => ['option:router, 192.168.4.4']
#   and to set the time-server address to 192.168.0.4, do dhcp_option => ['42,192.168.0.4'] or
#   dhcp_option => ['option:ntp-server, 192.168.0.4'].
#   The special address 0.0.0.0 is taken to mean "the address of the machine running dnsmasq".
#
#   Item syntax in this attribute:
#
#     [tag:<tag>,[tag:<tag>,]][encap:<opt>,][vi-encap:<enterprise>,][vendor:[<vendor-class>],]  \
#     [<opt>|option:<opt-name>|option6:<opt>|option6:<opt-name>],[<value>[,<value>]]
#
#   Data types allowed are comma separated dotted-quad IPv4 addresses, []-wrapped IPv6 addresses, 
#   a decimal number, colon-separated hex digits and a text string. If the optional tags are given then
#   this option is only sent when all the tags are matched.
#
#   Special processing is done on a text argument for option 119, to conform with RFC 3397. Text or
#   dotted-quad IP addresses as arguments to option 120 are handled as per RFC 3361. Dotted-quad IP
#   addresses which are followed by a slash and then a netmask size are encoded as described in RFC 3442. 
#
#   IPv6 options are specified using the option6: keyword, followed by the option number or option name. 
#   The IPv6 option name space is disjoint from the IPv4 option name space. IPv6 addresses in options
#   must be bracketed with square brackets, eg. dhcp_option => ['option6:ntp-server,[1234::56]'] For IPv6, 
#   [::] means "the global address of the machine running dnsmasq", whilst [fd00::] is replaced with 
#   the ULA, if it exists, and [fe80::] with the link-local address.
#
#   Be careful: no checking is done that the correct type of data for the option number is sent, it is
#   quite possible to persuade dnsmasq to generate illegal DHCP packets with injudicious use of this
#   flag. When the value is a decimal number, dnsmasq must determine how large the data item is. It
#   does this by examining the option number and/or the value, but can be overridden by appending a
#   single letter flag as follows: b = one byte, s = two bytes, i = four bytes. This is mainly useful
#   with encapsulated vendor class options (see below) where dnsmasq cannot determine data size from
#   the option number. Option data which consists solely of periods and digits will be interpreted by
#   dnsmasq as an IP address, and inserted into an option as such. To force a literal string, use quotes.
#   For instance when using option 66 to send a literal IP address as TFTP server name, it is necessary 
#   to do dhcp_option = ['66,"1.2.3.4"'].
#
# 
#   Example:
#     Override the default route supplied by dnsmasq, which assumes the router is the same machine as
#     the one running dnsmasq.
#
#       dhcp_option => ['3,1.2.3.4'],
#
#     Do the same thing, but using the option name:
#
#       dhcp_option = ['option:router,1.2.3.4'],
# 
#   Example:
#     Override the default route supplied by dnsmasq and send no default route at all. Note that this
#     only works for the options sent by default (1, 3, 6, 12, 28) the same line will send a zero-length
#     option for all other option numbers.
#
#       dhcp_option => ['3'],
#
#   Example:
#     Set the NTP time server addresses to 192.168.0.4 and 10.10.0.5
#
#       dhcp_option => ['option:ntp-server,192.168.0.4,10.10.0.5'],
#
#   Example:
#     Send DHCPv6 option. Note [] around IPv6 addresses.
#
#       dhcp_option => ['option6:dns-server,[1234::77],[1234::88]'],
#
#   Example:
#     Send DHCPv6 option for namservers as the machine running dnsmasq and another.
#
#       dhcp_option => ['option6:dns-server,[::],[1234::88]'],
#
#   Example:
#     Ask client to poll for option changes every six hours. (RFC4242)
#
#       dhcp_option => ['option6:information-refresh-time,6h'],
#
#   Example:
#     Set option 58 client renewal time (T1). Defaults to half of the lease time if not specified. (RFC2132)
#
#       dhcp_option => ['option:T1,1m'],
#
#   Example:
#     Set option 59 rebinding time (T2). Defaults to 7/8 of the lease time if not specified. (RFC2132)
# 
#       dhcp_option => ['option:T2,2m'],
#
#   Example:
#     Set the NTP time server address to be the same machine as is running dnsmasq
#
#       dhcp_option => ['42,0.0.0.0'],
#
#   Example:
#     Set the NIS domain name to "welly"
#
#       dhcp_option => ['40,welly'],
#
#   Example:
#     Set the default time-to-live to 50
#
#       dhcp_option => ['23,50'],
#
#   Example:
#     Set the "all subnets are local" flag
#
#       dhcp_option => ['27,1'],
#
#   Example:
#     Send the etherboot magic flag and then etherboot options (a string).
#
#       dhcp_option => ['128,e4:45:74:68:00:00', '129,NIC=eepro100'],
#
#   Example:
#     Specify an option which will only be sent to the "red" network (see dhcp-range for the 
#     declaration of the "red" network)
#     Note that the tag: part must precede the option: part.
#
#       dhcp_option => ['tag:red, option:ntp-server, 192.168.1.1'],
#
#   The following DHCP options set up dnsmasq in the same way as is specified for the ISC dhcpcd in
#   http://www.samba.org/samba/ftp/docs/textdocs/DHCP-Server-Configuration.txt
#   adapted for a typical dnsmasq installation where the host running dnsmasq is also the host running
#   samba. You may want to use some or all of them if you use Windows clients and Samba.
#
#   Example:
#     dhcp_option => ['19,0'],           # option ip-forwarding off
#     dhcp_option => ['44,0.0.0.0'],     # set netbios-over-TCP/IP nameserver(s) aka WINS server(s)
#     dhcp_option => ['45,0.0.0.0'],     # netbios datagram distribution server
#     dhcp_option => ['46,8'],           # netbios node type
#
#   Example:
#     Send an empty WPAD option. This may be REQUIRED to get windows 7 to behave.
#
#       dhcp_option => ['252,"\n"'],
#
#   Example:
#     Send RFC-3397 DNS domain search DHCP option. WARNING: Your DHCP client probably doesn't support
#     this......
#
#       dhcp_option => ['option:domain-search,eng.apple.com,marketing.apple.com'],
#
#   Example:
#     Send RFC-3442 classless static routes (note the netmask encoding)
#
#       dhcp_option => ['121,192.168.1.0/24,1.2.3.4,10.0.0.0/8,5.6.7.8'],
#
#   Example:
#     Send vendor-class specific options encapsulated in DHCP option 43. The meaning of the options
#     is defined by the vendor-class so options are sent only when the client supplied vendor class
#     matches the class given here. (A substring match is OK, so "MSFT" matches "MSFT" and "MSFT 5.0").
#     This example sets the mtftp address to 0.0.0.0 for PXEClients.
#
#       dhcp_option => ['vendor:PXEClient,1,0.0.0.0'],
#
#   Example:
#     Send microsoft-specific option to tell windows to release the DHCP lease when it shuts down.
#     Note the "i" flag, to tell dnsmasq to send the value as a four-byte integer - that's what
#     microsoft wants. See
#     http://technet2.microsoft.com/WindowsServer/en/library/a70f1bb7-d2d4-49f0-96d6-4b7414ecfaae1033.mspx?mfr=true
#
#       dhcp_option => ['vendor:MSFT,2,1i'],
#
#   Example:
#     Send the Encapsulated-vendor-class ID needed by some configurations of Etherboot to allow is to
#     recognise the DHCP server.
#
#       dhcp_option => ['vendor:Etherboot,60,"Etherboot"'],
#
# @param dhcp_option_force
#   This works in exactly the same way as --dhcp-option except that the option will always be sent,
#   even if the client does not ask for it in the parameter request list. This is sometimes needed,
#   for example when sending options to PXELinux. 
#   
#   Item syntax in this attribute:
#   
#     [tag:<tag>,[tag:<tag>,]][encap:<opt>,][vi-encap:<enterprise>,][vendor:[<vendor-class>],]<opt>,[<value>[,<value>]]
# 
#   Send options to PXELinux. Note that we need to send the options even though they don't appear in
#   the parameter request list, so we need to use dhcp-option-force here.
#   See http://syslinux.zytor.com/pxe.php#special for details.
#
#   Magic number - needed before anything else is recognised
#
#     dhcp_option_force => ['208,f1:00:74:7e'],
#
#   Configuration file name
#
#     dhcp_option_force => ['209,configs/common'],
#
#   Path prefix
#
#     dhcp_option_force => ['210,/tftpboot/pxelinux/files/'],
#
#   Reboot time. (Note 'i' to send 32-bit value)
#
#     dhcp_option_force => ['211,30i'],
#
# @param dhcp_boot
#   (IPv4 only) Set BOOTP options to be returned by the DHCP server. Server name and address are
#   optional: if not provided, the name is left empty, and the address set to the address of the
#   machine running dnsmasq. If dnsmasq is providing a TFTP service (see --enable-tftp ) then only
#   the filename is required here to enable network booting. If the optional tag(s) are given, 
#   they must match for this configuration to be sent. Instead of an IP address, the TFTP server
#   address can be given as a domain name which is looked up in /etc/hosts. This name can be associated
#   in /etc/hosts with multiple IP addresses, which are used round-robin. This facility can be used
#   to load balance the tftp load among a set of servers.
#
#   Item syntax in this attribute:
#
#     [tag:<tag>,]<filename>,[<servername>[,<server address>|<tftp_servername>]]
#
#
#   Example:
#     Set the boot filename for netboot/PXE. You will only need this if you want to boot machines over
#     the network and you will need a TFTP server; either dnsmasq's built-in TFTP server or an external
#     one. (See below for how to enable the TFTP server.)
#
#       dhcp_boot => ['pxelinux.0'],
#
#   Example:
#     The same as above, but use custom tftp-server instead machine running dnsmasq
#
#       dhcp_boot => ['pxelinux,server.name,192.168.1.100'],
#
#   Example:
#     Boot for iPXE. The idea is to send two different filenames, the first loads iPXE, and the second
#     tells iPXE what to load. The `dhcp_match` sets the ipxe tag for requests from iPXE.
#
#       dhcp_boot  => ['undionly.kpxe', 'tag:ipxe,http://boot.ipxe.org/demo/boot.php'],
#       dhcp_match => ['set:ipxe,175'], # iPXE sends a 175 option.
#
#   Encapsulated options for iPXE. All the options are encapsulated within option 175
#
#     dhcp_option => ['encap:175, 1, 5b'],         # priority code
#     dhcp_option => ['encap:175, 176, 1b'],       # no-proxydhcp
#     dhcp_option => ['encap:175, 177, string'],   # bus-id
#     dhcp_option => ['encap:175, 189, 1b'],       # BIOS drive code
#     dhcp_option => ['encap:175, 190, user'],     # iSCSI username
#     dhcp_option => ['encap:175, 191, pass'],     # iSCSI password
#
#   Example:
#     Set the boot file name only when the "red" tag is set.
#
#       dhcp_boot => ['tag:red,pxelinux.red-net'],
#
#   Example:
#     An example of dhcp-boot with an external TFTP server: the name and IP address of the server are
#     given after the filename. Can fail with old PXE ROMS. Overridden by --pxe-service.
#
#       dhcp_boot => ['/var/ftpd/pxelinux.0,boothost,192.168.0.3'],
#
#   Example:
#     If there are multiple external tftp servers having a same name (using /etc/hosts) then that name
#     can be specified as the tftp_servername (the third option to dhcp-boot) and in that case dnsmasq
#     resolves this name and returns the resultant IP addresses in round robin fashion. This facility
#     can be used to load balance the tftp load among a set of servers.
#
#       dhcp_boot => ['/var/ftpd/pxelinux.0,boothost,tftp_server_name'],
#
# @param dhcp_match
#   Without a value, set the tag if the client sends a DHCP option of the given number or name. When
#   a value is given, set the tag only if the option is sent and matches the value. The value may be
#   of the form "01:ff:*:02" in which case the value must match (apart from wildcards) but the option
#   sent may have unmatched data past the end of the value. The value may also be of the same form as
#   in --dhcp-option in which case the option sent is treated as an array, and one element must match,
#   so --dhcp_match => set:efi-ia32,option:client-arch,6 will set the tag "efi-ia32" if the the number 6
#   appears in the list of architectures sent by the client in option 93. (See RFC 4578 for details.)
#   If the value is a string, substring matching is used.
#
#   Item syntax in this attribute:
#
#     set:<tag>,<option number>|option:<option name>|vi-encap:<enterprise>[,<value>]
#
#
#   Example:
#
#     dhcp_match => ['peecees, option:client-arch, 0'], #x86-32
#     dhcp_match => ['itanics, option:client-arch, 2'], #IA64
#     dhcp_match => ['hammers, option:client-arch, 6'], #x86-64
#     dhcp_match => ['mactels, option:client-arch, 7'], #EFI x86-64
#
# @param pxe_prompt
#   Setting this provides a prompt to be displayed after PXE boot. If the timeout is given then after the
#   timeout has elapsed with no keyboard input, the first available menu option will be automatically
#   executed. If the timeout is zero then the first available menu item will be executed immediately. 
#   If --pxe-prompt is omitted the system will wait for user input if there are multiple items in the
#   menu, but boot immediately if there is only one. See --pxe-service for details of menu items.
#
#   Dnsmasq supports PXE "proxy-DHCP", in this case another DHCP server on the network is responsible
#   for allocating IP addresses, and dnsmasq simply provides the information given in --pxe-prompt and
#   --pxe-service to allow netbooting. This mode is enabled using the `proxy` keyword in --dhcp-range. 
#
#   Item syntax in this attribute:
#
#     [tag:<tag>,]<prompt>[,<timeout>]
#
#
#   Example:
#
#     pxe_prompt => "What system shall I netboot?",
#
#   or with timeout before first available action is taken:
#
#     pxe_prompt => '"Press F8 for menu.", 60',
#
# @param pxe_service
#   Item syntax in this attribute:
#
#     [tag:<tag>,]<CSA>,<menu text>[,<basename>|<bootservicetype>][,<server address>|<server_name>]
#
#   Default value: undef
#
#   Most uses of PXE boot-ROMS simply allow the PXE system to obtain an IP address and then download
#   the file specified by --dhcp-boot and execute it. However the PXE system is capable of more complex
#   functions when supported by a suitable DHCP server. 
#
#   This specifies a boot option which may appear in a PXE boot menu. <CSA> is client system type, only
#   services of the correct type will appear in a menu. The known types are x86PC, PC98, IA64_EFI, Alpha,
#   Arc_x86, Intel_Lean_Client, IA32_EFI, x86-64_EFI, Xscale_EFI, BC_EFI, ARM32_EFI and ARM64_EFI; an
#   integer may be used for other types. The parameter after the menu text may be a file name, in which
#   case dnsmasq acts as a boot server and directs the PXE client to download the file by TFTP, either
#   from itself ( --enable-tftp must be set for this to work) or another TFTP server if the final server
#   address/name is given. Note that the "layer" suffix (normally ".0") is supplied by PXE, and need not
#   be added to the basename. Alternatively, the basename may be a filename, complete with suffix, in
#   which case no layer suffix is added. If an integer boot service type, rather than a basename is
#   given, then the PXE client will search for a suitable boot service for that type on the network. 
#   This search may be done by broadcast, or direct to a server if its IP address/name is provided. If
#   no boot service type or filename is provided (or a boot service type of 0 is specified) then the
#   menu entry will abort the net boot procedure and continue booting from local media. The server
#   address can be given as a domain name which is looked up in /etc/hosts. This name can be associated
#   in /etc/hosts with multiple IP addresses, which are used round-robin. 
#
#   Examples:
#     Available boot services. for PXE.
#
#       pxe_service => ['x86PC, "Boot from local disk"'],
#
#     Loads <tftp-root>/pxelinux.0 from dnsmasq TFTP server.
#
#       pxe_service => ['x86PC, "Install Linux", pxelinux'],
#
#     Loads <tftp-root>/pxelinux.0 from TFTP server at 1.2.3.4. Beware this fails on old PXE ROMS.
#
#       pxe_service => ['x86PC, "Install Linux", pxelinux, 1.2.3.4'],
#
#     Use bootserver on network, found my multicast or broadcast.
#
#       pxe_service => ['x86PC, "Install windows from RIS server", 1'],
#
#     Use bootserver at a known IP address.
#
#       pxe_service => ['x86PC, "Install windows from RIS server", 1, 1.2.3.4'],
#
# @param enable_tftp
#   Item syntax in this attribute:
#
#     enable-tftp[=<interface>[,<interface>]]
#
#   Enable the TFTP server function. This is deliberately limited to that needed to net-boot a client.
#   Only reading is allowed; the tsize and blksize extensions are supported (tsize is only supported in
#   octet mode). Without an argument, the TFTP service is provided to the same set of interfaces as DHCP
#   service. If the list of interfaces is provided, that defines which interfaces receive TFTP service. 
#
# @param tftp_root
#   Look for files to transfer using TFTP relative to the given directory. When this is set, TFTP paths
#   which include ".." are rejected, to stop clients getting outside the specified root. Absolute paths
#   (starting with /) are allowed, but they must be within the tftp-root. If the optional interface
#   argument is given, the directory is only used for TFTP requests via that interface. 
#
#   Item syntax in this attribute:
#
#     <directory>[,<interface>]
#
#   e.g
#     tftp_root => '/var/ftpd',
#
# @param tftp_no_fail
#   Do not abort startup if specified tftp root directories are inaccessible.
#
# @param tftp_secure
#   Enable TFTP secure mode: without this, any file which is readable by the dnsmasq process under
#   normal unix access-control rules is available via TFTP. When the --tftp-secure flag is given, 
#   only files owned by the user running the dnsmasq process are accessible. If dnsmasq is being 
#   run as root, different rules apply: --tftp-secure has no effect, but only files which have the
#   world-readable bit set are accessible. It is not recommended to run dnsmasq as root with TFTP
#   enabled, and certainly not without specifying --tftp-root. Doing so can expose any world-readable
#   file on the server to any host on the net. 
#
# @param tftp_no_blocksize
#   Stop the TFTP server from negotiating the "blocksize" option with a client. Some buggy clients
#   request this option but then behave badly when it is granted. 
#
# @param dhcp_lease_max
#   Limits dnsmasq to the specified maximum number of DHCP leases. The default is 150. This limit is
#   to prevent DoS attacks from hosts which create thousands of leases and use lots of memory in the
#   dnsmasq process. 
#
# @param dhcp_leasefile
#   The DHCP server needs somewhere on disk to keep its lease database. This defaults to a sane
#   location, but if you want to change it, use the line below.
#
#     dhcp_leasefile => '/var/lib/misc/dnsmasq.leases',
#
# @param dhcp_authoritative
#   Set the DHCP server to authoritative mode. In this mode it will barge in and take over the lease
#   for any client which broadcasts on the network, whether it has a record of the lease or not. This
#   avoids long timeouts when a machine wakes up on a new network. DO NOT enable this if there's the
#   slightest chance that you might end up accidentally configuring a DHCP server for your campus/company
#   accidentally. The ISC server uses the same option, and this URL provides more information:
#   http://www.isc.org/files/auth.html
#
# @param dhcp_rapid_commit
#   Set the DHCP server to enable DHCPv4 Rapid Commit Option per RFC 4039. In this mode it will
#   respond to a DHCPDISCOVER message including a Rapid Commit option with a DHCPACK including a
#   Rapid Commit option and fully committed address and configuration information. This must only
#   be enabled if either the server is the only server for the subnet, or multiple servers are present
#   and they each commit a binding for all clients.
#
# @param dhcp_script
#   Run an executable when a DHCP lease is created or destroyed. The path must be an absolute pathname,
#   no PATH search occurs. The arguments sent to the script are "add" or "del", then the MAC address,
#   the IP address and finally the hostname if there is one.
#
#   Example:
#     dhcp_script => '/bin/echo',
#
# @param cache_size
#   Set the size of dnsmasq's cache. The default is 150 names. Setting the cache size to zero disables
#   caching. Note: huge cache size impacts performance.
#
#   Example:
#     cache_size => 200,
#
# @param no_negcache
#   Disable negative caching. Negative caching allows dnsmasq to remember "no such domain" answers
#   from upstream nameservers and answer identical queries without forwarding them again. 
#
# @param local_ttl
#   When replying with information from /etc/hosts or configuration or the DHCP leases file dnsmasq
#   by default sets the time-to-live field to zero, meaning that the requester should not itself cache
#   the information. This is the correct thing to do in almost all situations. This option allows a 
#   time-to-live (in seconds) to be given for these replies. This will reduce the load on the server
#   at the expense of clients using stale data under some circumstances. 
#
# @param bogus_nxdomain
#   Transform replies which contain the specified address or subnet into "No such domain" replies.
#   IPv4 and IPv6 are supported. This is intended to counteract a devious move made by Verisign in 
#   September 2003 when they started returning the address of an advertising web page in response 
#   to queries for unregistered names, instead of the correct NXDOMAIN response. This option tells
#   dnsmasq to fake the correct response when it sees this behaviour. As at Sept 2003 the IP address
#   being returned by Verisign is 64.94.110.11 .
#
#   Item syntax in this attribute:
#
#     <ipaddr>[/prefix]
#
#   Example:
#
#       bogus_nxdomain => ['64.94.110.11'],
#
# @param dns_alias
#   Modify IPv4 addresses returned from upstream nameservers; old-ip is replaced by new-ip. If the
#   optional mask is given then any address which matches the masked old-ip will be re-written. So,
#   for instance --alias=1.2.3.0,6.7.8.0,255.255.255.0 will map 1.2.3.56 to 6.7.8.56 and 1.2.3.67 to
#   6.7.8.67. This is what Cisco PIX routers call "DNS doctoring". If the old IP is given as range,
#   then only addresses in the range, rather than a whole subnet, are re-written. So
#   --alias=192.168.0.10-192.168.0.40,10.0.0.0,255.255.255.0 maps 192.168.0.10->192.168.0.40 to 10.0.0.10->10.0.0.40 
#
#   Item syntax in this attribute:
#  
#     [<old-ip>]|[<start-ip>-<end-ip>],<new-ip>[,<mask>]
#
#   Examples:
#     dns_alias => ['1.2.3.4,5.6.7.8'],
#     dns_alias => ['1.2.3.0,5.6.7.0,255.255.255.0'],
#     dns_alias => ['192.168.0.10-192.168.0.40,10.0.0.0,255.255.255.0'],
#
# @param mx_host
#   Item syntax in this attribute:
#  
#     <mx name>[[,<hostname>],<preference>]
#
#   Return an MX record named <mx name> pointing to the given hostname (if given), or the host 
#   specified in the --mx-target switch or, if that switch is not given, the host on which dnsmasq
#   is running. The default is useful for directing mail from systems on a LAN to a central server. 
#   The preference value is optional, and defaults to 1 if not given. More than one MX record may be
#   given for a host. 
#
#   Example:
#     Return an MX record named "maildomain.com" with target servermachine.com and preference 50
#
#       mx_host => ['maildomain.com,servermachine.com,50'],
#
# @param mx_target
#   Specify the default target for the MX record returned by dnsmasq. See --mx-host. If --mx-target
#   is given, but not --mx-host, then dnsmasq returns a MX record containing the MX target for MX
#   queries on the hostname of the machine on which dnsmasq is running.
#
#   Example:
#     mx_target => 'servermachine.com',
#
# @param localmx
#   Return an MX record pointing to the host given by --mx-target (or the machine on which dnsmasq is
#   running) for each local machine. Local machines are those in /etc/hosts or with DHCP leases. 
#
# @param selfmx
#   Return an MX record pointing to itself for each local machine. Local machines are those in /etc/hosts
#   or with DHCP leases. 
#
# @param dns_srv_host
#   Return a SRV DNS record. See RFC2782 for details. These are useful if you want to serve ldap
#   requests for Active Directory and other windows-originated DNS requests.
#
#   Item syntax in this attribute:
#
#     <_service>.<_prot>.[<domain>],[<target>[,<port>[,<priority>[,<weight>]]]]
#
#   If the domain part if missing from the name (so that is just has the service and protocol sections)
#   then the domain given by the domain=config option is used. (Note that expand-hosts does not need to
#   be set for this to work.)
#   The default for the target domain is empty, and the default for port is one and the defaults for
#   weight and priority are zero. Be careful if transposing data from BIND zone files: the port, weight
#   and priority numbers are in a different order. 
#   More than one SRV record for a given service/domain is allowed, all that match are returned.
#
#   Examples:
#     A SRV record sending LDAP for the example.com domain to ldapserver.example.com port 389
#
#       dns_srv_host => ['_ldap._tcp.example.com,ldapserver.example.com,389'],
#
#     A SRV record sending LDAP for the example.com domain to ldapserver.example.com port 389 (using
#     domain=)
#
#       domain       => ['example.com'],
#       dns_srv_host => ['_ldap._tcp,ldapserver.example.com,389'],  
#
#     Two SRV records for LDAP, each with different priorities
#
#       dns_srv_host => ['_ldap._tcp.example.com,ldapserver.example.com,389,1', '_ldap._tcp.example.com,ldapserver.example.com,389,2'],
#
#     A SRV record indicating that there is no LDAP server for the domain example.com
#
#       dns_srv_host => ['_ldap._tcp.example.com'],
#
# @param ptr_record
#   Return a PTR DNS record. 
#
#   This attribute syntax:
#      <name>[,<target>]
#
#   The following line shows how to make dnsmasq serve an arbitrary PTR record. This is useful for
#   DNS-SD. (Note that the domain-name expansion done for SRV records _does_not occur for PTR records.)
#
#     ptr_record => '_http._tcp.dns-sd-services,"New Employee Page._http._tcp.dns-sd-services"',
#
# @param txt_record
#   Return a TXT DNS record. The value of TXT record is a set of strings, so any number may be included,
#   delimited by commas; use quotes to put commas into a string. Note that the maximum length of a
#   single string is 255 characters, longer strings are split into 255 character chunks. 
#   These are used for things like SPF and zeroconf. (Note that the domain-name expansion done for SRV
#   records _does_not occur for TXT records.)
#
#   Item syntax in this attribute:
#
#     <name>[[,<text>],<text>]
#
#   Example SPF.
#     txt_record => ['example.com,"v=spf1 a -all"'],
#
#   Example zeroconf
#     txt_record => ['_http._tcp.example.com,name=value,paper=A4'],
#
# @param dns_cname
#   Item syntax in this attribute:
#
#     <cname>,[<cname>,]<target>[,<TTL>]
#
#   Return a CNAME record which indicates that <cname> is really <target>. There is a significant
#   limitation on the target; it must be a DNS record which is known to dnsmasq and NOT a DNS record
#   which comes from an upstream server. The cname must be unique, but it is permissible to have more
#   than one cname pointing to the same target. Indeed it's possible to declare multiple cnames to a
#   target in a single line, like so: --cname=cname1,cname2,target
#
#   If the time-to-live is given, it overrides the default, which is zero or the value of --local-ttl.
#   The value is a positive integer and gives the time-to-live in seconds. 
#
#   Example:
#     Give host "bert" another name, "bertrand":
#
#       dns_cname => ['bertand,bert'],
#
# @param log_queries
#   Log the results of DNS queries handled by dnsmasq. Enable a full cache dump on receipt of SIGUSR1. 
#   If the argument "extra" is supplied, ie log_queries => 'extra', then the log has extra information
#   at the start of each line. This consists of a serial number which ties together the log lines
#   associated with an individual query, and the IP address of the requestor. 
#
#   The value for this attribute can be one of: true, false, 'extra'
#
# @param log_dhcp
#   Extra logging for DHCP: log all the options sent to DHCP clients and the tags used to determine them. 
#
# @param dhcp_name_match
#   Set the tag if the given name is supplied by a DHCP client. There may be a single trailing 
#   wildcard *, which has the usual meaning. Combined with dhcp-ignore or dhcp-ignore-names this
#   gives the ability to ignore certain clients by name, or disallow certain hostnames from being
#   claimed by a client. 
#
#   Item syntax in this attribute:
#
#     set:<tag>,<name>[*]
#
#   Example:
#     dhcp_name_match => ['set:wpad-ignore,wpad'],
#
# @param dhcp_ignore_names
#   When all the given tags appear in the tag set, ignore any hostname provided by the host. Note that,
#   unlike --dhcp-ignore, it is permissible to supply no tags, in which case DHCP-client supplied 
#   hostnames are always ignored, and DHCP hosts are added to the DNS using only dhcp-host configuration
#   in dnsmasq and the contents of /etc/hosts and /etc/ethers. 
#
#   This attribute syntax:
#      dhcp-ignore-names[=tag:<tag>[,tag:<tag>]]
#
#   Example:
#     dhcp_ignore_names => 'dhcp-ignore-names',
#     dhcp_ignore_names => 'dhcp-ignore-names=tag:wpad-ignore',
#
#
define dnsmasq::conf (
  Enum['present','file','absent']       $ensure                = 'present',
  Integer                               $priority              = 10,
  Optional[Stdlib::Absolutepath]        $source                = undef,

  # conf params
  Optional[String[1]]                   $port                  = undef,
  Optional[String[1]]                   $user                  = undef,
  Optional[String[1]]                   $group                 = undef,
  Boolean                               $domain_needed         = true,
  Boolean                               $bogus_priv            = true,
  Boolean                               $dnssec                = false,
  Boolean                               $dnssec_check_unsigned = false,
  Boolean                               $filterwin2k           = false,
  Optional[Stdlib::Absolutepath]        $resolv_file           = undef,
  Boolean                               $strict_order          = false,
  Boolean                               $no_resolv             = false,
  Boolean                               $no_poll               = false,
  Optional[Array[String[1]]]            $other_name_servers    = undef,
  Optional[Array[String[1]]]            $ptr_nameservers       = undef,
  Optional[Array[String[1]]]            $local_only_domains    = undef,
  Optional[Array[String[1]]]            $domains_force_to_ip   = undef,
  Optional[String[1]]                   $ipset                 = undef,
  Optional[Array[String[1]]]            $queries_via_eth       = undef,
  Optional[Array[String[1]]]            $queries_via_ip        = undef,
  Optional[Array[String[1]]]            $interfaces            = undef,
  Optional[Array[String[1]]]            $except_interfaces     = undef,
  Optional[Array[String[1]]]            $listen_addresses      = undef,
  Optional[Array[String[1]]]            $no_dhcp_interfaces    = undef,
  Boolean                               $bind_interfaces       = false,
  Boolean                               $no_hosts              = false,
  Optional[Array[Stdlib::Absolutepath]] $addn_hosts            = undef,
  Boolean                               $expand_hosts          = false,
  Optional[Array[String[1]]]            $domain                = undef,

  # dhcp config
  Optional[Array[String[1]]]            $dhcp_range            = undef,
  Boolean                               $dhcp_enable_ra        = false,
  Optional[Array[String[1]]]            $dhcp_host             = undef,
  Optional[Array[String[1]]]            $dhcp_ignore           = undef,
  Optional[Array[String[1]]]            $dhcp_vendorclass      = undef,
  Optional[Array[String[1]]]            $dhcp_userclass        = undef,
  Optional[Array[String[1]]]            $dhcp_mac              = undef,
  Boolean                               $read_ethers           = false,
  Optional[Array[String[1]]]            $dhcp_option           = undef,
  Optional[Array[String[1]]]            $dhcp_option_force     = undef,
  Optional[Array[String[1]]]            $dhcp_boot             = undef,
  Optional[Array[String[1]]]            $dhcp_match            = undef,

  #pxe
  Optional[String[1]]                   $pxe_prompt            = undef,
  Optional[Array[String[1]]]            $pxe_service           = undef,

  #tftp
  Optional[Array[String[1]]]            $enable_tftp           = undef,
  Optional[String[1]]                   $tftp_root             = undef,
  Boolean                               $tftp_no_fail          = false,
  Boolean                               $tftp_secure           = false,
  Boolean                               $tftp_no_blocksize     = true,

  Optional[Integer]                     $dhcp_lease_max        = undef,
  Optional[String[1]]                   $dhcp_leasefile        = undef,
  Boolean                               $dhcp_authoritative    = false,
  Boolean                               $dhcp_rapid_commit     = false,
  Optional[String[1]]                   $dhcp_script           = undef,
  Optional[Integer]                     $cache_size            = undef,
  Boolean                               $no_negcache           = false,
  Optional[Integer]                     $local_ttl             = undef,
  Optional[Array[String[1]]]            $bogus_nxdomain        = undef,
  Optional[Array[String[1]]]            $dns_alias             = undef,
  #mx
  Optional[Array[String[1]]]            $mx_host               = undef,
  Optional[String[1]]                   $mx_target             = undef,
  Boolean                               $localmx               = false,
  Boolean                               $selfmx                = false,
  Optional[Array[String[1]]]            $dns_srv_host          = undef,
  Optional[String[1]]                   $ptr_record            = undef,
  Optional[Array[String[1]]]            $txt_record            = undef,
  Optional[Array[String[1]]]            $dns_cname             = undef,
  Variant[Boolean, Enum['extra']]       $log_queries           = false,
  Boolean                               $log_dhcp              = false,
  Optional[Array[String[1]]]            $dhcp_name_match       = undef,
  Optional[String[1]]                   $dhcp_ignore_names     = undef,
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
