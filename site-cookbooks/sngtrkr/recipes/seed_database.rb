#
# Cookbook Name:: sngtrkr
# Recipe:: seed_database
#
# Reliant on common

execute "seed database" do
	command "rake db:fake_seed"
	cwd "/home/vagrant/sngtrkr_rails_dev"
end