

```bash
perl-rename -n ...             # dry run
perl-rename 's/P/R/' **/*      # recursive replacemnt
            's/_/-/g'                   # replace underscore with dash
            's/-[0-9]x[0-9].jpg/.jpg/'  # remove dimension suffix
            's/-.jpg/.jpg/'             # remove dash before filename extension
```
