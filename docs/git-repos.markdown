↪ `bin/git-repos.rb`

Over the last years the number of Git repositories I'm working with has grown significantly. Privately I'm maintaining all code and documents with Git and at work it has become an important source code control system as well (retiring Subversion slowly). Very often I'm working on several repositories in parallel while switching from my workstation or laptop at work to my computer at home. Unfortunately it happens that I forget to push commits to all remotes, or even worse to commit changes altogether (mostly triggered by user interrupts). For many repositories at least three remotes are mandatory for me. A first copy on GitHub (if it is public work), a second company internal in Gitorious, and a third on my personal backup storage (since shit happens). All in all I do work with **dozens of repositories, most of them with several remotes, from a couple of computers** (more precise development virtual machines).

Basically I did need a solution for three problems:

1. Maintain a list of remote repositories linked to a directory structure. It should be possible to initialize the directory tree with empty Git repositories including their corresponding remotes configured with a single command.
2. Run Git status on all listed repositories and print the output if changes are not committed yet.
3. Indicate if a local repository has commits not pushed to one of the remotes.

The output of the Ruby script `git-repos` I have implemented to solve this looks like the following:

    » git repos status -v       
    Reading configuration from ~/.gitrepos
    Git in ~/chef/roles
    ?? development/cookbooks/opennetadmin_test.rb
    Git in ~/projects/scripts
    ↑1 backup/master
    ↑3 github/master
     M git-repos
    Git in ~/projects/site
    AM posts/2012/07/managing_git_repositories.markdown

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

There are plenty of alternative approaches to work with many Git repositories like [gits][2] or [git-repo][3]. You will find a lot of blog posts, many with scripts for similar problems like I have described here. Since this is depending on your working habits and your environment take this article as another source of inspiration to develop a custom solution for managing multiple git repositories.


[2]: http://gitslave.sourceforge.net/
[3]: http://code.google.com/p/git-repo
