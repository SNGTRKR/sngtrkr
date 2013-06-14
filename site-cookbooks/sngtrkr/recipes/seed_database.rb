#
# Cookbook Name:: sngtrkr
# Recipe:: seed_database
#
# Reliant on common

execute "su vagrant -l -c 'cd #{node[:sngtrkr][:app_path]} && 
		#{node[:sngtrkr][:shims_path]}rake db:fake_seed[true,#{node[:sngtrkr][:seed_images]}]'" do
	only_if do
		node[:sngtrkr][:seed_db]
	end
end