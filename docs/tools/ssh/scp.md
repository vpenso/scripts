
`scp` (secure copy) moves files across SSH connections:

* Source and/or destination can be located on a remote computer
* Option **`-r` copies recursively** all file in the directory tree

```bash
# copy files to a remote server
scp -r /local/path/ jdow@pool.devops.test:remote/path/
# copy files from a remote server
scp -r jdow@pool.devops.test:remote/file/ /local/path
```

Transfer a signification amount of data by increasing the speed with an alternative encryption method:

```bash
scp -c blowfish -r jdow@pool.devops.test:/path/to/data/ /local/path/to/data
```
