class profile::jenkins::slave {
  include ::profile::jenkins

  class { '::jenkins::slave':
    masterurl => 'http://jenkins.puppetlabs.demo:8080',
  }

}
