name 'slurmd'
description 'SLURM execution node'
run_list(
  'recipe[base]',
  'role[munged]'
)
default_attributes(
  package: [
    'nfs-common',
    'slurm-client',
    'slurmd'
  ],
  mount: {
    '/etc/slurm-llnl': {
      device: 'lxrm01.devops.test:/etc/slurm-llnl',
      fstype: 'nfs',
      options: 'ro,nosuid',
      notifies: [:start,'systemd_unit[slurmd.service]']
    }
  },
  systemd_unit: {
    'slurmd.service': { action: [:enable]  }
  }
)

