class profile::base::firewall::post {
  firewall { '999 accept all':
    proto   => 'all',
    action  => 'accept',
    before  => undef,
  }
}
