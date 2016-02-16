include_recipe "iptables::common"

settings = node['iptables'] || Chef::EncryptedDataBagItem.load('iptables', 'settings')
template '/etc/iptables/iptables' do
  source 'iptables_router.sh.erb'
  owner 'root'
  group 'root'
  mode 00744
  variables(
    lan_net: settings['lan_net'],
    forwards: settings['forwards'],
    drop_countries: settings['drop_countries']
  )
  notifies :restart, 'service[iptables]', :delayed
end

package 'linux-igd' do
  action :install
end

template '/etc/default/linux-igd' do
  source 'linux-igd.erb'
  owner 'root'
  group 'root'
  mode 00644
  notifies :restart, 'service[linux-igd]', :delayed
end

service 'linux-igd' do
  action :enable
end
