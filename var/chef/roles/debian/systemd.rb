name 'systemd'
description 'Common configuration of systemd'
run_list(
  'recipe[sys::apt]',
  'recipe[sys::link]',
  'recipe[sys::systemd]'
)
default_attributes(
  sys: {
    apt: {
      packages: [
        'dbus',
        'libpam-systemd' # PAM configuration for systemd
      ]
    },
    link: {
      #  local clients that bypass any local DNS API will also bypass systemd-resolved
      '/etc/resolv.conf': {
        to: '/run/systemd/resolve/resolv.conf',
        link_type: :symbolic
      }
    },
    systemd: {
      unit: {
        'systemd-logind.service': { action: :enable },

        ##
        # Localization
        #
        'set-locales.service': {
          action: [:create,:enable,:start],
          config: {
            'Unit': { 'Description': 'Set locales to en_US.UTF-8' },
            'Service': {
              'ExecStart': '/usr/bin/localectl set-locale LANG="en_US.UTF-8" LC_CTYPE="en_US" LANGUAGE="en_US:en"',
              'RemainAfterExit': 'yes',
              'Type': 'oneshot'
            }
          }
        },
        
        ##
        # Time configuration
        #
        'set-timezone.service': {
          action: [:create,:enable,:start],
          config: {
            'Unit': { 'Description': 'Set the time zone to Europe/Berlin' },
            'Service': {
              'ExecStart': '/usr/bin/timedatectl set-timezone Europe/Berlin',
              'RemainAfterExit': 'yes',
              'Type': 'oneshot'
            }
          }
        },
        'timesyncd.conf': {
          action: :create,
          directory: '/etc/systemd',
          config: {
            'Time': {
              'NTP': '0.de.pool.ntp.org 1.de.pool.ntp.org  2.de.pool.ntp.org 3.de.pool.ntp.org',
              'FallbackNTP': '0.debian.pool.ntp.org 1.debian.pool.ntp.org 2.debian.pool.ntp.org 3.debian.pool.ntp.org'
            }
          }
        },
        'systemd-timesyncd.service': { 
          action: [:enable,:start] 
        },
        
        ##
        # Journal configuration
        #
        'journal-storage.conf': {
          action: :create,
          directory: '/etc/systemd/journald.conf.d',
          config: {
            'Journal': { 'Storage': 'persistent' }
          }
        },
        'systemd-journald.service': { 
          action: [:enable,:start] 
        },

        ##
        # Network configuration
        #
        '50-dhcp.network': {
          action: :create,
          directory: '/etc/systemd/network',
          config: {
            #
            # Ethernet interfaces use DHCP to acquire IP addresses
            #
            'Match': { 'Name': 'en*' },
            'Network': { 'DHCP': 'yes' }
          }
        },
        'systemd-networkd.service': { 
          action: [:enable,:start] 
        },
        
        ##
        # DNS resolve
        #
        'resolved.conf': { 
          action: :create,
          directory: '/etc/systemd',
          config: {
            #
            # cf. man 5 resolved.conf
            #
            'Resolve': { 
              'DNS': '208.67.222.222 208.67.220.220', # OpenDNS
              'FallbackDNS': '8.8.8.8 8.8.4.4', # Google
              'Domains': 'devops.test',
              'Cache': 'yes'
            }
          }
        },
        'systemd-resolved.service': { 
          action: [:enable,:start] 
        }
      }
    }
  } 
)

