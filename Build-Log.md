* Next steps.
  * create a docker plugin resource
  * add installation of the rexray plugin to recipe
  * consider moving prometheus into separate app cookbook?

* 2018-08-04
  * Created docker_swarm resource for initializing and leaving a swarm.
  * Added attributes to increase flexibility of the default recipe
  * added unit tests to test for metrics endpoint, swarm ports, swarm mode and experimental mode.
  * moved to standard bento image for ease of development.