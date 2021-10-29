# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include dnsmasq::params
class dnsmasq::params {
    case $::osfamily {
    'Debian': {
      $package_name = 'dnsmasq'
      $service_name = 'dnsmasq'
      $config_file = '/etc/dnsmasq.conf'
      $config_dir = '/etc/dnsmasq.d/'
    }
    'RedHat': {
      $package_name = 'dnsmasq'
      $service_name = 'dnsmasq'
      $config_file = '/etc/dnsmasq.conf'
      $config_dir = '/etc/dnsmasq.d/'
    }
    default: {
      case $::operatingsystem {
        default: {
          fail("Unsupported platform: ${::osfamily}/${::operatingsystem}")
        }
      }
    }
  }
}
