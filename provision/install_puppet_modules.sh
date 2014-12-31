#! /bin/bash

# just a really basic script to install required modules on the puppet master
PUPPET_CMD='/opt/puppet/bin/puppet'

echo "Installing module rtyler/jenkins"
$PUPPET_CMD module install rtyler/jenkins

exit 0
