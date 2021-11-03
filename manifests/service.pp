# @summary Manage the dnsmasq service
#
# This class use the dnsmasq params to control the dnsmasq service running.
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
