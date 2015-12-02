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
        "jre7-openjdk-headless", "jre7-openjdk", "jdk7-openjdk",
        "jre8-openjdk-headless", "jre8-openjdk", "jdk8-openjdk",
        "mariadb", "acpi", "sysstat", "python-pyqt4", "python-pyqt5",
        "phonon-qt4-vlc", "kdebindings-python", "python-qscintilla",
        "phonon-qt5-vlc", "oxygen", "oxygen-icons"
    ]:
        ensure      => installed,
        provider    => pacman
    }->

    # UI
    package {[
        "xorg", "xbindkeys", "i3-wm", "i3blocks", "redshift", "networkmanager",
        "networkmanager-openvpn", "compton", "ttf-dejavu", "ttf-droid",
        "pasystray", "paprefs", "rofi", "gtk-engine-unico", "gtk-engine-murrine",
        "gtk-engines", "unclutter-xfixes-git"
    ]:
        ensure      => installed,
        provider    => pacman
    }->

    # Tools
    package { [
        "aspell", "bind-tools", "gnupg", "gparted", "gzip", "htop",
        "imagemagick", "iptables", "git", "nano", "ncurses", "opensc", "rsync",
        "screen", "scrot", "tmux", "unzip", "vim", "wget", "wpa_supplicant",
        "zsh", "pinentry", "cronie", "curl", "cups", "espeak", "grep", "ack",
        "at"
    ]:
        ensure      => installed,
        provider    => pacman
    }->

    # Programs
    package {[
        "chromium", "intellij-idea-ultimate-edition", "mopidy", "ncmpcpp",
        "spideroak-one", "steam", "terminator", "texlive-bin", "texlive-core",
        "texinfo", "texmaker",  "thunar", "vinagre", "atom-editor-bin", "firefox",
        "task", "android-studio", "autokey-py3"
    ]:
        ensure      => installed,
        provider    => pacman
    }->

    # Ruby Gems
    package {[
        "sass"
    ]:
        ensure      => present,
        provider    => gem
    } ->

    service {"NetworkManager":
        ensure      => running,
        enable      => true
    } ->
    service {"cronie":
        ensure      => running,
        enable      => true
    } ->
    service {"bluetooth":
        ensure      => running,
        enable      => true
    } ->
    service {"atd":
        ensure      => running,
        enable      => true
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
