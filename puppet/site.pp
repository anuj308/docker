file { '/tmp/hell.txt' :
ensure => file,
content => 'hello from puppet',
}
