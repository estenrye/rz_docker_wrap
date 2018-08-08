resource_name :docker_plugin

default_action :install

property :name, String, name_property: true, desired_state: false
property :alias, [String, nil], default: nil, desired_state: false
property :disable, [TrueClass, FalseClass], default: false, desired_state: false
property :disable_content_trust, [TrueClass, FalseClass], default: false, desired_state: false
property :grant_all_permissions, [TrueClass, FalseClass], default: false, desired_state: false
property :plugin_configuration, Hash, default: {}, desired_state: false, sensitve: true
property :force, [TrueClass, FalseClass], default: false, desired_state: false
property :timeout, Integer, default: 30, desired_state: false
property :remote, [String, nil], default: nil, desired_state: false
property :skip_remote_check, [TrueClass, FalseClass], default: false, desired_state: false

action :install do
  option_alias = new_resource.alias ? "--alias #{new_resource.alias}" : ''
  option_disable = new_resource.disable ? '--disable' : ''
  option_disable_content_trust = new_resource.disable_content_trust ? '--disable-content-trust' : ''
  option_grant_all_permissions = new_resource.grant_all_permissions ? '--grant-all-permissions' : ''
  options = "#{option_alias} #{option_disable} #{option_disable_content_trust} #{option_grant_all_permissions}".strip
  configuration_key_value_pairs = []
  new_resource.plugin_configuration.each do |key, value|
    configuration_key_value_pairs.push("'#{key}'='#{value}'")
  end
  configuration = configuration_key_value_pairs.join(' ')

  execute "Installing Docker Plugin: #{new_resource.name}" do
    command "docker plugin install #{options} #{new_resource.name} #{configuration}".strip
    guard_interpreter :bash
    only_if "if [ \"$(docker plugin ls --format '{{.Name}}' | grep '#{new_resource.name}')\" = '' ]; then 0 else 1 fi"
  end
end

action :ls do
  execute 'Listing Installed Docker Plugins' do
    command 'docker plugin ls --format "{{json .}}"'
  end
end

action :rm do
  execute "Uninstalling Docker Plugin: #{new_resource.name}" do
    command "docker plugin rm #{new_resource.force ? '--force' : ''} #{new_resource.name}"
    guard_interpreter :bash
    only_if "if [ \"$(docker plugin ls --format '{{.Name}}' | grep '#{new_resource.name}')\" = '' ]; then 1 else 0 fi"
  end
end

action :inspect do
  execute "Inspecting Docker Plugin: #{new_resource.name}" do
    command "docker plugin inspect --format '{{json .}}' #{new_resource.name}"
    guard_interpreter :bash
    only_if "if [ \"$(docker plugin ls --format '{{.Name}}' | grep '#{new_resource.name}')\" = '' ]; then 1 else 0 fi"
  end
end

action :disable do
  execute "Disabling Docker Plugin: #{new_resource.name}" do
    command "docker plugin disable #{new_resource.force ? '--force' : ''} #{new_resource.name}"
    guard_interpreter :bash
    only_if "if [ \"$(docker plugin ls --filter enabled=true --format '{{.Name}}' | grep '#{new_resource.name}')\" = '' ]; then 1 else 0 fi"
  end
end

action :enable do
  execute "Enabling Docker Plugin: #{new_resource.name}" do
    command "docker plugin enable --timeout #{new_resource.timeout} #{new_resource.name}"
    guard_interpreter :bash
    only_if "if [ \"$(docker plugin ls --filter enabled=false --format '{{.Name}}' | grep '#{new_resource.name}')\" = '' ]; then 1 else 0 fi"
  end
end

action :upgrade do
  option_disable_content_trust = new_resource.disable_content_trust ? '--disable-content-trust' : ''
  option_grant_all_permissions = new_resource.grant_all_permissions ? '--grant-all-permissions' : ''
  option_skip_remote_check = new_resource.skip_remote_check ? '--skip-remote-check' : ''
  options = "#{option_disable_content_trust} #{option_grant_all_permissions} #{option_skip_remote_check}".strip

  execute "Upgrading Docker Plugin: #{new_resource.name}" do
    command "docker plugin upgrade #{options} #{new_resource.name} #{new_resource.remote}".strip
    guard_interpreter :bash
    only_if "if [ \"$(docker plugin ls --format '{{.Name}}' | grep '#{new_resource.name}')\" = '' ]; then 1 else 0 fi"
  end
end
