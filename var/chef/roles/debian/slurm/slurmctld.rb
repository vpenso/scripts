name 'slurmctld'
description 'slurmctld'
run_list(
  'recipe[base]',
  'role[slurm_nfs]',
  'role[munged]',
  'role[slurmdbd]'
)
default_attributes(
  package: ['slurmctld'],
  systemd_unit: {
    'slurmctld.service': { action: [:enable] }
  }
)

