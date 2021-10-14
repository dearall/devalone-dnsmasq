# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include dnsmasq::service
class dnsmasq::service {
  if $dnsmasq::service_control {
    service { $dnsmasq::params::service_name:
      ensure     => 'running',
      enable     => true,
      hasrestart => true,
      hasstatus  => true,
    }
  }
}
