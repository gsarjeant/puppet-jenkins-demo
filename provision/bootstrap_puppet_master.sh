#!/bin/bash

# Does a bit of post-install configuration of the puppet master:
#   1. Symlinks the role and profile modules into the modukepath
#   2. Does a puppet apply run to apply the role::puppet::master role
#      - This modifies site.pp to include the class defined by $::server_role
#        on all servers for which the $::server_role fact exists.

ENVIRONMENT_DIR='/etc/puppetlabs/puppet/environments'
MODULE_DIR="${ENVIRONMENT_DIR}/production/modules"

if [ ! -L "${MODULE_DIR}/role" ]
then
  ln -s '/vagrant/site/role' $MODULE_DIR
fi

if [ ! -L "${MODULE_DIR}/profile" ]
then
  ln -s '/vagrant/site/profile' $MODULE_DIR
fi

/opt/puppet/bin/puppet apply -e 'include role::puppet::master'
