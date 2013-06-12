#
# Cookbook Name:: sngtrkr
# Recipe:: seed_database
#
# Reliant on common

execute "seed database" do
	command "su vagrant -l -c 'cd #{node[:sngtrkr][:app_path]} && 
		#{node[:sngtrkr][:shims_path]}rake db:fake_seed[true]'"
	only_if do
		node[:sngtrkr][:seed_db]
	end
end