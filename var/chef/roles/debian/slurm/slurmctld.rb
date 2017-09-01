name 'slurmctld'
description 'slurmctld'
run_list(
  'recipe[base]',
  'role[munged]'
)
default_attributes(
)

