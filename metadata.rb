name             'chef_server_stats_collectd'
maintainer       'RightScale Inc'
maintainer_email 'premium@rightscale.com'
license          'Apache 2.0'
description      'Installs/Configures chef_server_stats_collectd'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "rightscale"
depends "chef-server"
depends "chef-server-blueprint"

recipe "chef_server_stats_collectd::default", "installs chef-server-stats and collectd plugin"

attribute "chef/server_name",
  :display_name => "Chef Server Name",
  :description => "Chef Server Name, LOCAL_HOSTNAME",
  :required => "required"
