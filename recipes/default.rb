#
# Cookbook:: rz_docker_wrap
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

template '/etc/docker/daemon.json' do
  source 'daemon.json.erb'
  owner 'root'
  mode '0644'
  variables(
    metrics_addr: '0.0.0.0:9323',
    experimental: true
  )
  action :create
  notifies :restart, 'service[docker]', :delayed
end

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
  package_options %q|--force-yes -o Dpkg::Options::='--force-confold' -o Dpkg::Options::='--force-all'| # if Ubuntu for example
end

execute 'Initialize Swarm' do
  command 'docker swarm init'
  guard_interpreter :bash
  only_if 'if [ "$(sudo docker info --format {{.Swarm.LocalNodeState}})" = "inactive" ]; then exit 0; else exit 1; fi'
end

service 'docker' do
  action :enable
end