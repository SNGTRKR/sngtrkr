#
# Cookbook Name:: sngtrkr
# Recipe:: production
#

user "vagrant" do
	home "/home/vagrant"
	shell "/bin/bash"
end

sudo "vagrant" do
	user "vagrant"
	nopasswd true
end

ruby_block "copy authorized_keys from root" do
	block do
		FileUtils.cp '/root/.ssh/authorized_keys', '/home/vagrant/.ssh'
		FileUtils.chmod 0600, '/home/vagrant/.ssh/authorized_keys'
		FileUtils.chmod 0700, '/home/vagrant/.ssh'
	end
end

# file "/home/vagrant/.ssh/authorized_keys" do

# end

include_recipe "sngtrkr::common"