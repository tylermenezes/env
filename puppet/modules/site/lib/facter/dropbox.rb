require 'facter'
Facter.add(:dropbox) do
    setcode do
        Facter::Util::Resolution.exec('bash -c \'[ -d "/Users/' + Facter.value(:username) + '/Dropbox" ] && echo "yes" || echo "no"\'') == "yes"
    end
end
Facter.add(:boxcryptor) do
    setcode do
        Facter::Util::Resolution.exec('bash -c \'[ -d "/Volumes/Boxcryptor/Dropbox" ] && echo "yes" || echo "no"\'') == "yes"
    end
end