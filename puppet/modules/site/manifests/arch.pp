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
        "mariadb", "acpi", "sysstat"
    ]:
        ensure      => installed,
        provider    => pacman
    }->

    # UI
    package {[
        "xorg", "xbindkeys", "i3-wm", "i3blocks", "redshift", "networkmanager",
        "networkmanager-openvpn", "compton", "ttf-dejavu", "ttf-droid",
        "pasystray", "paprefs", "rofi"
    ]:
        ensure      => installed,
        provider    => pacman
    }->

    # Tools
    package { [
        "aspell", "bind-tools", "gnupg", "gparted", "gzip", "htop",
        "imagemagick", "iptables", "git", "nano", "ncurses", "opensc", "rsync",
        "screen", "scrot", "tmux", "unzip", "vim", "wget", "wpa_supplicant",
        "zsh", "pinentry", "cronie", "curl", "cups", "espeak", "grep", "ack"
    ]:
        ensure      => installed,
        provider    => pacman
    }->

    # Programs
    package {[
        "chromium", "intellij-idea-ultimate-edition", "mopidy", "ncmpcpp",
        "spideroak-one", "steam", "terminator", "texlive-bin", "texlive-core",
        "texinfo", "texmaker",  "thunar", "vinagre", "atom-editor-bin", "firefox"
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
    }

    service {"iptables":
        ensure      => running,
        enable      => true
    }

    # Remove some packages
    package {[
        "apache", "xorg-fonts-100dpi"
    ]:
        ensure      => absent,
        provider    => pacman
    }
}
