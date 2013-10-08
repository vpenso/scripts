## git-repos

[git-repos][git-repos] helps to solve the following three use-cases:

1. Maintains a list of Git remote repositories associated to a local directory tree. 
2. Indicate the local status for a list of repositories.
3. Indicate the state of remotes for a list of local repositories.

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

_git-repos_ looks for a repository list in <tt>$PWD/.gitrepos</tt>, <tt>$HOME/.gitrepos</tt> or it expects a parameter <tt>--config PATH</tt>. It supports two commands **init** and **status**. _Init_ creates all missing directories defined in the repository list by running <tt>git init</tt> to create an empty repository, followed by executing <tt>git remote add</tt> to configure all defined remote repositories. _Status_ runs <tt>git status -s</tt> on all repositories. Additionally it checks if the local repositories are ahead of their remotes with <tt>git rev-list</tt>. A list of repositories is defined like:

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


[git-repos] ../bin/git-repos
