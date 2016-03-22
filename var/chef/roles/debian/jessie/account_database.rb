name "account_database"
description "Account Database"
run_list( 
  'recipe[sys::apt]',
  'recipe[sys::file]'
)
default_attributes(
  sys: {
    apt: {
      packages: [ 'mysql-server', 'percona-xtrabackup' ]
    },
    file: {
      '/etc/mysql/conf.d/bind.cnf' => {
        content: "[mysqld]\nbind-address = 0.0.0.0\n"
      }
    }
  }
)

