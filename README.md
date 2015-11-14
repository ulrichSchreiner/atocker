# atocker
Atom 1.2 Editor in Docker. 

![Screenshot](screenshot.png)

This docker image contains [atom](http://atom.io), [go-plus](https://github.com/joefitzgerald/go-plus)  and many go tools. The configuration conforms to
[gb](http://getgb.io/), so your project directory should conform to [this](http://getgb.io/docs/project/) layout. If there is no `vendor` directory one will be created!

You can start the editor in the project directory with `atocker`. 

Please note: When using the given start script (or alias) the settings of the editor will be stored in the `.atocker` directory. You should put this directory in the
`.gitignore` file. 

[![Docker Repository on Quay.io](https://quay.io/repository/ulrichschreiner/atocker/status "Docker Repository on Quay.io")](https://quay.io/repository/ulrichschreiner/atocker)

Use the given `atocker` script to start an instance or create an alias:

```
alias atocker='docker run  \
    --rm \
    -v /etc/localtime:/etc/localtime:ro \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v `pwd`:/work \
    -v `pwd`/.atocker:/devhome/.atom \
    -e DISPLAY=$DISPLAY \
    -e HOSTUSER=`id -un` \
    -e HOSTGROUP=`id -gn` \
    -e HOSTUSERID=`id -u` \
    quay.io/ulrichschreiner/atocker'
```

