class site::arch () {
    # makepkg fix
    exec { "makepkg-fix":
        command     => 'LINE=$(expr $(grep -nr "Running %s as root is not allowed" `which makepkg` | cut -d : -f 1) - 2);ELINE=$(expr $LINE + 11);sed -i "$LINE,${ELINE}d" `which makepkg`',
        onlyif      => 'grep -q "Running %s as root is not allowed" `which makepkg`',
        provider    => shell,
        path        => '/usr/local/bin/:/bin/'
    }

    exec { "pacman-update":                                                                         
        command     => "pacman -Syy",                                                               
        provider    => shell,                                                                       
        path        => "/usr/local/bin/:/usr/bin/:/bin/",                                           
        refreshonly => true                                                                         
    }

    file { "/usr/bin/python":
        ensure      => link,
        target      => "/usr/bin/python3.5"
    }

    Package { require => Exec['makepkg-fix'] }

    # Libraries
    package {[
        "acpi", "sysstat", "python-pyqt4", "python-pyqt5",
        "phonon-qt4-gstreamer", "kdebindings-python",
        "phonon-qt5-gstreamer", "oxygen", "oxygen-icons", "python-crypto",
    ]:
        ensure      => installed,
        provider    => pacman
    }

    # Tools
    package { [
        "aspell", "bind-tools", "gnupg", "gparted", "gzip", "htop",
        "imagemagick", "iptables", "git", "nano", "ncurses", "opensc", "rsync",
        "screen", "scrot", "tmux", "unzip", "gvim", "vim-gruvbox-git",
        "wget", "wpa_supplicant", "macfanctld", "thermald", "tlp", "powertop",
        "zsh", "pinentry", "curl", "cups", "espeak", "grep", "ack", "archey3"
    ]:
        ensure      => installed,
        provider    => pacman
    }
    
    # Network
    package { "networkmanager":
        ensure      => present,
        provider    => pacman
    } ->
    package { "networkmanager-openvpn":
        ensure      => present,
        provider    => pacman
    } ->
    package { "network-manager-applet":
        ensure      => present,
        provider    => pacman
    } ->
    service { "NetworkManager":
        ensure      => running,
        enable      => true
    }

    # Cronjobs
    package { "cronie":
        ensure      => present,
        provider    => pacman
    } ->
    service {"cronie":
        ensure      => running,
        enable      => true
    }

    Cron { require  => Package["cronie"] }

    # At
    package { "at":
        ensure      => present,
        provider    => pacman
    } ->
    service {"atd":
        ensure      => running,
        enable      => true
    }

    # Fonts
    exec { "ensure-infinality":
        command     => 'printf "\n[infinality-bundle]\nServer = http://bohoomil.com/repo/x86_64\nSigLevel = Never\n[infinality-bundle-multilib]\nServer = http://bohoomil.com/repo/multilib/x86_64\nSigLevel = Never\n[infinality-bundle-fonts]\nServer = http://bohoomil.com/repo/fonts\nSigLevel = Never" >> /etc/pacman.conf',
        unless      => 'grep -q "infinality" /etc/pacman.conf',
        provider    => shell,
        path        => '/usr/local/bin/:/usr/bin/:/bin/',
        notify      => Exec['pacman-update']
    } ->
    package { [
        "infinality-bundle",
        "infinality-bundle-multilib",
        "jre8-openjdk-infinality",
        "jdk8-openjdk-infinality"
    ]:
        ensure      => installed,
        provider    => pacman
    }

    service { "systemd-timesyncd":
        ensure      => running,
        enable      => true
    }

    package { "task":
        ensure      => present,
        provider    => pacman
    } ->
    cron { "taskwarrior":
        command     => "task sync > /dev/null 2>&1",
        user        => $username,
        minute      => "*/5"
    }

    cron { "rm-downloads":
        command     => "rm -rf $home/Downloads/*",
        user        => $username,
        hour        => 9,
        minute      => 0
    }

    cron { "journalctl-cleanup":
        command     => "journalctl --vacuum-time=1h",
        user        => $username,
        minute      => 0
    }

    service {"iptables":
        ensure      => running,
        enable      => true
    }

    ## SyncFS
    # udev rules
    file { "/etc/udev/rules.d":
        source      => "$home/Cloud/System/etc/udev/rules.d",
        recurse     => true,
        require     => Exec["dirCloudExists"]
    } ~>
    exec {"refresh-udev":
        refreshonly => true,
        command     => "/usr/bin/udevadm control --reload-rules"
    }

    ## Fonts                                                                                        
    file { "/usr/share/fonts":                                                                      
        source      => "$home/Cloud/System/usr/share/fonts",                                        
        recurse     => true,                                                                        
        owner       => root,                                                                        
        mode        => "0644",                                                                      
        require     => Exec["dirCloudExists"]
    } ~>                                                                                            
    exec { "fc-cache":                                                                              
        command     => "/usr/bin/fc-cache",                                                         
        refreshonly => true                                                                         
    }

    file { "/etc/NetworkManager/dispatcher.d":
        source      => "$home/Cloud/System/etc/NetworkManager/dispatcher.d",
        recurse     => true,
        owner       => root,
        mode        => "0700",
        require     => [Service["NetworkManager"], Exec["dirCloudExists"]]
    }
}
