# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.berkshelf.enabled = true

  config.vm.define :dev do |dev|
    dev.vm.box = "quantal"
    dev.vm.box_url = "http://cloud-images.ubuntu.com/raring/current/raring-server-cloudimg-vagrant-amd64-disk1.box"
    dev.vm.network :forwarded_port, guest: 80, host: 8000
    dev.vm.network :forwarded_port, guest: 3000, host: 3000
    dev.vm.network :forwarded_port, guest: 8080, host: 8080

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    # dev.vm.network :private_network, ip: "192.168.33.10"

    # Create a public network, which generally matched to bridged network.
    # Bridged networks make the machine appear as another physical device on
    # your network.
    # dev.vm.network :public_network

    # Share an additional folder to the guest VM. The first argument is
    # the path on the host to the actual folder. The second argument is
    # the path on the guest to mount the folder. And the optional third
    # argument is a set of non-required options.
    dev.vm.synced_folder "../sngtrkr", "/home/vagrant/sngtrkr_rails_dev"

    dev.vm.provider :virtualbox do |vb|
      # Use VBoxManage to customize the VM. For example to change memory:
      vb.customize ["modifyvm", :id, "--memory", "2048"]
    end

    dev.vm.provision :chef_solo do |chef|
      chef.add_recipe "build-essential"
      chef.add_recipe "ohai"
      chef.add_recipe "apt"
      chef.add_recipe "memcached"
      chef.add_recipe "nginx"
      chef.add_recipe "mysql::server"
      chef.add_recipe "redisio::install"
      chef.add_recipe "redisio::enable"
      chef.add_recipe "database"

      chef.add_recipe "sngtrkr::common"
      chef.add_recipe "sngtrkr::development"

      chef.json = { 
        'ruby_stack' => {
          "rubies" => ['2.0.0-p195'],
          "global" => '2.0.0-p195',
          "users" =>  ["vagrant"],
          "vendor_gems" => true
        },
        'mysql' => {
          "server_root_password" => ENV['SNGTRKR_DB_PW'],
          "server_repl_password" => ENV['SNGTRKR_DB_PW'],
          "server_debian_password" => ENV['SNGTRKR_DB_PW'],
          "tunable" => {
            "key_buffer_size" => "16M",
            "innodb_buffer_pool_size" => "64M",
            "innodb_additional_mem_pool_size" => "2M"
          }
        },
        'sngtrkr' => {
          'seed_db' => false # set me to true for FIRST TIME provision only
        }
      }

      chef.data_bags_path = "data_bags"
    end
  end

end
