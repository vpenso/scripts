name "account_database"
description "Account Database"
run_list( 
  'recipe[sys::apt]'
)
default_attributes(
  sys: {
    apt: {
      packages: [ 'mysql-server', 'percona-xtrabackup' ]
    }
  }
)

