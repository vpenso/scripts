name 'munged'
description 'MUNGE authentication service'
run_list( 
  'recipe[base]'
)
default_attributes(
  package: ['munge'],
  file: {
     ##
     # Shared secret
     #
     '/etc/munge/munge.key' => {
        only_if: [ 'test -d /etc/munge' ],
        content: '030340d651edb16efabf24a8c080d4b7',
        notifies: [ :restart, 'systemd_unit[munge.service]' ]
     }
  },
  systemd_unit: {
    'munge.service': { action: [:enable,:start] }
  }
)
