class site::basic () {
    file { "/etc/puppet/hiera.yaml":
        ensure      => file
    }

    # Programs

    exec { "brew-ownership":
        command     => "chown root /usr/local/bin/brew",
        onlyif      => 'bash -c \'[ $(ls -ld /usr/local/bin/brew | awk "{print \$3}") != root ]\'',
        path        => ['/bin', '/usr/bin', '/usr/sbin']
    }

    package {
        ["mono", "ack", "composer", "dart", "dartium", "php56", "php56-mcrypt", "mysql", "node"]:
        ensure      => installed,
        provider    => brew
    } ->
    pip::install { "Pygments":
        ensure      => installed
    }

    package { "zsh":
        ensure      => installed,
        provider    => brew
    } ->
        exec { "install-oh-my-zsh":
            command     => "curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh",
            creates     => "$home/.oh-my-zsh",
            cwd         => "$home",
            path        => ['/bin', '/usr/bin']
        }


    package { "dnsmasq":
        ensure      => installed,
        provider    => brew
    } ->
        file { "/Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist":
            path        => "/Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist",
            content     => file("site/homebrew.mxcl.dnsmasq.plist"),
            ensure      => file
        } ->
        file { "/usr/local/etc/dnsmasq.conf":
            path        => "/usr/local/etc/dnsmasq.conf",
            content     => file("site/dnsmasq.conf"),
            ensure      => file,
            notify      => Service["homebrew.mxcl.dnsmasq"]
        } ->
        file { "/etc/resolver/dev":
            path        => "/etc/resolver/dev",
            content     => "nameserver 127.0.0.1\nport 5353",
            ensure      => file
        } ->
        file { "/etc/resolver/srnd":
            path        => "/etc/resolver/srnd",
            content     => "nameserver 10.8.0.1",
            ensure      => file
        }

    service { "homebrew.mxcl.dnsmasq":
        ensure      => running,
        enable      => true,
        require     => File["/usr/local/etc/dnsmasq.conf"]
    }


    # Config

    defaults::write { "dont require pass at screensaver":
        ensure => present,
        domain => 'com.apple.screensaver',
        key    => 'askForPassword',
        value  => 0,
        user   => $username
    }

    defaults::write { "expand save panel 1":
        ensure => present,
        domain => 'NSGlobalDomain',
        key    => 'NSNavPanelExpandedStateForSaveMode',
        value  => 1,
        user   => $username
    }

    defaults::write { "expand save panel 2":
        ensure => present,
        domain => 'NSGlobalDomain',
        key    => 'NSNavPanelExpandedStateForSaveMode2',
        value  => 1,
        user   => $username
    }

    defaults::write { "expand print panel 1":
        ensure => present,
        domain => 'NSGlobalDomain',
        key    => 'PMPrintingExpandedStateForPrint',
        value  => 1,
        user   => $username
    }

    defaults::write { "expand print panel 2":
        ensure => present,
        domain => 'NSGlobalDomain',
        key    => 'PMPrintingExpandedStateForPrint2',
        value  => 1,
        user   => $username
    }

    defaults::write { "save to disk not icloud":
        ensure => present,
        domain => 'NSGlobalDomain',
        key    => 'NSDocumentSaveNewDocumentsToCloud',
        value  => 0,
        user   => $username
    }

    defaults::write { "disable app source warning":
        ensure => present,
        domain => 'com.apple.LaunchServices',
        key    => 'LSQuarantine',
        value  => 0,
        user   => $username
    }

    defaults::write { "disable app remember on restart":
        ensure => present,
        domain => 'com.apple.systempreferences',
        key    => 'NSQuitAlwaysKeepsWindows',
        value  => 0,
        user   => $username
    }

    defaults::write { "disable smart quotes":
        ensure => present,
        domain => 'NSGlobalDomain',
        key    => 'NSAutomaticQuoteSubstitutionEnabled',
        value  => 0,
        user   => $username
    }

    defaults::write { "disable smart dashes":
        ensure => present,
        domain => 'NSGlobalDomain',
        key    => 'NSAutomaticDashSubstitutionEnabled',
        value  => 0,
        user   => $username
    }

    defaults::write { "enable keyboard in modal controls":
        ensure => present,
        domain => 'NSGlobalDomain',
        key    => 'AppleKeyboardUIMode',
        value  => 3,
        user   => $username
    }

    defaults::write { "disable press and hold":
        ensure => present,
        domain => 'NSGlobalDomain',
        key    => 'ApplePressAndHoldEnabled',
        value  => 0,
        user   => $username
    }

    defaults::write { "speed up key repeat":
        ensure => present,
        domain => 'NSGlobalDomain',
        key    => 'KeyRepeat',
        value  => 1,
        user   => $username
    }

    defaults::write { "show filename extensions":
        ensure => present,
        domain => 'NSGlobalDomain',
        key    => 'AppleShowAllExtensions',
        value  => 1,
        user   => $username
    }

    defaults::write { "disable change extension warning":
        ensure => present,
        domain => 'com.apple.finder',
        key    => 'FXEnableExtensionChangeWarning',
        value  => 0,
        user   => $username
    }

    defaults::write { "show pathbar":
        ensure => present,
        domain => 'com.apple.finder',
        key    => 'ShowPathbar',
        value  => 1,
        user   => $username
    }

    defaults::write { "search current folder by default":
        ensure => present,
        domain => 'com.apple.finder',
        key    => 'FXDefaultSearchScope',
        value  => 'SCcf',
        user   => $username
    }

    defaults::write { "avoid creating ds_store files where possible":
        ensure => present,
        domain => 'com.apple.desktopservices',
        key    => 'DSDontWriteNetworkStores',
        value  => 1,
        user   => $username
    }

    defaults::write { "disable dashboard":
        ensure => present,
        domain => 'com.apple.dock',
        key    => 'mcx-disabled',
        value  => 1,
        user   => $username
    }

    defaults::write { "dont show dashboard as a space":
        ensure => present,
        domain => 'com.apple.dock',
        key    => 'dashboard-in-overlay',
        value  => 1,
        user   => $username
    }

    defaults::write { "autohide dock":
        ensure => present,
        domain => 'com.apple.dock',
        key    => 'autohide',
        value  => 1,
        user   => $username
    }

    defaults::write { "disable dock show animation":
        ensure => present,
        domain => 'com.apple.dock',
        key    => 'autohide-time-modifier',
        value  => 0,
        user   => $username
    }

    defaults::write { "change translucency of hidden apps in dock":
        ensure => present,
        domain => 'com.apple.dock',
        key    => 'showhidden',
        value  => 1,
        user   => $username
    }
}
