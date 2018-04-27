## Flatpak

<http://docs.flatpak.org/en/latest/>

**Runtimes** provide dependencies used by applications:

* Distribution agnostic and do not depend on particular distribution versions
* Multiple runtimes in different versions can be installed in parallel 
* Allow applications to continue to work irrespective of operating system updates
* Dependencies not available in a runtime can be bundled as part of the application

**Sandboxes** execute applications in an isolated environment:

* Application can only access the contents of its sandbox
* Access to system resources have to be explicitly granted
* Resources exposed from the sandbox called **exports**
* **Portals** provide a mechanism through which applications can 
  interact with the host environment (e.g. open file)

### Usage

Flatpak applications and runtimes are typically stored and published using **repositories**.

```bash
flatpak remotes                 # list repositories
# add a new repository
flatpak remote-add --if-not-exists <repo> <url>
flatpak remote-delete <repo>    # remove a repository
```

Flatpak identifiers using **identifier triples** `org.project.app`: 

```bash
flatpak remote-ls               # list available applications
flatpak search <name>           # search for an applications
flatpak install -y <repo> <app> # install an application (including dependencies)
flatpak list --app              # list installed applications
flatpak run <app>               # execute an application
flatpak update [<app>]          # update runtimes/applications to latest version
flatpak uninstall <app>         # remove application
```

### Repositories

<https://flathub.org>

```bash
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```

<https://firefox-flatpak.mojefedora.cz/>

```bash
flatpak remote-add --from org.mozilla.FirefoxRepo https://firefox-flatpak.mojefedora.cz/org.mozilla.FirefoxRepo.flatpakrepo
```

### Building

<http://docs.flatpak.org/en/latest/building.html>

Great example Flatpak installing Path of Exile in a 32bit wine prefix:

<https://github.com/johnramsden/pathofexile-flatpak>
