# dnsmasq

Manage dnsmasq package install, service, and config file details.

## Table of Contents

- [dnsmasq](#dnsmasq)
  - [Table of Contents](#table-of-contents)
  - [Description](#description)
  - [Setup](#setup)
    - [What dnsmasq affects](#what-dnsmasq-affects)
    - [Beginning with dnsmasq](#beginning-with-dnsmasq)
  - [Usage](#usage)
    - [Using default parameters](#using-default-parameters)
    - [Using `source` attribute](#using-source-attribute)
    - [Specify the resolv file to use](#specify-the-resolv-file-to-use)
    - [Specify dhcp range](#specify-dhcp-range)
  - [Reference](#reference)
  - [Limitations](#limitations)
  - [Development](#development)
  - [Release Notes/Contributors/Etc. **Optional**](#release-notescontributorsetc-optional)

## Description

The dnsmasq module manage dnsmasq package install, service, and config file details.

## Setup

### What dnsmasq affects

If there's more that they should know about, though, this is the place to
mention:

- The dnsmasq module install/uninstall dnsmasq package, configure dnsmasq to run the dnsmasq.service.
- This module depends on the stdlib module that automatically installs.

### Beginning with dnsmasq

`include dnsmasq` is enough to get you up and running, this uses the **default** parameters to run dnsmasq module. To pass in parameters specifying which resolv file to use, and local only domain:

```puppet
class { 'dnsmasq':
  resolv_file        => '/etc/resolv.conf.dnsmasq',
  local_only_domains => ['/sansovo.org/'],
}
```

## Usage

All parameters for the **dnsmasq** module are contained within the main `dnsmasq` class, as well as in defined type `dnsmasq::conf`, so for any function of the module, set the options you want. See the common usages below for examples.

### Using default parameters

```puppet
include dnsmasq
```

### Using `source` attribute

If you have configued dnsmasq.conf file, this can be done by the dnsmasq::source parameter, as well as the dnsmasq::conf::source attribute.

```puppet
class { 'dnsmasq':
  source => 'puppet:///...',
}
```

or

```puppet
dnsmasq::conf { 'local dns':
  source => 'puppet:///...',
}
```

### Specify the resolv file to use

```puppet
class { 'dnsmasq':
  resolv_file => '/etc/resolv.conf.dnsmasq',
}
```

or

```puppet
dnsmasq::conf { 'local dns':
  resolv_file => '/etc/resolv.conf.dnsmasq',
}
```

### Specify dhcp range

```puppet
class { 'dnsmasq':
  resolv_file     => '/etc/resolv.conf.dnsmasq',
  dhcp_range      => ['192.168.0.100,192.168.0.150,2d'],
  dhcp_enable_ra  => true,
}
```

or

```puppet
dnsmasq::conf { 'local dns':
  resolv_file     => '/etc/resolv.conf.dnsmasq',
  dhcp_range      => ['192.168.0.100,192.168.0.150,2d'],
  dhcp_enable_ra  => true,
}
```

## Reference

See [REFERENCE.md](https://github.com/dearall/devalone-dnsmasq/blob/master/REFERENCE.md)

## Limitations

In the Limitations section, list any incompatibilities, known issues, or other
warnings.

## Development

In the Development section, tell other users the ground rules for contributing
to your project and how they should submit their work.

## Release Notes/Contributors/Etc. **Optional**

If you aren't using changelog, put your release notes here (though you should
consider using changelog). You can also add any additional sections you feel are
necessary or important to include here. Please use the `##` header.

[1]: https://puppet.com/docs/pdk/latest/pdk_generating_modules.html
[2]: https://puppet.com/docs/puppet/latest/puppet_strings.html
[3]: https://puppet.com/docs/puppet/latest/puppet_strings_style.html
