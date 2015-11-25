class site::apparmor () {
    # AppArmor
    package { "abs":
        ensure      => installed,
        provider    => pacman
    }
    exec { "apparmor-kernel":
        command     => 'echo "Please recompile kernel for AppArmor using ~/Cloud/Utils/BuildAppArmorKernel.sh";/bin/false',
        require     => Package["abs"],
        unless      => 'pacman -Qi linux-apparmor > /dev/null 2>&1',
        path        => '/usr/local/bin/:/bin/',
        provider    => shell
    }
    package { "apparmor-libapparmor":
        ensure      => installed,
        provider    => pacman,
        require     => Exec["apparmor-kernel"]
    } ->
    package { [
        "apparmor-parser", "apparmor-utils", "apparmor-profiles",
        "apparmor-pam", "apparmor-vim"
    ]:
        ensure      => installed,
        provider    => pacman,
        require     => Exec["apparmor-kernel"]
    } ->
    package { "apparmor":
        ensure      => installed,
        provider    => pacman,
        require     => Exec["apparmor-kernel"]
    }

    file { "/etc/apparmor.d":
        source      => "$home/Cloud/System/etc/apparmor.d",
        recurse     => true,
        require     => Package["apparmor"]
    } ~>
    service {"apparmor":
        ensure      => running,
        enable      => true,
    }
}
