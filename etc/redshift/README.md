
Files                 | Description
----------------------|-------------------------------------
[redshift.conf][0]    | Configuration in thes repository
[redshift-install][1] | Install and configure Redshift

[0]: redshift.conf
[1]: ../../bin/redshift-install

Get latitude/longitude coordinates from [GeoNames][geon]

User configuration is expected at `~/.config/redshift/redshift.conf`

```bash
# test the configuration
redshift -c $SCRIPTS/etc/redshift/redshift.conf
```

Example configuration file on GitHub [redshift.conf.sample][ecnf]


[ecnf]: https://raw.githubusercontent.com/jonls/redshift/master/redshift.conf.sample
[geon]: https://www.geonames.org/
