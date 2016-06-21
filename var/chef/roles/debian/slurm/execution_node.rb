name "execution_node"
description "Cluster Execution Node"
run_list( 
  'recipe[sys::boot]',
  'recipe[sys::apt]',
  'recipe[sys::accounts]',
  'recipe[sys::file]',
  'recipe[sys::link]',
  'recipe[sys::mount]'
)
default_attributes(
  sys: {
    boot: {
      params: [
        'cgroup_enable=memory',
        'swapaccount=1'
      ]
    },
    apt: {
      packages: [ 
        'dbus',
        'libpam-systemd',
        'slurmd',
        'stress'
      ]
    },
    accounts: {
      spock: { uid: 1111 },
      sulu: { uid: 1112 },
      kirk: { uid: 1113 },
      uhura: { uid: 1114 }
    },
    file: {
      '/etc/munge/munge.key' => { content: '030340d651edb16efabf24a8c080d4b7' }
    },
    link: {
      '/etc/systemd/system/multi-user.target.wants/munge.service' => { to: '/lib/systemd/system/munge.service' }
    },
    mount: {
      '/etc/slurm-llnl' => {
        device: 'lxrm01.devops.test:/etc/slurm-llnl',
        fstype: 'nfs',
        options: ['ro','nosuid'],
        action: [ :mount, :enable ]
      },
      '/network' => {
        device: 'lxrm01.devops.test:/network',
        fstype: 'nfs',
        options: ['rw','nosuid'],
        action: [ :mount, :enable ]
      }
    }
  }
)

