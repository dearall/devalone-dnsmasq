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
    - [Specify the local only domains](#specify-the-local-only-domains)
    - [Specify dhcp range](#specify-dhcp-range)
    - [Enable TFTP feature](#enable-tftp-feature)
    - [purge unmanaged files in $config_dir](#purge-unmanaged-files-in-config_dir)
  - [Reference](#reference)
  - [Limitations](#limitations)
  - [Development](#development)
  - [Release Notes](#release-notes)

## Description

The dnsmasq module manage dnsmasq package install, service, and config file details. The main class is dnsmasq, and it has a defined type dnsmasq::conf, you can use either of them to control the dnsmasq package.

## Setup

### What dnsmasq affects

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

If you have configued dnsmasq.conf file, this can be done by the dnsmasq::source parameter, as well as the dnsmasq::conf::source attribute. Notice, when set the `source` attribute with non undef value, the other config attributes are ignored. If you use detailed attributes to configure the dnsmasq service, set the `source` value to `undef`, or leave it unmanaged.

The default valute of `source` attribute is `undef`.

```puppet
class { 'dnsmasq':
  source => 'puppet:///...',
}
```

or

```puppet
dnsmasq::conf { 'local_dns':
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
dnsmasq::conf { 'local_dns':
  resolv_file => '/etc/resolv.conf.dnsmasq',
}
```

The `title` or `name` of the `dnsmasq::conf` definded type is part of the config file name, you can specify different name for multiple `dnsmasq::conf` instances, they group together to config the dnsmasq service. Do not contain white space in the `title` or `name` attribute.

### Specify the local only domains

Queries in `example.org` domain are answered from /etc/hosts or DHCP only.

```puppet
class { 'dnsmasq':
  resolv_file        => '/etc/resolv.conf.dnsmasq',
  local_only_domains => ['/example.org/'],
}
```

or

```puppet
dnsmasq::conf { 'local_dns':
  resolv_file        => '/etc/resolv.conf.dnsmasq',
  local_only_domains => ['/example.org/'],
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
dnsmasq::conf { 'local_dns':
  resolv_file     => '/etc/resolv.conf.dnsmasq',
  dhcp_range      => ['192.168.0.100,192.168.0.150,2d'],
  dhcp_enable_ra  => true,
}
```

### Enable TFTP feature

```puppet
class { 'dnsmasq':
  resolv_file     => '/etc/resolv.conf.dnsmasq',
  dhcp_range      => ['192.168.0.100,192.168.0.150,2d'],
  dhcp_enable_ra  => true,
  enable_tftp     => true,
}
```

or

```puppet
dnsmasq::conf { 'local_dns':
  resolv_file     => '/etc/resolv.conf.dnsmasq',
  dhcp_range      => ['192.168.0.100,192.168.0.150,2d'],
  dhcp_enable_ra  => true,
  enable_tftp     => true,
}
```

### purge unmanaged files in $config_dir

```puppet
    class { 'dnsmasq':
      purge_config_dir => true,
    }
```

## Reference

See [REFERENCE.md](https://github.com/dearall/devalone-dnsmasq/blob/master/REFERENCE.md)

## Limitations

This module has been tested on Open Source Puppet 7. It is tested on ubuntu 20.04.

For an extensive list of supported operating systems, see metadata.json

## Development

[github https://github.com/dearall/devalone-dnsmasq](https://github.com/dearall/devalone-dnsmasq)

## Release Notes

2021-11-03, version 1.0.0 released.
