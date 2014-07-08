#
# Cookbook Name:: rsc_skeleton_cookbook
# Recipe:: default
#
# Copyright (C) 2014 RightScale Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

rightscale_marker :begin

service "collectd" do
  action :nothing 
end

directory "/opt/chef-utils" do
  owner "root"
  group "root"
  mode "0777"
  action :create
end

git "/opt/chef-utils" do
  repository "git://github.com/facebook/chef-utils.git"
  revision "master"
  action :sync
end
directory "/opt/chef-server/embedded/.chef" do
  owner "chef_server"
  group "chef_server"
  recursive true
  mode 0777
  action :create
end

bash "install and configure knife" do
  flags "-x"
  code <<-EOF
    curl -L https://www.opscode.com/chef/install.sh | bash
EOF
end

require 'securerandom'
template "/etc/chef-server/knife.rb" do
  source "knife.rb.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
              :admin => true,
              :client => 'admin',
              :host => node[:chef][:server_name],
              :password => SecureRandom.hex(15)
            )
  action :create
end

bash "create user" do
  flags "-x"
  code <<-EOF
    knife user create rightscale -c /etc/chef-server/knife.rb -d
  EOF
end

file "/etc/chef-server/rightscale.pem" do
  owner "chef_server"
  group "chef_server"
  mode 0777
  action :touch
end

directory "/opt/chef-server/embedded/.chef" do
  owner "chef_server"
  group "chef_server"
  mode 0777
  action :create
end

template "/opt/chef-server/embedded/.chef/knife.rb" do
  source "knife.rb.erb"
  owner "chef_server"
  group "chef_server"
  mode 0644
  variables(
              :admin => false,
              :client => 'rightscale',
              :host => node[:chef][:server_name],
              :password => SecureRandom.hex(15)
            )
  action :create
end

gem_package "json" do
  action :install
end

directory "/opt/chef-utils/bin" do
  owner "root"
  group "root"
  mode "0777"
  action :create
end

template "/opt/chef-utils/bin/chef-server-collectd.rb" do
  source 'chef-server-collectd.erb'
  owner "root"
  group "root"
  mode "0777"
  variables(:instance_uuid => node[:rightscale][:instance_uuid])
  action :create
end

cookbook_file "/etc/sudoers.d/chef-server" do
  source "sudoers-chef-server"
  owner "root"
  group "root"
  mode 0644
  action :create
end

rightscale_enable_collectd_plugin "exec"

template(::File.join(node[:rightscale][:collectd_plugin_dir], "chef-server.conf")) do
  backup false
  source "chef-server.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, resources(:service => "collectd"), :delayed
  variables(
    :collectd_lib => node[:rightscale][:collectd_lib],
    :instance_uuid => node[:rightscale][:instance_uuid]
  )
  action :create
end

rightscale_marker :end
