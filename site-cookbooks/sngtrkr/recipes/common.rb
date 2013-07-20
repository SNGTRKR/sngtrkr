#
# Cookbook Name:: sngtrkr
# Recipe:: common
#

execute "disable password login" do
 command "sed -i 's/#.*PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config"
end

service "ssh" do
 action :restart
end

package "libtcmalloc-minimal4" # Ruby optimisation
package "openjdk-6-jre" # Solr needs me

directory "/home/vagrant/.ssh" do
	owner 'vagrant'
	recursive true
end

file "/home/vagrant/.profile" do
	content "# Generated .profile by Chef\n"
	user "vagrant"

	not_if { File.exists? "/home/vagrant/.profile" }
end

# Pass our environment variables through to the Vagrant box
ruby_block "insert secret environment variables" do
	block do
		secrets = data_bag_item("sngtrkr", "secrets")
		%w{SNGTRKR_7DIGITAL SNGTRKR_7DIGITAL_SECRET SNGTRKR_AWS_ID 
			SNGTRKR_AWS_KEY SNGTRKR_DB_PW SNGTRKR_DB_USER}.each do |var|
				raise "secrets[\"#{var}\"] not set in data_bag" unless secrets[var]
			file = Chef::Util::FileEdit.new("/home/vagrant/.profile") # Regretably needed or next line breaks
			file.search_file_replace_line(/#{var}=/, "export #{var}=\"#{secrets[var]}\"")
			file.write_file

			file = Chef::Util::FileEdit.new("/home/vagrant/.profile") # Regretably needed or next line breaks
			file.insert_line_if_no_match(/#{var}=/, "export #{var}=\"#{secrets[var]}\"")
			file.write_file

			# Set them in this environment too
			ENV[var] = secrets[var]
		end
	end
end

ruby_block "tweak ruby GC config" do
	block do
		ENV["RUBY_GC_MALLOC_LIMIT"] = "16000000"
		ENV["LD_PRELOAD"] = "/usr/lib/libtcmalloc_minimal.so.4"
		ENV["HOME"] = "/home/vagrant"

		file = Chef::Util::FileEdit.new("/home/vagrant/.profile") # Regretably needed or next line breaks
		file.search_file_replace_line(/RUBY_GC_MALLOC_LIMIT=/, "export RUBY_GC_MALLOC_LIMIT=#{ENV["RUBY_GC_MALLOC_LIMIT"]}")
		file.write_file

		file = Chef::Util::FileEdit.new("/home/vagrant/.profile") # Regretably needed or next line breaks
		file.insert_line_if_no_match(/RUBY_GC_MALLOC_LIMIT=/, "export RUBY_GC_MALLOC_LIMIT=#{ENV["RUBY_GC_MALLOC_LIMIT"]}")
		file.write_file

		file = Chef::Util::FileEdit.new("/home/vagrant/.profile") # Regretably needed or next line breaks
		file.search_file_replace_line(/LD_PRELOAD=/, "export LD_PRELOAD=#{ENV["LD_PRELOAD"]}")
		file.write_file

		file = Chef::Util::FileEdit.new("/home/vagrant/.profile") # Regretably needed or next line breaks
		file.insert_line_if_no_match(/LD_PRELOAD=/, "export LD_PRELOAD=#{ENV["LD_PRELOAD"]}")
		file.write_file
	end
end

include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"
include_recipe "rbenv::rbenv_vars"
rbenv_ruby "2.0.0-p195"
rbenv_gem "bundler" do
	ruby_version "2.0.0-p195"
end

directory "/home/vagrant/sngtrkr_rails_prod" do
	action :create
	owner "vagrant"
	group "vagrant"
end

directory "/home/vagrant/sngtrkr_rails_staging" do
	action :create
	owner "vagrant"
	group "vagrant"
end

# Copy our configuration files onto the system.
cookbook_file "/etc/nginx/sites-available/sngtrkr_rails_staging.conf" do
	source "nginx_rails_staging.conf"
	mode 0644
	owner "root"
	group "root"
end

cookbook_file "/etc/nginx/sites-available/sngtrkr_rails_prod.conf" do
	source "nginx_rails_prod.conf"
	mode 0644
	owner "root"
	group "root"
end

package "htop"

service "memcached" do
	action [:enable, :start]
end

service "nginx" do
	action [:enable, :start]
end

service "mysql" do
	action [:enable, :start]
end
