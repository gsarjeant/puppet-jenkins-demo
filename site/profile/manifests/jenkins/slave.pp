class profile::jenkins::slave {
  include ::profile::jenkins

  # Set this node up as a slave.
  # We only need to point it to the jenkins master. The swarm plugin will
  # take care of the rest of the configuration.
  #
  # NOTE: I haven't enabled authentication on the demo master, so we don't
  #       need to specify a username and password. This is to keep the
  #       demo as simple as possible.

  class { '::jenkins::slave':
    masterurl => 'http://jenkins.puppetlabs.demo:8080',
  }

  # Install the gems that we will use for basic syntax and spec testing.
  #
  # NOTE: This is just a basic demo of jenkins functionality.
  #       So, I'm using the pe_gem provider to install these gems
  #       into the puppet vendored gem library, rather than installing
  #       and configuring a ruby build environment for jenkins.
  #
  #       Again, you wouldn't really want to take this approach in a
  #       production jenkins deployment, but I didn't want to clutter this
  #       tutorial with a bunch of environment management. That can be an
  #       exercise for after people are familiar with basic installation
  #       and job configuration.

  package { 'puppet-lint':
    ensure   => present,
    provider => 'pe_gem',
    before   => Class[ '::jenkins::slave' ],
  }

  package { 'rspec-puppet':
    ensure   => present,
    provider => 'pe_gem',
    before   => Class[ '::jenkins::slave' ],
  }

  package { 'puppetlabs_spec_helper':
    ensure   => present,
    provider => 'pe_gem',
    before   => Class[ '::jenkins::slave' ],
  }

  package { 'serverspec':
    ensure   => present,
    provider => 'pe_gem',
    before   => Class[ '::jenkins::slave' ],
  }
}
