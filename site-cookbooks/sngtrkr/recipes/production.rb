#
# Cookbook Name:: sngtrkr
# Recipe:: production
#

group "vagrant" do
	gid 1234
end

user "vagrant" do
	home "/home/vagrant"
	shell "/bin/bash"
	gid 1234
	supports manage_home: true
end

sudo "vagrant" do
	user "vagrant"
	nopasswd true
end

directory "/home/vagrant/.ssh" do
	owner "vagrant"
	group "vagrant"
end

ruby_block "copy authorized_keys from root" do
	block do
		FileUtils.cp '/root/.ssh/authorized_keys', '/home/vagrant/.ssh'
		FileUtils.chmod 0600, '/home/vagrant/.ssh/authorized_keys'
	end
end

# file "/home/vagrant/.ssh/authorized_keys" do

# end