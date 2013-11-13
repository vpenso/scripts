# chef-remote

Upload cookbooks and roles to a remote node and execute _chef-solo_ with the script `chef-remote`. The script will recognize an `ssh_config` file in the working directory automatically.

    » ssh-exec -s 'apt-get install chef'
    […]
    » chef-remote cookbook sys
    Cookbook 'sys' added
    » chef-remote role ~/chef/cookbooks/sys/tests/roles/sys_apt_test.rb
    Role [sys_apt_test.rb] added.
    […]
    » chef-remote --run-list "role[sys_apt_test]" solo
    […]

