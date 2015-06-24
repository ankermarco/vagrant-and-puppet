# = Class: cm_mysql
#
# Class installs mysql
#
class cm_mysql {

  class { '::mysql::server':
    #root_password =>  'foobar',
  }

  # Create database
  mysql::db{ 'john_lobb_test':
   user           => 'root',
   password       => '',
   host           => 'localhost',
   grant          => ['ALL'],
   sql            => '/vagrant/assets/johnlobb_live05Jun2015.sql',
   import_timeout => 900,
  }

}
