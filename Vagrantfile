# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "puppetlabs/ubuntu-12.04-64-puppet"
  config.vm.hostname = 'magento-community'
  config.vm.network 'private_network', :ip => '192.168.33.101'
 # config.vm.synced_folder './', '/srv/html'

  config.vm.provider 'vmware_fusion' do |v|
    v.vmx['memsize']  = 16384
    v.vmx['numvcpus'] = 2
  end

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = 'puppet/manifests'
    #puppet.manifest_file = 'site.pp'
    puppet.module_path = 'puppet/modules'
    #puppet.module_path = [ './puppet/modules', './puppet/custom-modules' ]
    #puppet.hiera_config_path = './puppet/config/hiera.yaml'
  end

end
