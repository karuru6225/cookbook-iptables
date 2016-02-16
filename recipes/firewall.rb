include_recipe "iptables::common"

settings = node['iptables'] || Chef::EncryptedDataBagItem.load('iptables', 'settings')
template '/etc/iptables/iptables' do
  source 'iptables_firewall.sh.erb'
  owner 'root'
  group 'root'
  mode 00744
  variables(
    lan_net: settings['lan_net'],
    accept_ports: settings['accept_ports'],
    drop_countries: settings['drop_countries']
  )
  notifies :restart, 'service[iptables]', :delayed
end
