**Version Control System** (VCS) (aka _source control_ or _revision control_):

* **History** (track changes) of files (short & long-term undo)
* **Backup** and **restore** of a code base
* **Collaborate** (share changes among users)
* **Synchronization** (of distributed repositories)
* **Sandboxing** (develop in dedicated branches)

**Why Use Version Control?**

* **Prevent deletion**, accidentally lose of files
* Capability to **revert changes** in files
* Enables to **review the history** of files
* Allows **in-deeps comparison** between different versions of files

A [**repository**][rp] (a database of changes) is the data structure that stores files with history and metadata.

Version control systems differ in where the repository lives:

* **Distributed** (i.e. Git, Mercurial)
  - File history in a hidden repository folder inside the working copy
  - Checkouts, commits interact with the local repository folder
  - Different copies of the repository synchronized by the version control software
  - Typically repositories distributed with multiple public/private repositories
* **Centralized** (i.e. CVS, Subversion)
  - Dedicated central server, stores files' history and controls access
  - Separate local working copy from the "master copy" on the server
  - Working copy only stores the current versions (history in the server repository)
  - Checkouts, commits require connection to the server

[rp]: https://en.m.wikipedia.org/wiki/Repository_(version_control)

# Git

**Why Using Git?**

* **Free and open source** distributed version control system (no central server)
* **Fast** since all operations performed locally
* **Implicit backup** since multiple copies are stored in distributed locations
* All data is store **cryptographicaly secured** (temper proof)

TODO: content-addressable filesystem

## Commits

[Commit][cm] to **add the latest changes** to the repository:

* A commit include...
  - ID of the previous commit(s)
  - Content, commit date & messages
  - Author and committer name and email address
* The **commit ID** ([SHA-1 hash][ha]) cryptographically certifies the 
  integrity of the entire history of the repository up to that commit
* Commits are **immutable** (can not be modified) afterwards (except HEAD)
* Child commits point to **1..N parent commits** (typically 1 or 2)
* `HEAD` revision is the active commit, parent of the next commit

[cm]: https://en.m.wikipedia.org/wiki/Commit_(version_control)
[ha]: https://en.m.wikipedia.org/wiki/Cryptographic_hash_function

**Files states** include the following three: 

* **Modified** - Changed file(s) in working copy, not committed to repository
* **Staged** - Marked modified file(s), current version to be committed to repository 
* **Committed** - Data is safely stored in your local repository

File states belong to one of the following three **storage positions**:

* The **working copy** (checkout) contains editable files (a copy of the repository data)
* The **staging area** (index) holds all marked changes ready to commit
* The **git repository** `.git/` stores all files, meta-data

### Construct Commits

The **basic workflow**:

1. Modify a file in the working copy, check with `git status`
2. Accept a change to the staging are by adding a file with  `git add`
3. Perform a `git commit` that permanently stores files in staging to the repository

```bash
git status                               # show files changed in the working tree and index
git add <file>                           # add/update file from the working tree into
                                         # the index
git checkout <file>                      # undo modifications to file in the working
                                         # tree (by reading it back from the index)
git reset <file>                         # unstage changes to file in the index (without
                                         # touching the working tree)
git rm <file>                            # delete file from the index and working tree
git mv <sfile> <dfile>                   # move a file in working tree, plut appropriate
                                         # addtions/removals in the index
git commit                               # make a commit out of the current index
```
```bash
# more sophisticated usage of the commands above
git add .                                # add all current changes in working tree into the index
git commit -m '<message>'                # commit files in staging area
git commit -am '<message>'               # commit all local changes
git commit --amend                       # change last commit
# Set the committer name & email for a single commit
GIT_COMMITTER_NAME='<name>' GIT_COMMITTER_EMAIL='<mail>' git commit --author 'name <mail>'
git checkout <commit> <file>             # checkout specific version of a file
git reset HEAD --                        # discard all changes in the staging area
git reset --hard                         # discard uncommited changes
git reset --hard <hash>                  # discard until specified commit
git clean -f                             # recursivly remove files not in version control
```

### Display Changes

A **reference** `ref` is a (named mutable) pointer to an object (usually a commit)

* Git knows different types of references:
  - **heads** refers to an object locally
  - **remotes** refers to an object which exists in a remote repository
  - **stash** refers to an object not yet committed
  - **tags** reference another object

Automatically stores as [Directed Acyclic Graph][dag] (DAG) of objects

[dag]: https://en.wikipedia.org/wiki/Directed_acyclic_graph

Referring to objects:

* Use its full SHA-1 commit ID e.g. `66f67970e73b5ad213d9bc69f7e6497b6bfc1b75`
* Truncated commit id s long as it is unambiguous e.g. `66f6797`
* You can refer to a branch or tag by name
* Append a `^` to get the (first) parent, `^2` second parent, etc.
* Append `:<path>` for a file or directory inside commit’s tree
* Cf. `git help rev-parse`

```bash
git log                                  # list commits (on the current branch)
git show <object>                        # show object (e.g. path for a commit, content of a file)
git diff                                 # show difference between working tree and index
git diff --cached                        # show difference between HEAD and index (staged changes)
git diff <commit>                        # show difference between commit and the working tree
```
```
# More sophisticated usage of the commands above:
git log --stat                            # list changed files
git log -1 ...                            # show last commit
git log --decorate --oneline --graph      # prettier graph-like structure
git log --follow -p -- <file>             # follow changes to a single file
git log -p                                # with changes inline
git log -S "<regex>"                      # search for string
git shortlog -en                          # summarizes git log and groups by author
```

## Repository

A repository includes four kinds of objects:

- A **blob** ([binary large object][blo]) is the content of a file
- A **tree** object is the equivalent of a directory (cf. [Merkle tree][mkt])
- A **commit** object links tree objects together into a history
- A **tag** object is a container that contains a reference to another object

[blo]: https://en.wikipedia.org/wiki/Binary_large_object
[mkt]: https://en.wikipedia.org/wiki/Merkle_tree


Every **working copy** has its own Git repository in the `.git` subdirectory:

* With arbitrarily many branches and tags
* Most important ref is `HEAD` (which refers to the current branch)
* Stores the index (staging area) for changes on top of **HEAD** that will become part of the next commit
* Files outside of `.git` are called the **working tree**

```bash
.git/                                    # git repository directory
.git/config                              # configuration of the repository
.gitignore                               # files to ignore in the working tree
# list ignored files
git status --ignored
git clean -Xn                            # display a list of ignored files
git clean -Xf                            # remove the previously displayed files
git check-ignore -v <file>               # check if file is ignored
```

### Create New Repositories

Create, **`init` (initialize) a new repository** in `.git/`: 

* Create an empty repository in the **current working directory**
* By default it will have one **master branch**

```bash
# initialize a new repository
git init                                 
```

Repositories used for clone, push and pull usually are a **bare repository**:

* A bare repositories (by definition) has **no working tree** attached
* It's conventional to give bare repositories the extension (suffix) `.git` (instead of `project/.git`)
* Update a bare repository by pushing to it (using `git push`) from another repository

```bash
# intialize a new repository without working tree
git init --bare /path/to/project.git
```

### Remote Repositories

Git allows **bidirectional synchronisation** between any number of repositories:

* A Git repository can be configured with **references to any number of remotes**
* Supports many protocols: SSH, HTTPS, DAV, Git protocol, Rsync, and a path to a local repository
* Allows centralized and/or distributed development models

Copy, **`clone` a repository** from another location:

```bash
# clone a remote repository and create a working copy, optionally provide the target directory
git clone <url> [<path>] 
```

Following syntax references remote URLs and local paths:

```
# remote
ssh://[user@]host.xz[:port]/path/to/repo.git/
git://host.xz[:port]/path/to/repo.git/
http[s]://host.xz[:port]/path/to/repo.git/
[user@]host.xz:/~[user]/path/to/repo.git/
# local
file:///path/to/repo.git/
/path/to/repo.git/
```

Remote repositories are **configured in `.git/config`** (cf. `git help git-config`):

* Freshly cloned repository have...
  - One reference to the  **`origin` remote repository** (default source to pull/push)
  - Automatically create a master branch that tracks `origin/master`
* Checkout of a local branch from a remote branch automatically creates a **tracking branch**

```bash
# clone a remote repository and checkout a specific branch
git clone -b <branch> <url> [<path>]                
```

Modify references to other repositories:

```bash
git remote -v                               # list references to remote repos (including URLs)
git remote add <remote_ame> <remote_url>    # add a reference to a remote repository
git remote show <remote_name>               # inspect a remote repository
git remote rename <old_name> <new_name>     # rename a reference to a remote repository
git remote rm <remote_name>                 # delete a reference to a remote repository
```

### Synchronize Repositories

Git repositories are **not automatically synchronised**:

* Requires a **manual `pull` of remote commits** into the local repository
* Requires a **manual `push` of commits** into a remote repository

```bash
# update current (tracking) branch from upstream
git pull                                 # short for git fetch + git merge
# push current (tracking) branch
git push
```

**Merge vs. Rebase** [1]:

* A **merge** combines the local branch with the remote (branch)
  - Default merge behaviour is to perform a **fast-forward**
  - Commits without conflicts are simply absorbed into the branch
  - A **conflict** requires a **merge commit**
  - Disable fast-forward `--no-ff` to force every merge to produce a merge commit
* **rebase** applies commits from current branch onto the head of the specified branch
  - "replaying" changes with new commits (hashes/timestamps)
  - Merge resolution is absorbed into the new commit

```bash
git pull --no-ff                         # disable fast-forward
git pull --rebase                        # short for git fetch + git rebase
git pull --all                           # update all local branches from their corresponding remote branches
git pull <remote_name> <branch_name>     # update current branch from a specific remote banch
git push <remote_name> <branch_name>     # push specific branch to a remote
git push -u ...                          # track remote with current branch
```



Local changes will not be overwritten by `git pull`, ...workflow:

```bash
git stash                                # stash the changes in working tree
git pull --rebase                        # rebase commits on the remote version of the branch
git stash pop                            # apply changes on the current working tree
```

## Branch & Tags

**Branches**, floating pointer that move on commit

- Files in `.git/refs/heads` (local), `.git/refs/remotes` (remote)
- Contains the SHA of the commit it's pointing at

```bach
git branch                               # list branches in repository (* marks the current branch)
git checkout <branch>                    # switch to branch (update HEAD, index, and working tree)
git checkout -b <branch> [<commit>]      # create new branch at commit (defaults to HEAD), and switch to it
git branch -d <branch>                   # delete branch
git branch -m <branch> <nbranch>         # remane branach to nbranch
git tag <name> [<commit>]                # create new tag  to commit (defaults to HEAD)
git tag -d <name>                        # delete tag
```

```bash
git branch -r                            # list available emote branches
git branch -a                            # list available local and remote branches
git branch -dr <remote/branch>           # delete remote branch
git checkout -b <name> <remote/branch>   # checkout remote branch
git checkout <branch>                    # checkout local branch
git merge <branch>                       # merge into current HEAD
git rebase <branch>                      # rebase HEAD onto branch
git ls-remote --tags <repo>              # list tags of remote repository
git fetch                                # fetch remote tags
git tag -l                               # list local tags
git tag -l <regex>                       # list specific tags
git tag -n1 -l                           # list local tags with commit message
git tag -a <version> -m <message>        # create new local tag
git tag -a <version> <hash>              # tag specific commit
git push <name> <tag>                    # push local tag to remote repository
git push --tags <name>                   # push all local tags to remote repository
git tag -l | xargs git tag -d            # delete all local tags
```

## Configuration

Customize the user configuration:

```bash
~/.gitconfig                                 # user configuration file
~/.gitignore_global                          # rules for ignoring files in every Git repository
git help config                              # configuration documentation
git config --list                            # dump configuration
git config --global <key> <value>            # set configuration
git config --global alias.<abr> '<command>'  # set command alias
git config --global http.proxy $proxy
git config --global https.proxy $proxy       # use a network proxy
git config --global --unset http.proxy
git config --global --unset https.proxy      # disable network proxy
```

File                       | Description
---------------------------|-----------------------------------------------------
[git-default-config][gc]   | Example script dot deploy a custom user configuration

[gc]: ../../bin/git-default-config

### User & Mail

Set username an mail address for all repositories (in `~/.gitconfig`):

```bash
git config --global user.name "Your Name"
git config --global user.email mail@example.com
```

Repository specific (in `.git/config`):

```bash
# from the working tree
git config user.name "Your Name"
git config user.email mail@example.com
```


### Aliases


```bash
git ls-files -t --exclude-per-directory=.gitignore --exclude-from=.git/info/exclude
                                          # list files
git log --pretty=format:"%C(yellow)%h%Cred%d %Creset%s%Cblue (%cn)" --decorate --numstat
                                          # show commits with a list of cahnges files
git log --pretty=format:"%C(yellow dim)%h%Creset %C(white dim)%cr%Creset ─ %s %C(blue dim)(%cn)%Creset"
                                          # list commt messages one by line
```

### Multiple Repositories

[git-repos][git-repos] helps to solve the following three use-cases:

1. Maintains a list of Git remote repositories associated to a local directory tree. 
2. Indicate the local status for a list of repositories.
3. Indicate the state of remotes for a list of local repositories.

Example output:

    » git repos status -v       
    Reading configuration from ~/.gitrepos
    Git in ~/projects/dummy
    ?? path/to/new/file
    Git in ~/projects/scripts
    ↑1 backup/master
    ↑3 github/master
     M git-repos
    Git in ~/projects/site
    AM posts/git_repos.markdown

_git-repos_ looks for a repository list in `$PWD/.gitrepos`, `~/.gitrepos` or it expects a parameter `--config PATH`. It supports two commands **init** and **status**. Init creates all missing directories defined in the repository list by running `git init` to create an empty repository, followed by executing `git remote add` to configure all defined remote repositories. Status runs `git status -s` on all repositories. Additionally it checks if the local repositories are ahead of their remotes with `git rev-list`. A list of repositories is defined like:

    /path/to/the/repository
      origin git://host.org/project.git
      backup ssh://user@host.org/project.git
    /path/to/another/repository
      name ~/existing/repo
    ~/path/to/yet/another/repo
      foobar ssh://user@host.org/foobar.git
    realitve/path/to/repository
      deploy git://fqdn.com/name.git

Each directory is followed by a list of remotes using the notation of <tt>git remote add</tt>. First the name of the remote, second the URI to the remote repository. 


[git-repos]: ../bin/git-repos
[git-default-config]: ../bin/git-default-config

# References

[1] _The ultimate git merge vs rebase tutorial_, Toby Fleming (2018)  
<https://tobywf.com/2018/01/the-ultimate-git-merge-vs-rebase-tutorial/>

[2] _The Git Parable_, Tom Preston-Werner (2009)  
<http://tom.preston-werner.com/2009/05/19/the-git-parable.html>

[3] _Git Notes for Professionals_  
<https://goalkicker.com/GitBook/>

[4] _How to teach Git_, Rachel M. Carmena (2018)  
<https://rachelcarmena.github.io/2018/12/12/how-to-teach-git.html>

[5] _Pro Git_ 2nd Edition, Scott Chacon and Ben Straub (2014)  
<https://git-scm.com/book/en/v2>

[6] Gitea, self-hosted Git service  
<https://gitea.io>

[7] GitHub, commercial Git service (Microsoft)  
<https://github.com/>

[8] GitLab, commercial Git service based on Open Source core  
<https://gitlab.com/>
