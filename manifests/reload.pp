# @summary Send a HUP signal to any dnsmasq processes in order to reload changes.
#
# Send a HUP signal to any dnsmasq processes in order to reload changes from
# `/etc/hosts` and `/etc/ethers` and any file given by `--dhcp-hostsfile`,
# `--dhcp-optsfile` or `--addn-hosts`.
#
# This is necessary because the SysV script on Ubuntu doesn't provide a
# reload command. It will not reload configuration changes. It will also
# send a HUP to *all* dnsmasq processes, of which there may be more than
# one, however that should be harmless.
#
# This clas is from mvasilenko-dnsmasq, thanks.
#
# @example
#   include dnsmasq::reload
class dnsmasq::reload {
    exec { '/usr/bin/pkill -HUP dnsmasq':
    refreshonly => true,
  }
}
