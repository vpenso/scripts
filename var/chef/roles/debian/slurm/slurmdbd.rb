name 'slurmdbd'
description 'slurmdbd'
run_list(
  'recipe[base]',
  'role[munged]'
)
default_attributes(
  package: ['slurmdbd'],
  systemd_unit: {
    'slurmdbd.service': { action: [ :enable ] }
  }
)

