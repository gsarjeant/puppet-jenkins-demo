class profile::gitlab (
  $gitlab_branch = '7.6.2'
){
  $gitlab_download_link = "https://downloads-packages.s3.amazonaws.com/centos-6.6/gitlab-${gitlab_branch}_omnibus.5.3.0.ci-1.el6.x86_64.rpm"

  class { '::gitlab':
    gitlab_branch          => $gitlab_branch,
    external_url           => 'http://gitlab.puppetlabs.demo',
    puppet_manage_packages => false,
    gitlab_download_link   => $gitlab_download_link,
  }
}
