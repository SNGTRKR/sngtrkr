#
# Cookbook Name:: rbenv
# Recipe:: install
#
require 'yaml'

# Pass our environment variables through to the Vagrant box
ruby_block "insert_environment_variables" do
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
		end
	end
end

# Required for git to download rubyenv to.
directory '/root' do
	mode 0755
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
	owner "root"
	group "root"
end

# Bundle install