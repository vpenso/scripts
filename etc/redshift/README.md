### Redshift

[Redshift][reds] (cf. github:[redshift][ghub]):

> Adjusts the color temperature of your screen according to your surroundings. 
> This may help your eyes hurt less if you are working in front of the screen 
> at night.

Files                           | Description
--------------------------------|-------------------------------------
`etc/redshift/redshift.conf`    | Configuration within this repository
`bin/redshift-install`          | Install and configure Redshift
`var/libexec/redshift.sh`       | Shell environment configuration

Get latitude/longitude coordinates from [GeoNames][geon]


```bash
# test the configuration
redshift -c $SCRIPTS/etc/redshift/redshift.conf
```

Example configuration file on GitHub [redshift.conf.sample][ecnf]

`redshift-install` deploys the configuration:

* Try to install `redshift` via package management (requires Sudo)
* Write the configuration to `~/.config/redshift/redshift.conf`
* Install `var/libexec/redshift.sh` to `/etc/profile.d/redshift.sh`

Shell aliases:

```bash
alias night=redshift-on
alias day=redshift-off
```


[reds]: http://jonls.dk/redshift/
[ecnf]: https://raw.githubusercontent.com/jonls/redshift/master/redshift.conf.sample
[geon]: https://www.geonames.org/
[ghub]: https://github.com/jonls/redshift
