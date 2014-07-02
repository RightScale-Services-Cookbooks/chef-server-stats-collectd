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

execute "curl -L https://www.opscode.com/chef/install.sh | sudo bash"

execute 'echo -e "\n" | knife configure --defaults -y'

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

rightscale_enable_collectd_plugin "exec"

template(::File.join(node[:rightscale][:collectd_plugin_dir], "chef-server.conf")) do
  backup false
  source "chef-server.conf.erb"
  notifies :restart, resources(:service => "collectd")
  variables(
    :collectd_lib => node[:rightscale][:collectd_lib],
    :instance_uuid => node[:rightscale][:instance_uuid]
  )
end
