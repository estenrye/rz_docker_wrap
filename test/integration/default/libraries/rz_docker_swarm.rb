class RzDockerSwarm < Inspec.resource(1)
  name 'rz_docker_swarm'

  desc 'Check on Swarm configurations.'

  example '
    describe rz_inspec_docker_swarm do
      its(\'LocalNodeState\') { should be \'active\' }
    end
  '

  def initialize()
      @params = json(content: command('docker info --format "{{json .Swarm}}'))
  end

  def method_missing(name)
    @params[name.to_s]
  end
end
