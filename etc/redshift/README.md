### Redshift

[Redshift][reds] (cf. github:[redshift][ghub]):

> Adjusts the color temperature of your screen according to your surroundings. 
> This may help your eyes hurt less if you are working in front of the screen 
> at night.

Files                           | Description
--------------------------------|-------------------------------------
[etc/redshift/redshift.conf][0] | Configuration within this repository
[bin/redshift-install][1]       | Install and configure Redshift
[var/aliases/redshift.sh][2]    | Shell environment configuration

[0]: redshift.conf
[1]: ../../bin/redshift-install
[2]: ../../var/aliases/redshift.sh]

Get latitude/longitude coordinates from [GeoNames][geon]

User configuration is expected at `~/.config/redshift/redshift.conf`

```bash
# test the configuration
redshift -c $SCRIPTS/etc/redshift/redshift.conf
```

Example configuration file on GitHub [redshift.conf.sample][ecnf]


[reds]: http://jonls.dk/redshift/
[ecnf]: https://raw.githubusercontent.com/jonls/redshift/master/redshift.conf.sample
[geon]: https://www.geonames.org/
[ghub]: https://github.com/jonls/redshift
