class site::archui () {
    # UI                                                                                            
    package {[                                                                                      
        "xorg", "xorg-xinit", "xbindkeys", "i3-gaps-next-git", "i3blocks", "redshift", "compton",
        "ttf-dejavu", "ttf-droid", "pasystray", "paprefs", "rofi", "gtk-engine-unico", "tumbler",                 
        "gtk-engine-murrine", "gtk-engines", "unclutter-xfixes-git", "xautolock", "i3lock-color-git",
        "hsetroot", "kbdlight"
    ]:                                                                                              
        ensure      => installed,                                                                   
        provider    => pacman                                                                       
    }

    package {[
        "mopidy", "gimp", "spideroak-one", "steam", "terminator", "thunar", "vinagre",
        "firefox", "chromium-pepper-flash", "freshplayerplugin-git", "texmaker",
        "texlive-most"
    ]:
        ensure      => installed,
        provider    => pacman
    }

    cron { "unsplash-random":                                                                       
        command      => "XAUTHORITY=/home/$username/.Xauthority DISPLAY=:0 ~/Cloud/System/usr/bin/unsplash-random",
        user         => $username,                                                                  
        hour         => "*",                                                                        
        minute       => "1"                                                                         
    }

    # Bluetooth                                                                                     
    package { "blueberry":                                                                          
        ensure      => present,                                                                     
        provider    => pacman                                                                       
    } ->                                                                                            
    service {"bluetooth":                                                                           
        ensure      => running,                                                                     
        enable      => true                                                                         
    } ->
    package { "pulseaudio-bluetooth":
        ensure      => present,
        provider    => pacman
    }
}

