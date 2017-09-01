name 'slurmd'
description 'SLURM execution node'
run_list(
  'recipe[base]',
  'role[munged]'
)
default_attributes(
  package: ['slurmd'],
  systemd_unit: {
    'etc-slurm.mount': {
      content: '
        [Unit]
        Description=Mount SLURM configuration
        Wants=network-online.target
        After=network-online.target
        [Mount]
        What=lxrm01.devops.test:/etc/slurm
        Where=/etc/slurm-llnl
        Type=nfs
        Options=ro,nosuid
        TimeoutSec=10s
        [Install]
        WantedBy=multi-user.target
      ',
      action: [:create, :enable, :start]
    },
    'slurmd.service': { action: [:enable]  }
  }
)

