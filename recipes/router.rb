include_recipe "iptables::common"

settings = Chef::EncryptedDataBagItem.load('iptables', 'settings') ||
           node['iptables']

template '/etc/iptables/iptables' do
  source 'iptables_router.sh.erb'
  owner 'root'
  group 'root'
  mode 00744
  variables(
    wan_if: settings['wan_if'],
    lan_net: settings['lan_net'],
    forwards: settings['forwards'] || {},
    drop_countries: settings['drop_countries'] || [],
    filter_others: settings['filter_others'] || [],
    nat_others: settings['nat_others'] || []
  )
  notifies :restart, 'service[iptables]', :delayed
end

if settings['upnp']
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
end
