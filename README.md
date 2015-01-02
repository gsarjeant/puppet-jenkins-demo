Vagrant Jenkins Demo Environment
================================

This is a vagrant environment that defines a basic Jenkins master/slave setup,
with four Jenkins jobs that demonstrate basic Puppet module tests.
The Jenkins VMs are managed by a puppet master that is also defined in this
environment.

I had hoped that by creating a project on github that combines [puppet](http://puppetlabs.com/),
[jenkins](http://jenkins-ci.org/) and [vagrant](https://www.vagrantup.com/), I would unlock some sort
of DevOps merit badge, but alas, it doesn't seem to work that way. I'll have to settle for trying to
make this useful.

This vagrant environment requires Adrien Thebo's [oscar](https://github.com/adrienthebo/oscar) vagrant plugin.

Contents
--------

* [Quickstart](#quickstart)
* [Introduction](#introduction)
* [Prerequisites](#prerequisites)
* [Usage](#usage)
* [Networking and Name Resolution](#networking-and-name-resolution)
* [Accessing the Jenkins Dashboard](#accessing-the-jenkins-dashboard)
* [Caveats](#caveats)

Quickstart
----------

    git clone git@github.com:gsarjeant/puppet-jenkins-demo.git
    cd puppet-jenkins-demo/test_modules
    git clone git@github.com:gsarjeant/basic_module_tests.git
    vagrant up

Introduction
------------

There is increasing interest in testing and continuous integration of Puppet modules in the Puppet community. By incorporating rspec and serverspec tests in a puppet module, one can enable a fairly comprehensive test suite in Jenkins, to ensure that Puppet module code is of high quality before deploying it to a live environment. It can be difficult to get started, however, because the topics can be overwhelming to people who are new to testing and CI.

This project defines a vagrant environment that creates a very simple Puppet module testing framework in Jenkins. It can be used in conjunction with a Puppet module that defines rspec and serverspec tests to perform the tests, but it will create the Jenkins environment without including a test module if all you'd like to do is investigate jenkins. It is intended to demostrate the following functionality:

* Basic management of jenkins with Puppet, including:
  * Jenkins master installation
  * Jenkins master configuration
    * Plugin installation
    * Job creation
      * monitoring module repositories
      * triggering downstream jobs
  * Jenkins slave installation
* Execution of Puppet tests from jenkins
  * puppet-lint
  * puppet parser validate
  * rspec-puppet
  * serverspec (this is a bit nonsensical, and should really be beaker, but I'm going for simplicity here)

Prerequisites
-------------

* vagrant
  * oscar plugin
* virtualbox
* internet access

This environment requires Adrien Thebo's [oscar](https://github.com/adrienthebo/oscar) vagrant plugin. You can install oscar as follows:

    vagrant plugin install oscar

Usage
-----

Basic usage is as simple as invoking "vagrant up" from this project's root directory after cloning it.

    git clone git@github.com:gsarjeant/puppet-jenkins-demo.git
    cd puppet-jenkins-demo
    vagrant up

This will create three VMs:

* **master.puppetlabs.demo**: The puppet master. Manages the jenkins master and slave
* **jenkins.puppetlabs.demo**: The jenkins master. Jobs are defined here, but run on the slave.
* **slave1.puppetlabs.demo**: The jenkins slave. Jobs run here.

This will result in a functioning jenkins master/slave environment, with four jobs configured to run puppet tests on a demo module. However, in order for the jobs to be able to run, you must provide a puppet module to run the tests on. The test jobs assume that this module repository exists in the test\_modules directory of this project. This directory is .gitignored, with the exception of the README, so you can safely clone a module into this directory without worrying about accidentally committing it to this project. If you would like to run the module tests, then you will need to do the following:

* Clone a puppet module into the **test\_modules** directory.
* Set the value of **profile::jenkins::master::test\_module\_name** to the name of your module (i.e. the name of the directory that contains your module code).

By default, the tests are configured to use the [basic\_module\_tests](https://github.com/gsarjeant/basic_module_tests) module. So, the simplest way to run the tests is to clone this module into the test\_ modules directory:

    cd test_modules
    git clone git@github.com:gsarjeant/basic_module_tests.git

If you would like to use a different module, then do the following:

1. Clone your module intp the test\_modules directory.
1. Pass the name of your module to profile::jenkins::master from [role::jenkins::master](https://github.com/gsarjeant/puppet-jenkins-demo/blob/master/site/role/manifests/jenkins/master.pp#L3)
1. Run ```puppet agent -t``` on jenkins.puppetlabs.demo

Networking and Name Resolution
------------------------------

This environment uses the [vagrant-auto\_network](https://github.com/adrienthebo/vagrant-auto_network) plugin to assign IP addresses to VMs automatically, and the [vagrant-hosts](https://github.com/adrienthebo/vagrant-hosts) plugin to manage internal DNS (/etc/hosts) entries on the vagrant VMs. Both of these plugins are installed with oscar.

If you are not running any other VMs that are managed by the vagrant-auto\_network plugin and do not modify the configuration of this environment, then the VMs will be assigned the following IP addresses:

* **master.puppetlabs.demo**: 10.20.1.2
* **jenkins.puppetlabs.demo**: 10.20.1.3
* **slave1.puppetlabs.demo**: 10.20.1.4

You can confirm these IPs from the command line as follows:

    $ vagrant hosts list
    10.20.1.3 jenkins.puppetlabs.demo jenkins
    10.20.1.2 master.puppetlabs.demo master
    10.20.1.4 slave1.puppetlabs.demo slave1

Once you have determined the IPs, you may want to enter them into your **host machine's**  /etc/hosts file for convenience.

Accessing the Jenkins Dshboard 
------------------------------

The Jenkins master is configured to listen on port 8080. This environment does not configure a web server in front of Jenkins. So, assuming that you have correctly set its IP in /etc/hosts on your host system, you can access the Jenkins dashboard at the following URL:

http://jenkins.puppetlabs.demo:8080


Caveats
-------

In the interest of keeping the focus of this environment on jenkins job configuration and puppet module testing, I have done a few things that aren't exactly aligned with Puppet or Jenkins best practices. While I think this is fine for creating a local environment to familiarize yourself with the concepts, it is not intended to be a reference implementation of Jenkins or Puppet. Particularly noteworthy are:

* **No authentication on the jenkins master:** This should of course be locked down in production.
* **Classification by fact:** The puppet master is configured to include the class defined by the **$::server\_role** fact on the agent. While this is a handy way to spin up an auto-configuring vagrant environment, it is also a handy way to allow anyone with administrative access to a production machine to change its classification without requiring access to the Puppet master.
* **Parameterized profiles:** This environment makes use of the [Roles and Profiles](http://garylarizza.com/blog/2014/02/17/puppet-workflow-part-2/) pattern for puppet modules. The **profile::jenkins::master** class includes a parameter that allows you to define the module that should be tested by the jenkins jobs. Without going into too much detail, this isn't best practice. It is generally preferable to use hiera to pass parameters directly to the underlying component modules, rather than passing parameter values to profiles. In the name of simplifying this demo, though, I just put the parameter on the profile.
* **Templates in profiles:** Ditto above, but for templates. It's generally preferable for templates to be in component modules and for profiles to include those component modules. Putting them in the profile made this demo more straightforward, but I generally wouldn't do it in production.

