class profile::jenkins {
  include ::git


  # On RHEL-6x style systems,
  # we need to set up the repoforge repository to get a non-ancient
  # version of git (required by the jenkins git plugin)
  if ( $::osfamily == 'RedHat' and $::operatingsystemmajrelease == '6' ) {

    yumrepo { 'rpmforge':
      name       => 'rpmforge',
      descr      => 'RHEL $releasever - RPMforge.net - dag',
      ensure     => 'present',
      baseurl    => 'http://apt.sw.be/redhat/el6/en/$basearch/rpmforge',
      mirrorlist => 'http://mirrorlist.repoforge.org/el6/mirrors-rpmforge',
      enabled    => '1',
      protect    => '0',
      gpgkey     => 'http://apt.sw.be/RPM-GPG-KEY.dag.txt',
      gpgcheck   => '1',
    }
  
    yumrepo { 'rpmforge-extras':
      name       => 'rpmforge-extras',
      descr      => 'RHEL $releasever - RPMforge.net - extras',
      ensure     => 'present',
      baseurl    => 'http://apt.sw.be/redhat/el6/en/$basearch/extras',
      mirrorlist => 'http://mirrorlist.repoforge.org/el6/mirrors-rpmforge-extras',
      enabled    => '1',
      protect    => '0',
      gpgkey     => 'http://apt.sw.be/RPM-GPG-KEY.dag.txt',
      gpgcheck   => '1',
      require    => Yumrepo['rpmforge'],
      before     => Class['git'],
    }

  }

}
