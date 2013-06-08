#
# Cookbook Name:: rbenv
# Recipe:: install
#

# Required for git to download rubyenv to.
directory '/root' do
  mode 0755
end
