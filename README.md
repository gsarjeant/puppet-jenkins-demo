Vagrant Jenkins Demo Environment
================================

This is a vagrant environment that defines a basic Jenkins master/slave setup.
The Jenkins VMs are managed by a puppet master that is also defined in this
environment.

I had hoped that by creating a project on github that combines [puppet](http://http://puppetlabs.com/),
[jenkins](http://jenkins-ci.org/) and [vagrant](https://www.vagrantup.com/), I would unlock some sort
of DevOps merit badge, but alas, it doesn't seem to work that way. I'll have to settle for trying to
make this useful.

This vagrant environment requires Adrien Thebo's [oscar](https://github.com/adrienthebo/oscar) vagrant plugin.

Introduction
------------

There is increasing interest in testing and continuous integration of Puppet modules in the Puppet community. By incorporating rspec and serverspec tests in a puppet module, one can enable a fairly comprehensive test suite in jenkins, to ensure that Puppet module code is of high quality before deploying it to a live environment. It can be difficult to get started, however, because the topics can be overwhelming to people who are new to testing and CI.

This project defines a vagrant environment that creates a very simple Puppet module testing framework in jenkins. It can be used in conjunction with a Puppet module that defines rspec and serverspec tests to perform the tests, but it will create the jenkins environment without including a test module if all you'd like to do is investigate jenkins. It is intended to demostrate the following functionality:

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

The module test jobs assume that a module repository exists in the test\_modules directory of this project. This directory is .gitignored, with the exception of the README, so you can safely clone a module without worrying about accidentally committing it to this project. If you would like to run the module tests, then you will need to do the following:

* clone a puppet module into the test\_modules directory
* set the value of profile::jenkins::master::test\_module\_name to the name of your module (i.e. the name of the directory that contains your module code)

By default, the tests are configured to use the [basic\_module\_tests](https://github.com/gsarjeant/basic_module_tests) module. So, the simplest way to run the tests is to clone this module into the test\_ modules directory:

    cd test_modules
    git clone git@github.com:gsarjeant/basic_module_tests.git


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

Caveats
-------

In the interest of keeping the focus of this environment on jenkins job configuration and puppet module testing, I have done a few things that aren't exactly aligned with Puppet or jenkins best practices. While I think this is fine for creating a local environment to familiarize yourself with the concepts, it is not intended to be a reference implementation of jenkins or puppet. 
