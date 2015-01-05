define profile::jenkins::module_jobs {
  # This is primarily to make the template more clear.
  $test_module_name = $name

  # Create some jobs to do linting, rspec and serverspec tests.
  jenkins::job { "${name}_lint":
    config => template("profile/jenkins/lint.xml.erb"),
  }

  jenkins::job { "${name}_parse":
    config => template("profile/jenkins/parse.xml.erb"),
  }

  jenkins::job { "${name}_rspec":
    config => template("profile/jenkins/rspec.xml.erb"),
  }

  jenkins::job { "${name}_serverspec":
    config => template("profile/jenkins/serverspec.xml.erb"),
  }

  jenkins::job { "gitlab_${name}_lint":
    config => template("profile/jenkins/gitlab_lint.xml.erb"),
  }

  jenkins::job { "gitlab_${name}_parse":
    config => template("profile/jenkins/gitlab_parse.xml.erb"),
  }

  jenkins::job { "gitlab_${name}_rspec":
    config => template("profile/jenkins/gitlab_rspec.xml.erb"),
  }

  jenkins::job { "gitlab_${name}_serverspec":
    config => template("profile/jenkins/gitlab_serverspec.xml.erb"),
  }
}
