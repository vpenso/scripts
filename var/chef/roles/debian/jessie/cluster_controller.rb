name 'cluster_controller'
description 'Slurm Cluster Controller'
run_list(
  'recipe[sys::apt]',
  'recipe[sys::file]'
)
default_attributes(
  sys: {
    apt: {
      packages: [
        'nfs-kernel-server',
        'slurmctld',
        'slurmdbd'
      ]
    },
    file: {
      '/etc/exports' => { 
        content: "/etc/slurm-llnl lx*.devops.test(ro,sync,no_subtree_check)\n"
      },
      '/etc/munge/munge.key' => {
        content: '030340d651edb16efabf24a8c080d4b7',
      }
    }
  } 
)

