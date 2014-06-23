name             'chef_server_stats_collectd'
maintainer       'RightScale Inc'
maintainer_email 'premium@rightscale.com'
license          'Apache 2.0'
description      'Installs/Configures rsc_skeleton_cookbook'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "rightscale"
depends "collectd"
depends "chef-server"
depends "chef-server-blueprint"

recipe "chef_server_stats_collectd::default"
