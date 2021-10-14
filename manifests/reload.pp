# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include dnsmasq::reload
class dnsmasq::reload {
    exec { '/usr/bin/pkill -HUP dnsmasq':
    refreshonly => true,
  }
}
