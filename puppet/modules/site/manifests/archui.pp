class site::archui () {
    # UI                                                                                            
    package {[                                                                                      
        "xorg", "xbindkeys", "i3-gaps-git", "i3blocks", "redshift", "compton", "ttf-dejavu",        
        "ttf-droid", "pasystray", "paprefs", "rofi", "gtk-engine-unico", "tumbler",                 
        "gtk-engine-murrine", "gtk-engines", "unclutter-xfixes-git", "xautolock", "i3lock-color-git"
    ]:                                                                                              
        ensure      => installed,                                                                   
        provider    => pacman                                                                       
    }

    package {[
        "mopidy", "gimp", "spideroak-one", "steam", "terminator", "thunar", "vinagre",
        "firefox", "autokey-py3", "chromium-pepper-flash", "freshplayerplugin-git"
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
    }
}

