# include_recipe 'foreman::proxy_puppetca' if node['foreman-proxy']['puppetca']
include_recipe 'foreman::proxy_tftp' if node['foreman-proxy']['tftp']
include_recipe 'foreman::proxy_dhcp' if node['foreman-proxy']['dhcp'] and node['foreman-proxy']['dhcp_managed']

if node['foreman-proxy']['dns'] and node['foreman-proxy']['dns_managed']
  include_recipe 'foreman-proxy::proxy_dns'
  groups = node['foreman-proxy']['group_users'] << node['bind']['group']
else
  groups = node['foreman-proxy']['group_users']
end

group node['foreman-proxy']['group'] do
  members groups
end

user node['foreman-proxy']['user'] do
  shell '/bin/bash'
  group node['foreman-proxy']['group']
  supports manage_home: node['foreman-proxy']['manage_home']
  home node['foreman-proxy']['user_home']
end

foreman_proxy_settings_file 'bmc' do
  action node['foreman-proxy']['bmc'] ? :enable : :disable
  listen_on node['foreman-proxy']['bmc_listen_on']
end

foreman_proxy_settings_file 'dhcp' do
  action node['foreman-proxy']['dhcp'] ? :enable : :disable
  listen_on node['foreman-proxy']['dhcp_listen_on']
end

foreman_proxy_settings_file 'dns' do
  action node['foreman-proxy']['dns'] ? :enable : :disable
  listen_on node['foreman-proxy']['dns_listen_on']
end

foreman_proxy_settings_file 'puppet' do
  action node['foreman-proxy']['puppetrun'] ? :enable : :disable
  listen_on node['foreman-proxy']['puppetrun_listen_on']
end

foreman_proxy_settings_file 'puppetca' do
  action node['foreman-proxy']['puppetca'] ? :enable : :disable
  listen_on node['foreman-proxy']['puppetca_listen_on']
end

foreman_proxy_settings_file 'realm' do
  action node['foreman-proxy']['realm'] ? :enable : :disable
  listen_on node['foreman-proxy']['realm_listen_on']
end

foreman_proxy_settings_file 'tftp' do
  action node['foreman-proxy']['tftp'] ? :enable : :disable
  listen_on node['foreman-proxy']['tftp_listen_on']
end

foreman_proxy_settings_file 'templates' do
  action node['foreman-proxy']['templates'] ? :enable : :disable
  listen_on node['foreman-proxy']['templates_listen_on']
end

template ::File.join(node['foreman-proxy']['config_path'], 'settings.yml') do
  group node['foreman-proxy']['group']
  source 'settings_foreman-proxy.yml.erb'
end
