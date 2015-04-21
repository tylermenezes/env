require 'facter'
Facter.add(:fde) do
    setcode do
        Facter::Util::Resolution.exec('fdesetup isactive').strip == "true"
    end
end