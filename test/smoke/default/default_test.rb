# # encoding: utf-8

# Inspec test for recipe rz_docker_wrap::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe port(9323) do
  it { should be_listening }
end

describe port(2377) do
  it { should be_listening }
end

describe port (7946) do
  it { should be_listening }
end

describe port (4789) do
  it { should be_listening }
end

describe docker.info do
  its('Swarm.LocalNodeState') { should eq 'active' }
  its('ExperimentalBuild') { should eq true }
end
