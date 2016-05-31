# atocker
Atom 1.7 Editor with go-tools bundled in Docker.

![Screenshot](screenshot.png)

This docker image contains [atom](http://atom.io), [go-plus](https://github.com/joefitzgerald/go-plus)  and many go tools. The configuration conforms to a standard *GOPATH* filesystem layout. Earliear Versions of
**atocker** used the directory layout of [gb](http://getgb.io/); with Go 1.6 vendoring is a part of
Go itself, so imho it is not needed any more to use sepearate directories for specific projects. If you want `gb` support, you should start `atocker` with `gb` as parametern. In this case, the script will put then `/work/vendor` directory in the `GOPATH` and most of the go-tools should work.

You can start the editor in any empty directory and this will be used as the single *GOPATH*. So if you want to
develop for [docker](https://github.com/docker/docker) it would be ok to have a directory tree like this:
```
~/development
+--src
   +--github.com
      +--docker
         +-- (clone https://github.com/docker/docker)
   +--bitbucket.org
   ...
+--pkg
+--bin
```

In this scenario you should set `GOPATH` to `~/development` and your Go tools should work. If this
variable is exported it is also possible to use `go get ...` to fetch the desired Go repositories. No start
`atocker` inside of your `~/development` directory.

## Vendoring

There are many tools for Go vendoring; the tool inside the container is [glide](http://glide.sh), although
it is not needed by the container itself. Please note that `glide` (or `gpm` or `gvp`) is needed
**outside** of the container! When working on a Go project you should add your dependencies with theses
tools, so you should **not** do a `go get github.com/fsouza/go-dockerclient` because in this case the
dependency will be installed in your `GOPATH` and will be visible for all your projects. You should use
`glide get github.com/fsouza/go-dockerclient` instead (if you use glide); performing this command
in your project (which sould be initialized with `glide`) you will have a directory named `vendor`
which will contain the needed dependency.

This `vendor` mechanism is now a standard in Go (with 1.5 it was only an experiment); and so it is much
easiear to work with one single `GOPATH` than it was before

## Configurtation
Please note: When using the given start script (or alias) the settings and plugins of the editor will be stored in your
`$HOME/.config/atocker/<workspacepath>` directory. All plugins will be in your `$HOME/.config/atocker/.atom/packages` folder.

[![Docker Repository on Quay.io](https://quay.io/repository/ulrichschreiner/atocker/status "Docker Repository on Quay.io")](https://quay.io/repository/ulrichschreiner/atocker)

Use the given `atocker` script to start an instance or create an alias:

```
_atocker() {
  docker run  \
    --rm \
    -it \
    -v /etc/localtime:/etc/localtime:ro \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v `pwd`:/work \
    -v $HOME/.config:/config \
    -v $HOME/.gitconfig:/devhome/.gitconfig \
    -v $SSH_AUTH_SOCK:/ssh-agent --env SSH_AUTH_SOCK=/ssh-agent \
    --device /dev/dri \
    -e DISPLAY=$DISPLAY \
    -e LANG=$LANG \
    -e HOSTUSER=`id -un` \
    -e HOSTGROUP=`id -gn` \
    -e HOSTUSERID=`id -u` \
    -e HOSTGROUPID=`id -g` \
    -e WORKSPACE=`pwd` \
    quay.io/ulrichschreiner/atocker "$1"
}
alias gbatom=_atocker gb
alias atm="_atocker"
```
Note: If you have private repositories where you need your SSH keys, start an agent before starting `atocker` and add your keys with `ssh-add`. The agent will be forwarded to the container so the tools to pull inside of atom will work.

Now you can use `gbatom` to start an atom editor where the needed filesystem layout will be created if it does not exist. You can also use `atm` to start a Atom editor in the current working directory without creating `src` and `vendor/src` directories. When using in `go` mode, the startup script will also create a symlink in the vendor's package directory so the standard go tools will work. Please do not delete this link!

## Included Plugins

- [blame](https://atom.io/packages/blame)
- [file-icons](https://atom.io/packages/file-icons)
- [git-control](https://atom.io/packages/git-control)
- [git-history](https://atom.io/packages/git-history)
- [git-log](https://atom.io/packages/git-log)
- [git-plus](https://atom.io/packages/git-plus)
- [go-plus](https://atom.io/packages/go-plus)
- [go-rename](https://atom.io/packages/go-rename)
- [language-docker](https://atom.io/packages/language-docker)
- [language-protobuf](https://atom.io/packages/language-protobuf)
- [merge-conflicts](https://atom.io/packages/merge-conflicts)
- [minimap](https://atom.io/packages/minimap)
- [minimap-bookmarks](https://atom.io/packages/minimap-bookmarks)
- [minimap-find-and-replace](https://atom.io/packages/minimap-find-and-replace)
- [react](https://atom.io/packages/react)
- [symbols-tree-view](https://atom.io/packages/symbols-tree-view)
- [tool-bar](https://atom.io/packages/tool-bar)
- [tool-bar-almighty](https://atom.io/packages/too-bar-almighty)

Please note: For `git` you need your correct git configuration. In my example i mount my `$HOME/.gitconfig` into the container.

## See also
If you don't like atom, you should give  [Visual Studio Code](https://github.com/ulrichSchreiner/vsc) a try.
