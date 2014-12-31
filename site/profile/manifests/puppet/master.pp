class profile::puppet::master {

  # Look, I know. But I'm a bit pressed for time.
  $puppet_conf_file = '/etc/puppetlabs/puppet/environments/production/manifests/site.pp'

  file_line { 'include_server_role':
    path => $puppet_conf_file,
    line => 'if $::server_role { include $::server_role }',
  }
}
