# Puppet-Homebrew

A Homebrew package provider for Mac OS X (brewery included).

## Installation

The modules second home is at [Puppet
Forge](https://forge.puppetlabs.com/bjoernalbers/homebrew), so this will do the trick:

```bash
puppet module install bjoernalbers-homebrew
```

## Usage

Use the Homebrew package provider like this:

```puppet
class hightower::packages {
  pkglist = ['postgresql', 'nginx', 'git', 'tmux']

  package { $pkglist:
    ensure   => installed,
    provider => brew,
  }
}
```

To install homebrew on a node (with a compiler already present!):

```puppet
class { 'homebrew':
  user => 'hightower',    # Defaults to 'root'
}
```

To install homebrew and a compiler (on Lion or later):

```puppet
class { 'homebrew':
  command_line_tools_package => 'command_line_tools_for_xcode_os_x_lion_aug_2012.dmg',
  command_line_tools_source  => 'http://puppet/command_line_tools_for_xcode_os_x_lion_aug_2012',
}
```

(Please read the fine manual ["Homebrew Installation"](https://github.com/mxcl/homebrew/wiki/Installation) for further epiphany).

Note that you have to download and provide the command line tools yourself, which requires an Apple ID! Sorry, dude.

## Acknowledgments

Thanks to the following contributors for making Open Source fun:

* [trobrock (Trae Robrock)](https://github.com/trobrock): Provided ENV-related fixes for Puppet 3

## License

Copyright (c) 2012 Björn Albers (Apache License, Version 2.0)
