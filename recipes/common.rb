
directory '/etc/iptables/' do
  owner 'root'
  group 'root'
  mode 00755
end

iptables_template = ''
case node["platform_family"]
when "debian"
  iptables_template = 'iptables_deb.service'
when "rhel"
  iptables_template = 'iptables_rh.service'
end

cookbook_file '/etc/init.d/iptables' do
  source iptables_template
  owner 'root'
  group 'root'
  mode 00755
  notifies :restart, 'service[iptables]', :delayed
end

service 'iptables' do
  action :enable
end
