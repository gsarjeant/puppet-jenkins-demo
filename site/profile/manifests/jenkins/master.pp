class profile::jenkins::master {
  class { 'jenkins':
    plugin_hash => {
      swarm => {},
      git   => {},
    }
  }
}
