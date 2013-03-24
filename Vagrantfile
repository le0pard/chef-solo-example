# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'json'

Vagrant.configure("2") do |config|
  config.vm.box = "precise64"
  config.vm.network :forwarded_port, guest: 80, host: 8085

  VAGRANT_JSON = JSON.parse(Pathname(__FILE__).dirname.join('nodes', 'vagrant.json').read)

  config.vm.provision :chef_solo do |chef|
     chef.cookbooks_path = ["site-cookbooks", "cookbooks"]
     chef.roles_path = "roles"
     chef.data_bags_path = "data_bags"
     chef.provisioning_path = "/tmp/vagrant-chef"

     # You may also specify custom JSON attributes:
     chef.json = VAGRANT_JSON
     VAGRANT_JSON['run_list'].each do |recipe|
      chef.add_recipe(recipe)
     end if VAGRANT_JSON['run_list']

     Dir["#{Pathname(__FILE__).dirname.join('roles')}/*.json"].each do |role|
       chef.add_role(role)
     end
  end

end
