class profile::jenkins::master {
  include ::profile::jenkins

  class { '::jenkins':
    plugin_hash => {
      swarm                 => {},
      git                   => {},
      git-client            => {},
      scm-api               => {},
      build-pipeline-plugin => {},
      parameterized-trigger => {},
      jquery                => {},
    },
  }

}
