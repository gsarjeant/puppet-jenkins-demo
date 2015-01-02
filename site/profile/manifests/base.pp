class profile::base {
  include ::profile::base::firewall::pre
  include ::profile::base::firewall::post
  include ::firewall


  # Initialize a firewall that allows all traffic.
  # Yay local dev environments.
  resources { 'firewall':
    purge => true
  }

  Firewall {
    before  => Class['::profile::base::firewall::post'],
    require => Class['::profile::base::firewall::pre'],
  }
}
