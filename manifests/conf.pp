# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   dnsmasq::conf { 'namevar': }
define dnsmasq::conf (
  $ensure  = 'present',
  $prio    = 10,
  $source  = undef,
  $content = undef
) {
  include ::dnsmasq

}
