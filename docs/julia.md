
# Deployment

```bash
git clone git://github.com/JuliaLang/julia.git         # get the source code
apt-get -y build-dep julia                             # get the build dependencies on Debian
apt -y install python cmake libssl-dev                 # snafu
git branch -r | grep release                           
git checkout release-0.5                               # checkout the stable version
make                                                   #
```

## Usage

```bash
julia                                    # start the interpreter
*.jl                                     # suffix for Julia scripts
julia <script> <args>                    # execute Julia script
julia <options> -- <scripts> <args>      # separate interpreter args from script
julia -e 'C' <args>                      # evaluate code fragment by option
```

Globals

```bash
quit()                                   # exit julia interpeter, or CTRL-D
ARGS                                     # argument list
PROGRAM_FILE                             # name of script file
STDOUT                                   # standard out stream
STDERR                                   # standard error stream
STDIN                                    # standard input stream
print(v)                                 # print representation of a value v
println(v)                               # print followed by a newline
```

Built-in package manager for [registered packages](http://pkg.julialang.org/)

```bash
versioninfo()                            # show software environment
Pkg.status()                             # summary of the state of packages
   .installed()                          # list installed packages
   .add("P")                             # install package
   .update()                             # update packages
   .pin("P",v"V")                        # ping package version
   .free("P")                            # unpin package
   .rm("P")                              # remove package
   .build("p")                           # build package
   .test("P")                            # test package
using P                                  # load package
```
