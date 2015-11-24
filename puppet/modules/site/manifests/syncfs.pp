class site::syncfs () {

    # Directories
    $dirCloud = "$home/Cloud"

    # Remove the Desktop folder (Linux) or make it redirect to the Downloads
    # folder (Mac):
    if $operatingsystem == 'Darwin' {
        file { "$home/Desktop":
            ensure  => link,
            target  => "$home/Downloads"
        }
    } else {
        file { "$home/Desktop":
            ensure  => absent
        }
    }

    exec {"dirCloudExists":
        command     => '/bin/true',
        onlyif      => "/usr/bin/test -e $dirCloud",
    }

    # Create symlinks for every file in the ~/Cloud/ folder:
    exec { "link-files-$home":
        command     => "find . -maxdepth 1 $(find .. -maxdepth 1 -printf '-not -name %f ') -not -name '.' -not -name 'System' -printf '%f\n' | xargs -I {} sh -c 'ln -s \"$dirCloud/\$1\" \"$home/\$1\"' - {}",
        onlyif      => "find . -maxdepth 1 $(find .. -maxdepth 1 -printf '-not -name %f ') -not -name '.' -not -name 'System' -printf '%f\n' | egrep '.*'",
        path        => '/usr/local/bin/:/bin/',
        cwd         => $dirCloud,
        provider    => shell,
        require     => Exec["dirCloudExists"]
    }
}
