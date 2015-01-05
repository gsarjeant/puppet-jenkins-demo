class profile::jenkins::master (
  $test_module_name = 'basic_module_tests',
  $gitlab_username  = 'demouser'
){
  include ::profile::jenkins

  class { '::jenkins':
    configure_firewall => true,
    plugin_hash        => {
      swarm                 => {},
      greenballs            => {},
      git                   => {},
      git-client            => {},
      scm-api               => {},
      build-pipeline-plugin => {},
      parameterized-trigger => {},
      jquery                => {},
      ruby-runtime          => {},
      gitlab-hook           => {},
    },
  }

  profile::jenkins::module_jobs { "${test_module_name}":
    require => Class[ '::jenkins' ],
  }
}
