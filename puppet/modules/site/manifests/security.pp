class site::security () {
    # TODO: Install GPGTools
    # TODO: Create certificate shim
    # TODO: Install gpg-agent config
    # TODO: Install Airmail plugin
    # TODO: Install Viscosity
    # TODO: Install Firefox FoxyProxy Addon and configure

    if $::operatingsystem == "Darwin" {
        if ! $::fde {
            fail('Please enable full-disk encryption in System Preferences and try again')
        }
    }
}