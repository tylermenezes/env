class site::archdevel () {

    # Programming languages and servers
    package {[
        "mono", "go", "memcached", "beanstalkd", "nginx", "nodejs", "npm",
        "php7", "php7-fpm", "php7-gd", "php7-mcrypt", "phpunit", "ruby",
        "mariadb"
    ]:
        ensure      => installed,
        provider    => pacman
    }

    # IDEs
    package {[
        "texlive-bin", "texlive-core", "texinfo", "texmaker", "atom-editor-bin"
    ]:
        ensure      => installed,
        provider    => pacman
    }

    ## IDEs: IntelliJ
    package {"intellij-idea-ue-eap":
        ensure      => present,
        provider    => pacman
    } ~>
    file { "/opt/intellij-idea-ue-eap/bin/idea.properties":                                         
        source      => "$home/Cloud/System/opt/intellij-idea-ue-eap/bin/idea.properties"            
    } ~>                                                                                            
    file { "/usr/bin/intellij-idea":                                                                
        ensure      => link,                                                                        
        target      => "/opt/intellij-idea-ue-eap/bin/idea.sh"                                      
    }

    # Ruby Gems                                                                                     
    package {[                                                                                      
        "sass"                                                                                      
    ]:                                                                                              
        ensure      => present,                                                                     
        provider    => gem                                                                          
    } 
}
