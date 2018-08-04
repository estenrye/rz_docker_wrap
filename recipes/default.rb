#
# Cookbook:: rz_docker_wrap
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

directory '/opt/prometheus' do
  owner 'root'
  mode '0755'
  recursive true
  action :create
end

template '/opt/prometheus/promethus.yml' do
  source 'prometheus.yml.erb'
  owner 'root'
  mode '0644'
  variables(
    docker_ip: node['ipaddress']
  )
end

template '/opt/prometheus/promethus.stack.yml' do
  source 'prometheus.stack.yml.erb'
  owner 'root'
  mode '0644'
end

docker_installation_package 'default' do
  action :create
  package_options node['rz_docker_wrap']['package_options']
end

template '/etc/docker/daemon.json' do
  source 'daemon.json.erb'
  owner 'root'
  mode '0644'
  variables(
    metrics_addr: node['rz_docker_wrap']['metrics_addr'],
    experimental: node['rz_docker_wrap']['experimental']
  )
  action :create
  notifies :restart, 'service[docker]', :delayed
end

docker_swarm 'my-swarm' do
  action :init
end

service 'docker' do
  action :enable
end

docker_network 'proxy' do
  driver 'overlay'
end
