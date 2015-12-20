class site::arch () {
    # makepkg fix
    exec { "makepkg-fix":
        command     => 'LINE=$(expr $(grep -nr "Running %s as root is not allowed" `which makepkg` | cut -d : -f 1) - 2);ELINE=$(expr $LINE + 11);sed -i "$LINE,${ELINE}d" `which makepkg`',
        onlyif      => 'grep -q "Running %s as root is not allowed" `which makepkg`',
        provider    => shell,
        path        => '/usr/local/bin/:/bin/'
    }

    file { "/usr/bin/python":
        ensure      => link,
        target      => "/usr/bin/python3.5"
    }

    Package { require => Exec['makepkg-fix'] }

    # Libraries, Interpreters, Compilers, and Servers
    package {[
        "mono", "go", "memcached", "beanstalkd", "nginx", "nodejs", "npm",
        "php7", "php7-fpm", "php7-gd", "php7-mcrypt", "phpunit", "ruby",
        "jre8-openjdk-infinality", "jdk8-openjdk-infinality",
        "mariadb", "acpi", "sysstat", "python-pyqt4", "python-pyqt5",
        "phonon-qt4-vlc", "kdebindings-python", "python-qscintilla",
        "phonon-qt5-vlc", "oxygen", "oxygen-icons", "python-crypto"
    ]:
        ensure      => installed,
        provider    => pacman
    }

    # UI
    package {[
        "xorg", "xbindkeys", "i3-gaps-git", "i3blocks", "redshift", "compton", "ttf-dejavu",
        "ttf-droid", "pasystray", "paprefs", "rofi", "gtk-engine-unico", "tumbler",
        "gtk-engine-murrine", "gtk-engines", "unclutter-xfixes-git", "xautolock", "i3lock-color-git"
    ]:
        ensure      => installed,
        provider    => pacman
    }

    # Tools
    package { [
        "aspell", "bind-tools", "gnupg", "gparted", "gzip", "htop",
        "imagemagick", "iptables", "git", "nano", "ncurses", "opensc", "rsync",
        "screen", "scrot", "tmux", "unzip", "vim", "wget", "wpa_supplicant",
        "zsh", "pinentry", "curl", "cups", "espeak", "grep", "ack", "archey3"
    ]:
        ensure      => installed,
        provider    => pacman
    }

    # Programs
    package {[
        "mopidy", "ncmpcpp", "gimp",
        "spideroak-one", "steam", "terminator", "texlive-bin", "texlive-core",
        "texinfo", "texmaker",  "thunar", "vinagre", "atom-editor-bin", "firefox",
        "autokey-py3", "jrnl"
    ]:
        ensure      => installed,
        provider    => pacman
    }

    # Ruby Gems
    package {[
        "sass"
    ]:
        ensure      => present,
        provider    => gem
    }

    # IntelliJ
    package { "intellij-idea-ue-eap":
        ensure      => present,
        provider    => pacman
    } ->
    file { "/opt/intellij-idea-ue-eap/bin/idea.properties":
        source      => "$home/Cloud/System/opt/intellij-idea-ue-eap/bin/idea.properties"
    } ->
    file { "/usr/bin/intellij-idea":
        ensure      => link,
        target      => "/opt/intellij-idea-ue-eap/bin/idea.sh"
    }

    # Network
    package { "networkmanager":
        ensure      => present,
        provider    => pacman
    } ->
    package { "networkmanager-openvpn":
        ensure      => present,
        provider    => pacman
    }
    service { "NetworkManager":
        ensure      => running,
        enable      => true
    } ->
    file { "/etc/NetworkManager/dispatcher.d":
        source      => "$home/Cloud/System/etc/NetworkManager/dispatcher.d",
        recurse     => true,
        owner       => root,
        mode        => "0700"
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

    cron { "unsplash-daily":
        command      => "unsplash-daily",
        user         => $username,
        hour         => "*/3"
    }

    # Bluetooth
    package { "blueberry":
        ensure      => present,
        provider    => pacman
    } ->
    service {"bluetooth":
        ensure      => running,
        enable      => true
    }

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
        "infinality-bundle-multilib"
    ]:
        ensure      => installed,
        provider    => pacman
    }
    

    exec { "pacman-update":
        command     => "pacman -Syy",
        provider    => shell,
        path        => "/usr/local/bin/:/usr/bin/:/bin/",
        refreshonly => true
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

    # Remove some packages
    package {[
        "apache"
    ]:
        ensure      => absent,
        provider    => pacman
    }

    # udev rules
    file { "/etc/udev/rules.d":
        source      => "$home/Cloud/System/etc/udev/rules.d",
        recurse     => true
    } ~>
    exec {"refresh-udev":
        refreshonly => true,
        command     => "/usr/bin/udevadm control --reload-rules"
    }
}
