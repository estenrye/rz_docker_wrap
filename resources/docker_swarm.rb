resource_name :docker_swarm

property :force, [TrueClass, FalseClass], default: false, desired_state: false
default_action :init

action :init do
	execute 'Initialize Swarm' do
		command 'docker swarm init'
		guard_interpreter :bash
		only_if 'if [ "$(docker info --format {{.Swarm.LocalNodeState}})" = "inactive" ]; then exit 0; else exit 1; fi'
  end
end

action :leave do
  command = "docker swarm leave #{new_resource.force ? '-force' : ''}"

  execute 'Leaving Swarm' do
    command command
    guard_interpreter :bash
    only_if 'if [ "$(docker info --format {{.Swarm.LocalNodeState}})" = "active" ]; then exit 0; else exit 1; fi'
  end
end