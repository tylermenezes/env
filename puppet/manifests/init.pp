if $username == undef {
    $username = $::identity[user]
}
$home = "/home/$username"

if $::operatingsystem == 'Darwin' {
    $home = "/Users/$username"
    include site::mac
} else {
    include site::arch
    include site::archui
    include site::archdevel
    include site::apparmor
}

include site::syncfs
