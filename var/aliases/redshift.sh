command -v redshift >&- && {
        # close stdio and start...
        alias redshift="ds redshift"
        # note: configuration in ~/.config/redshift/redshift.conf
}
