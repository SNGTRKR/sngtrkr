#
# Cookbook Name:: sngtrkr
# Recipe:: common
#

package "libtcmalloc-minimal4"

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
		file = Chef::Util::FileEdit.new("/home/vagrant/.profile") # Regretably needed or next line breaks
		file.search_file_replace_line(/RUBY_GC_MALLOC_LIMIT=/, "export RUBY_GC_MALLOC_LIMIT=90000000")
		file.write_file

		file = Chef::Util::FileEdit.new("/home/vagrant/.profile") # Regretably needed or next line breaks
		file.insert_line_if_no_match(/RUBY_GC_MALLOC_LIMIT=/, "export RUBY_GC_MALLOC_LIMIT=90000000")
		file.write_file

		file = Chef::Util::FileEdit.new("/home/vagrant/.profile") # Regretably needed or next line breaks
		file.search_file_replace_line(/LD_PRELOAD=/, "export LD_PRELOAD=/usr/lib/libtcmalloc_minimal.so.4")
		file.write_file

		file = Chef::Util::FileEdit.new("/home/vagrant/.profile") # Regretably needed or next line breaks
		file.insert_line_if_no_match(/LD_PRELOAD=/, "export LD_PRELOAD=/usr/lib/libtcmalloc_minimal.so.4")
		file.write_file

		ENV["RUBY_GC_MALLOC_LIMIT"] = "90000000"
		ENV["LD_PRELOAD"] = "/usr/lib/libtcmalloc_minimal.so.4"
	end
end

# Required for git to download rubyenv to.
directory '/root' do
	mode 0755
end

include_recipe "ruby_stack"

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
