name             'chef_server_stats_collectd'
maintainer       'RightScale Inc'
maintainer_email 'premium@rightscale.com'
license          'Apache 2.0'
description      'Installs/Configures chef_server_stats_collectd'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "rightscale"
depends "yum"
depends "collectd"
depends "chef-server"
depends "ruby"
depends "chef-server-blueprint"
depends "rubygems_install"

recipe "chef_server_stats_collectd::default", "installs chef-server-stats and collectd plugin"