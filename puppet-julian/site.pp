case $osfamily {

    'RedHat': {
    	package { ["epel-release"]:
    		ensure => 'installed',
    	}
      Package['epel-release'] -> Package ['htop']

      firewall { '100 allow http and https access':
         port   => [80, 443],
         proto  => tcp,
         action => accept,
       }

    }
    'Debian': {
        exec { "apt-update":
            command => "/usr/bin/apt-get update",
        }
        Exec["apt-update"] -> Package <| |>
    }
}

class { 'timezone':
  timezone => hiera('timezone')
}

host { 'default_host':
  name => hiera('website_url'),
  ip   => '127.0.0.1',
}

package { ['mlocate','rsync','git','unzip','gzip','lynx','nmap','htop']:
  ensure => installed,
}

include cm_apache
include ::php
include cm_mysql

class { 'cm_n98magerun':
  require => Class['::php'],
}
