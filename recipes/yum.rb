y=yum_repository 'epel' do
  description 'Extra Packages for Enterprise Linux'
  mirrorlist 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=$basearch'
  gpgkey 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6'
  action :nothing
end
y.run_action(:create)

package "collectd" do
  action :install
end
p=package "dos2unix" do
  action :nothing
end
p.run_action(:install)

execute "/usr/bin/dos2unix /etc/init.d/collectd"

service "collectd" do
  action [ :enable, :start] 
end