# = Class: n98magerun
#
# Class installs n98-magerun
#
class cm_n98magerun {

  exec { 'download_n98magerun':
    command     => 'curl -L -o /usr/local/bin/n98-magerun.phar \
 https://raw.githubusercontent.com/netz98/n98-magerun/master/n98-magerun.phar',
    creates     => '/usr/local/bin/n98-magerun.phar',
    cwd         => '/usr/local/bin/',
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  file { 'n98magerun_phar_execute_permissions':
    ensure  => 'present',
    path    => '/usr/local/bin/n98-magerun.phar',
    mode    => 755,
    require => Exec['download_n98magerun'],
  }

}
