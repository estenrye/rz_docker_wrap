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
    metrics_addr: '127.0.0.1:9323',
    experimental: true
  )
  action :create
  notifies :restart, 'service[docker]', :delayed
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

