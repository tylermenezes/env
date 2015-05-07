class site::syncfs () {

    # Directories

    case $::operatingsystem {
        "Darwin": {
            $dir_dropbox_home        = "$home/Dropbox/Local FS"
            $dir_boxcryptor_home     = "/Volumes/Boxcryptor/Dropbox/Local FS"
        }
    }


    # Programs
    if ! $::dropbox {
        fail("Please configure Dropbox")
    }

    if ! $::boxcryptor {
        fail ("Please configure Boxcryptor")
    }

    defaults::write { "move iterm2 folder":
        ensure => present,
        domain => 'com.googlecode.iterm2',
        key    => 'PrefsCustomFolder',
        value  => '/Users/tylermenezes/Dropbox/Local FS/Developer/iTerm',
        user   => $username
    }


    # File and folder links

    file { "$home/Documents": 
        path        => "$home/Documents",
        target      => "$dir_boxcryptor_home/Documents/",
        ensure      => link
    }

    file { "$home/Github": 
        path        => "$home/Github",
        target      => "$dir_dropbox_home/Github/",
        ensure      => link
    }

    file { "$home/Pictures": 
        path        => "$home/Pictures",
        target      => "$dir_dropbox_home/Pictures/",
        ensure      => link
    }

    file { "$home/.ssh": 
        path        => "$home/.ssh",
        target      => "$dir_boxcryptor_home/.ssh",
        ensure      => link
    }

    file { "$home/.vimperator": 
        path        => "$home/.vimperator",
        target      => "$dir_boxcryptor_home/.vimperator/",
        ensure      => link
    }

    file { "$home/.vimperatorrc": 
        path        => "$home/.vimperatorrc",
        target      => "$dir_boxcryptor_home/.vimperatorrc",
        ensure      => link
    }

    file { "$home/.zshrc":
        path        => "$home/.zshrc",
        target      => "$dir_boxcryptor_home/.zshrc",
        ensure      => link
    }
}
