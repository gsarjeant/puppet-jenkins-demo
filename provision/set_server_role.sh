#! /bin/bash

# Permanently sets the server role by creating an external fact.

EXTERNAL_FACTS_DIR='/etc/puppetlabs/facter/facts.d'
WAIT_FOR_PUPPET_RUN='N'

### Input validation

while getopts "w" OPT
do
  case $OPT in
    w) 
      WAIT_FOR_PUPPET_RUN='Y'
      ;;
    *)
      echo "Invalid argument $OPT"
      exit 1
      ;;
  esac
done

SERVER_ROLE=${@:OPTIND:1}

if [ "${SERVER_ROLE}x" == "x" ]
then
  echo "Server role is required."
  exit 1
fi

### Function definition

function test_for_puppet_run(){
  PUPPET_RUNNING=$(ps -ef | grep 'applying' | grep -v grep | wc -l)
}

function wait_for_puppet_run(){
  while [ $PUPPET_RUNNING == "1" ]
  do
    echo "Puppet run is in progress."
    echo "Sleeping for 30 seconds..."
    sleep 30
    test_for_puppet_run
  done

  echo "Puppet run is complete."
}

### Script execution

echo "Setting server_role to ${SERVER_ROLE}"
mkdir -p $EXTERNAL_FACTS_DIR
echo "server_role=${SERVER_ROLE}" > "${EXTERNAL_FACTS_DIR}/server_role.txt"

# If directed to wait for a puppet run, then:
#   - See whether a run is in progress
#   - If it is, wait for it to finish
#   - If it isn't, wait 30 seconds for a run to start, then wait for it to finish
#   - If a run hasn't started within 30 seconds, kick one off

echo "Wait for puppet run: ${WAIT_FOR_PUPPET_RUN}"

if [ $WAIT_FOR_PUPPET_RUN == 'Y' ]
then
  echo "Waiting for puppet run to complete before proceeding."
  echo "This will ensure that the ${SERVER_ROLE} role is applied."

  test_for_puppet_run

  if [ $PUPPET_RUNNING == "1" ]
  then
    wait_for_puppet_run
  else
    echo "Puppet run not yet initiated. Waiting for 30 seconds..."
    sleep 30
    test_for_puppet_run

    if [ $PUPPET_RUNNING == "1" ]
    then
      wait_for_puppet_run
    else
      echo "Puppet run did not initiate within 30 seconds."
      echo "Forcing puppet run."
      /opt/puppet/bin/puppet agent -t
    fi
  fi
fi

exit 0
