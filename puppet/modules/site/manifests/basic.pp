class site::basic () {
    file { "/etc/puppet/hiera.yaml":
        ensure      => file
    }
    
    # TODO: Install Dashlane
}