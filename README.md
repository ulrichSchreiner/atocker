# atocker
Atom 1.3 Editor with go-tools bundled in Docker.

![Screenshot](screenshot.png)

This docker image contains [atom](http://atom.io), [go-plus](https://github.com/joefitzgerald/go-plus)  and many go tools. The configuration conforms to
[gb](http://getgb.io/), so your project directory should conform to [this](http://getgb.io/docs/project/) layout. You can start the editor in an empty 
directory and the needed directories will be created to develop with `gb` (a `src` and a `vendor` directory). You should have `gb` installed on your 
system to build your software: simply open a second shell and type `gb build`. Make sure to create the correct [directory layout](http://getgb.io/docs/project/)!

You can start the editor in the project directory with `atocker`.

Please note: When using the given start script (or alias) the settings and plugins of the editor will be stored in your
`$HOME/.config/.atocker/<workspacepath>` directory.

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
    -e WORKSPACE=`pwd` \
    quay.io/ulrichschreiner/atocker "$1"
}
alias gbatom=_atocker
alias atm="_atocker plain"
```
Note: If you have private repositories where you need your SSH keys, start an agent before starting `atocker` and add your keys with `ssh-add`. The agent will be forwarded to the container so the tools to pull inside of atom will work.

Now you can use `gbatom` to start an atom editor where the needed filesystem layout will be created if it does not exist. You can also use `atm` to start a Atom editor in the current working directory without creating `src` and `vendor/src` directories.

## Included Plugins

- [go-plus](https://atom.io/packages/go-plus)
- [language-docker](https://atom.io/packages/language-docker)
- [language-protobuf](https://atom.io/packages/language-protobuf)
- [go-rename](https://atom.io/packages/go-rename)
- [file-icons](https://atom.io/packages/file-icons)
- [symbols-tree-view](https://atom.io/packages/symbols-tree-view)
- [git-plus](https://atom.io/packages/git-plus)
- [minimap](https://atom.io/packages/minimap)
- [merge-conflicts](https://atom.io/packages/merge-conflicts)
- [go-find-references](https://atom.io/packages/go-find-references)

Please note: For `git-plus` you need your correct git configuration. In my example i mount my `$HOME/.gitconfig` into the container.

## See also
If you don't like atom, you should give  [Visual Studio Code](https://github.com/ulrichSchreiner/vsc) a try.
