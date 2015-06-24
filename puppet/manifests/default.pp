Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }


exec { 'apt-update':
  command => 'apt-get update',
  timeout => 60,
  tries   => 3
}

# Setup timezone
class { 'timezone':
  timezone  =>  'Europe/London',

}

class { 'apache':
  mpm_module  =>  'prefork',             # must enable this before install php
  require     =>  Exec['apt-update'],    # require 'apt-update' before installing
  user        =>  'vagrant',
}

# Enable Apache extra modules
apache::mod { 'rewrite': }

# Setup a mix of SSL and non-SSL vhosts at the same domain
apache::vhost { 'johnlobb.vm non-ssl':
  servername          =>  'johnlobb.vm',
  directoryindex      =>  'index.php',
  docroot             =>  '/vagrant/htdocs',
  override            =>  ['All'],
  port                =>  '80',
  docroot_owner       =>  'vagrant',
  docroot_group       =>  'vagrant',
}

# The SSL vhost at the same domain
apache::vhost { 'johnlobb.vm ssl':
  servername      =>  'johnlobb.vm',
  directoryindex  =>  'index.php',
  docroot         =>  '/vagrant/htdocs',
  override        =>  ['All'],
  port            =>  '443',
  ssl             =>  true,
}

# Installs and configures apache mod_php from default
class {'::apache::mod::php':
  require =>  Exec['apt-update'],
}


# Enable php modules
class {'php': }

php::module { "mysql" : }
php::module { "curl" : }

# first
php::module {
  "xdebug" :
} -> # then
file_line { 'php5_xdebug':
   path => '/etc/php5/apache2/conf.d/xdebug.ini',
   line => "xdebug.remote_enable=1\nxdebug.remove_connect_back = on\nxdebug.ide_key='Vagrant'",
 ensure =>  present,
}

# Installs and configures mysql
class { '::mysql::server':
  #root_password =>  'foobar',
}

# Create database
mysql::db{ 'john_lobb_test':
  user=>'root',
  password=>'',
  host=>'localhost',
  grant=>['ALL'],
  sql=>'/vagrant/assets/johnlobb_live05Jun2015.sql',
  import_timeout=>900, #default is 300 seconds
}
