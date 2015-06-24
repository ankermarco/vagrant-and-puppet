# = Class: cm_apache
#
# Class installs apache
#
class cm_apache {

  file { "/vagrant/htdocs":
    ensure => "directory",
  }

  class { 'apache':
    mpm_module  =>  'prefork',             # must enable this before install php
    require     =>  Exec['apt-update'],    # require 'apt-update' before installing
    user        => 'vagrant',
  }

  # Enable Apache extra modules
  apache::mod { 'rewrite': }

  # Setup a mix of SSL and non-SSL vhosts at the same domain
  apache::vhost { 'johnlobb.vm':
    servername          =>  'johnlobb.vm',
    directoryindex      =>  'index.php',
    docroot             =>  '/vagrant/htdocs',
    override            =>  ['All'],
    port                =>  '80',
    docroot_owner       =>  'vagrant',
    docroot_group       =>  'vagrant',
  }

  # The SSL vhost at the same domain
  apache::vhost { 'johnlobb.vm.ssl':
    servername      =>  'johnlobb.vm',
    directoryindex  =>  'index.php',
    docroot         =>  '/vagrant/htdocs',
    override        =>  ['All'],
    port            =>  '443',
    ssl             =>  true,
  }

  # Installs and configures apache mod_php from default
  class { '::apache::mod::php':
    require => Exec['apt-update'],
  }

}
