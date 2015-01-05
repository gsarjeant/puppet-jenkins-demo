#!/bin/bash

# Does a bit of post-install configuration of the puppet master:
#   1. Installs required puppet modules
#   2. Symlinks the role and profile modules into the modulepath
#   3. Does a puppet apply run to apply the role::puppet::master role
#      - This modifies site.pp to include the class defined by $::server_role
#        on all servers for which the $::server_role fact exists.

# Set variables
PUPPET_CMD='/opt/puppet/bin/puppet'
ENVIRONMENT_DIR='/etc/puppetlabs/puppet/environments'
MODULE_DIR="${ENVIRONMENT_DIR}/production/modules"

# Define required modules for this environment
MODULE_LIST=()
MODULE_LIST+=('rtyler/jenkins')
MODULE_LIST+=('puppetlabs/git')
MODULE_LIST+=('puppetlabs/pe_gem')
MODULE_LIST+=('puppetlabs/firewall')
MODULE_LIST+=('spuder/gitlab')

# Install required modules for this environment
echo "Installing necessary puppet modules..."
for MODULE in "${MODULE_LIST[@]}"
do
  echo "  ==> ${MODULE}"
  $PUPPET_CMD module install $MODULE
done

# Link the role and profile modules into the modulepath
echo "Linking role and profile directories into modulepath."
if [ ! -L "${MODULE_DIR}/role" ]
then
  ln -s '/vagrant/site/role' $MODULE_DIR
fi

if [ ! -L "${MODULE_DIR}/profile" ]
then
  ln -s '/vagrant/site/profile' $MODULE_DIR
fi

# Trigger a puppet run to apply the master role
echo "Applying puppet master role."
/opt/puppet/bin/puppet apply -e 'include role::puppet::master'
