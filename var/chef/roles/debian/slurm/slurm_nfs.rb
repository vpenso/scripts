name 'slurm_nfs'
description 'NFS server for SLURM'
run_list(
  'recipe[base]'
)
default_attributes(
  package: ['nfs-kernel-server'],
  directory: {
    '/network': {}
  },
  file: {
     # NFS shares configuration
     #
     '/etc/exports' => { 
        content: "/etc/slurm-llnl lx*(ro,sync,no_subtree_check)\n/network lx*(rw)\n",
        notifies: [ :restart, 'systemd_unit[nfs-server.service]' ]
     }, 
  },
  systemd_unit: {
    'nfs-server.service': { action: [:enable,:start] }
  }
)

