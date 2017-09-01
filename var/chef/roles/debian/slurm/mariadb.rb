name 'mariadb'
description 'Install and configure mariadb'
run_list( 
  'recipe[base]'
)
default_attributes(
  package: [ 'mariadb-server' ],
  file: {
    '/etc/mysql/mariadb.conf.d/50-server.cnf': {
      content: '
        [mysqld]
	user                    = mysql
	pid-file                = /var/run/mysqld/mysqld.pid
	socket                  = /var/run/mysqld/mysqld.sock
	port                    = 3306
	basedir                 = /usr
	datadir                 = /var/lib/mysql
	tmpdir                  = /tmp
	lc-messages-dir         = /usr/share/mysql
	skip-external-locking
	bind-address            = 127.0.0.1
	key_buffer_size         = 16M
	max_allowed_packet      = 16M
	thread_stack            = 192K
	thread_cache_size       = 8
	myisam_recover_options  = BACKUP
	query_cache_limit       = 1M
	query_cache_size        = 16M
	log_error               = /var/log/mysql/error.log
	expire_logs_days        = 10
	max_binlog_size         = 100M
	character-set-server    = utf8mb4
	collation-server        = utf8mb4_general_ci
      ',
      notifies: [ :restart, 'systemd_unit[mariadb.service]' ]
    }
  },
  systemd_unit: {
    'mariadb.service': { action: [:enable,:start] }
  }
)

