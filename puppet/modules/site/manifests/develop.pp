class site::develop () {

    # TODO: Install Sublime Text 2
    # TODO: Install IntelliJ IDEA and write config
    # TODO: Install VirtualBox
    # TODO: Install iTerm 2

    exec { "brew-ownership":
        command     => "chown root /usr/local/bin/brew",
        onlyif      => 'bash -c \'[ $(ls -ld /usr/local/bin/brew | awk "{print \$3}") != root ]\'',
        path        => ['/bin', '/usr/bin', '/usr/sbin']
    }


    package {
        ["mono", "ack", "composer", "dart", "dartium", "php56", "php56-mcrypt", "mysql", "node"]:
        ensure      => installed,
        provider    => brew
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
            path        => "/etc/resolver=dev",
            content     => "nameserver 127.0.0.1",
            ensure      => file
        }

    service { "homebrew.mxcl.dnsmasq":
        ensure      => running,
        enable      => true,
        require     => File["/usr/local/etc/dnsmasq.conf"]
    }
}