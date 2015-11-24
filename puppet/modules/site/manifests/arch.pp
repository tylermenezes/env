class site::arch () {

    # Libraries, Interpreters, Compilers, and Servers
    package {[
        "mono", "go", "memcached", "beanstalkd", "nginx", "nodejs", "npm",
        "php7", "php7-fpm", "php7-gd", "php7-mcrypt", "phpunit", "ruby",
        "jre7-openjdk-headless", "jre7-openjdk", "jdk7-openjdk",
        "jre8-openjdk-headless", "jre8-openjdk", "jdk8-openjdk"
    ]:
        ensure      => installed,
        provider    => pacman
    }->

    # UI
    package {[
        "xorg", "xbindkeys", "i3-wm", "i3status", "redshift", "networkmanager",
        "networkmanager-openvpn", "compton", "ttf-dejavu", "ttf-droid"
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
        "texinfo", "texmaker",  "thunar", "vinagre", "atom-editor-bin"
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
    }

    # Remove Apache
    package { "apache":
        ensure      => absent,
        provider    => pacman
    }
}
