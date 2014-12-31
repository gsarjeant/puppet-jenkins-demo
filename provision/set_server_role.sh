#! /bin/bash

# Sets the server role by creating an external fact.
# Then triggers a puppet agent run in order to apply the role.

SERVER_ROLE=$1
EXTERNAL_FACTS_DIR='/etc/puppetlabs/facter/facts.d'

if [ "${SERVER_ROLE}x" == "x" ]
then
  echo "Server role is required."
  exit 1
fi

echo "Setting server_role to ${SERVER_ROLE}"
mkdir -p $EXTERNAL_FACTS_DIR
echo "server_role=${SERVER_ROLE}" > "${EXTERNAL_FACTS_DIR}/server_role.txt"

echo "Triggering puppet agent run"
/opt/puppet/bin/puppet agent -t
