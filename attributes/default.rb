default['rz_docker_wrap']['package_options'] = %q|--force-yes -o Dpkg::Options::='--force-confold' -o Dpkg::Options::='--force-all'| # if Ubuntu for example
default['rz_docker_wrap']['metrics_addr'] = '0.0.0.0:9323'
default['rz_docker_wrap']['experimental'] = true