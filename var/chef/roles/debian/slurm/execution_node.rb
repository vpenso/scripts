name "execution_node"
description "Cluster Execution Node"
run_list( 
  'recipe[sys::apt]',
  'recipe[sys::file]',
  'recipe[sys::link]',
  'recipe[sys::mount]'
)
default_attributes(
  sys: {
    apt: {
      packages: [ 'slurmd' ]
    },
    file: {
      '/etc/munge/munge.key' => { content: '030340d651edb16efabf24a8c080d4b7' }
    },
    link: {
      '/etc/systemd/system/multi-user.target.wants/munge.service' => { to: '/lib/systemd/system/munge.service' }
    },
    mount: {
      #
      # Mount the Slurm configuration space read-only
      #
      '/etc/slurm-llnl' => {
        device: 'lxrm01.devops.test:/etc/slurm-llnl',
        fstype: 'nfs',
        options: ['ro','nosuid'],
        action: [ :mount, :enable ]
      },
      #
      # Mount the shared storage to /net 
      #
      '/network' => {
        device: 'lxrm01.devops.test:/network',
        fstype: 'nfs',
        options: ['rw','nosuid'],
        action: [ :mount, :enable ]
      }
    }
  }
)

