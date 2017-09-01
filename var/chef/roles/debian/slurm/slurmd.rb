name 'slurmd'
description 'SLURM execution node'
run_list(
  'recipe[base]',
  'role[munged]'
)
default_attributes(
  package: ['slurmd'],
  systemd_unit: {
    'slurmd.service': { action: [:enable]  }
  }
)

