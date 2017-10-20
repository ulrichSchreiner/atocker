# atocker
Atom 1.8 Editor bundled in Docker.

![Screenshot](screenshot.png)

**Please note: I removed all go plugins from this docker image because i use
[VisualStudio Code](https://github.com/ulrichSchreiner/vsc) for my go development.** This Image now uninstalls all `go` plugins because otherwise you will receive errors from the plugins that the needed tools are note installed.


## Configuration
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
    -e DISABLE_GPU="--disable-gpu" \
    quay.io/ulrichschreiner/atocker "$1"
}
alias atm="_atocker"
```
Note: If you have private repositories where you need your SSH keys, start an agent before starting `atocker` and add your keys with `ssh-add`. The agent will be forwarded to the container so the tools to pull inside of atom will work.

## Browser support

The image contains a `chromium-browser` which will be used when clicking on a link. If this does not work and your console shows security problems, you can consider adding the startup options:
```
--security-opt=seccomp:unconfined
```
to the container. Please be aware that it would be better to only allow specific capabilities. But it is real hard to find out what is needed.

If your container complains about problems connecting to dbus, you can add
```
--privileged
```
also.

## GPU Rendering

On many graphics cards the GPU rendering is buggy. You can add the environment `-e DISABLE_GPU="--disable-gpu"` to the container if you have glitches or a black main window.

## Configuration

If you have more than one computer where you regularly working, you can use a service like dropbox to store your configs. In such a case you can start the editor with a config:
```
...
-v $HOME/Dropbox/appconfig:/config \
...
```

Now the configuration of your editor will be stored inside your `appconfig` directory on dropbox. Please note that this can be a lot of space!

Another configuration option is the directory name for your workspace. With the given configuration every directory will be mapped into the `config` directory as a complete path. So for example the directory `/home/myuser/workspace/atocker` will be saved in `/config/home/myuser/workspace/atocker`. This will be ok most of the time. But if you are using different computers and on them different userid's the part `myuser` will be different on every computer.

In this case, i'm using dropbox to sync my configuration and i also change the `WORKSPACE` variable to this:
```
-e WORKSPACE=`pwd | cut --complement -d / -n -f 2,3` \
```
so now the part with `/home/myuser` will be cut of and my workspace path does not include my userid.

## Notes
Please note: For `git` you need your correct git configuration. In my example i mount my `$HOME/.gitconfig` into the container.

## See also
If you don't like atom, you should give  [Visual Studio Code](https://github.com/ulrichSchreiner/vsc) a try.
