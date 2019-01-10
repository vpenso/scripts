# Version Control

**Version Control System** (VCS) (aka _source control_ or _revision control_):

* Remembers the **history of files**, to enable access to older versions
* Helps to coordinate and **share changes** among users (and locations)

A [**repository**][rp] (a database of changes) it the data structure that stores files with history and metadata.

Version control systems differ in where the repository lives:

* **Distributed** (i.e. Git, Mercurial)
  - File history in a hidden repository folder inside the working copy
  - Checkouts, commits interact with the local repository folder
  - Different copies of the repository synchronized by the version control software
  - Typically repositories distributed with multiple public/private repositories
* **Centralised** (i.e. CVS, Subversion)
  - Dedicated central server, stores files' history and controls access
  - Separate local working copy from the "master copy" on the server
  - Working copy only stores the current versions (history in the server repository)
  - Checkouts, commits require connection to the server

[rp]: https://en.m.wikipedia.org/wiki/Repository_(version_control)

**Why Use Version Control?**

* **Prevent deletion**, accidentally lose of files
* Capability to **revert changes** to files
* Enables to **review the history** of files
* Allows **in-deeps comparison** between different versions of files


# Git

[Git][gi], distributed version control system, cf.:

* [The Git Parable][gp]
* [Git® Notes for Professionals book][gn]

[gi]: https://git-scm.com/
[gn]: https://goalkicker.com/GitBook/
[gp]: http://tom.preston-werner.com/2009/05/19/the-git-parable.html

**Why Using Git?**

* **Free and open source** distributed version control system (no central server)
* **Fast** since all operations performed locally
* **Implicit backup** since multiple copies are stored in distributed locations
* All data is store **cryptographicaly secured** (temper proof)

TODO: content-addressable filesystem, DAG 

## Commits

[Commit][cm] to **add the latest changes** to the repository:

* Commits are identified by a **unique commit ID** and include
  - ID of the previous commit(s)
  - Content, commit date & messages
  - Committer's name and email address
* Commits are **immutable** (can not be modified) afterwards (except HEAD)
* Child commits point to **1..N parent commits** (typically 1 or 2)
* `HEAD` revision is the active commit, parent of the next commit
* The [SHA-1 hash][ha] commit id makes the commit **cryptographically secure**

[cm]: https://en.m.wikipedia.org/wiki/Commit_(version_control)
[ha]: https://en.m.wikipedia.org/wiki/Cryptographic_hash_function

**Files states** include the following three: 

* **Modified** - Changed file(s) in working directory, not committed to repository
* **Staged** - Marked modified file(s), current version to be committed to repository 
* **Committed** - Data is safely stored in your local repository

File states belong to one of the following three **storage positions**:

* The **working directory** (checkout) contains the editable copy of the repository
* The **staging area** (index) holds all marked changes read to commit
* The **git repository** `.git/` stores all files, meta-data

The **basic workflow**:

1. Modify a file from the working directory, check with `git status`
2. Accept a change to the staging are by adding a file with  `git add`
3. Perform a `git commit` that permanently stores files in staging to the repository

List of commands to move files between staging and repository:

```bash
git status                               # state of files in the working directory
git add <path>                           # add new/modified file to staging area
git add .                                # add all current changes to staging area
git diff                                 # show differences between working directory and staging area
git diff --cached                        # show differences between HEAD and staging area
git commit -m '<message>'                # commit files in staging area
git commit -am '<message>'               # commit all local changes
git commit --amend                       # change last commit
git checkout                             # discard changes in working directory
git checkout -- <file>                   # discard changes in file
git checkout <commit> <file>             # checkout specific version of a file
git reset HEAD <file>                    # discard file from staging ares
git reset HEAD --                        # discard all changes in the staging area
git reset --hard                         # discard uncommited changes
git reset --hard <hash>                  # discard until specified commit
git clean -f                             # recursivly remove file not in version control
# Set the committer name & email for a single commit
GIT_COMMITTER_NAME='<name>' GIT_COMMITTER_EMAIL='<mail>' git commit --author 'name <mail>'
```

## Repository

```bash
git init                                 # initializes a new repository in $PWD
git init --bare [<path>]                 # create a repository without working directory
.git/                                    # meta-data and object database
.git/config                              # configuration of the repository in $PWD
.gitignore                               # files to ignore in local repository
git ls-files --exclude-standard --ignored --others
                                         # list ignored files
git clone <uri> [<path>]                 # clone a remote repository and checkout
                                         # working directory
git fetch <name>                         # download all changes from remote
git pull <name> <branch>                 # download & merge changes from remote
git push <name> <branch>                 # upload local changes to remote repository
git show <name>                          # show remote commit history
git remote add <name> <uri>              # configure a remote repository
git remote -v                            # list configured remote repositories
```

## Logs

```bash
git ls-files -t --exclude-per-directory=.gitignore --exclude-from=.git/info/exclude
                                          # list files
git log -1 --stat                         # show last commit
git log --pretty=format:"%C(yellow)%h%Cred%d %Creset%s%Cblue (%cn)" --decorate --numstat
                                          # show commits with a list of cahnges files
git log --pretty=format:"%C(yellow dim)%h%Creset %C(white dim)%cr%Creset ─ %s %C(blue dim)(%cn)%Creset"
                                          # list commt messages one by line
git log --follow -p -- <file>             # follow changes to a single file
```

## Branch

**Branches**, floating pointer that move on commit

- Files in `.git/refs/heads` (local), `.git/refs/remotes` (remote)
- Contains the SHA of the commit it's pointing at

```bach
git clone -b <name> <url>                # clone a remote repository, checkout branch
git pull --all                           # fetch all remote branches
git branch                               # list local branches
git branch -r                            # list remote branches
git branch -dr <remote/branch>           # delete remote branch
git checkout -b <name> <remote/branch>   # checkout remote branch
git checkout <branch>                    # checkout local branch
git merge <branch>                       # merge into current HEAD
git rebase <branch>                      # rebase HEAD onto branch
```


## Tags

**Tags**, fixed pointer to a commit

```bash
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


### Configuration

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

Repository specific committer in at `.git/config` file:

```
[user]
  name = devops
  email = devops@devops.test
```

## git-repos

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
