# atock
Atom Editor in Docker (with go Dev Tools installed)

Use the given `atock` script to start an instance or create an alias:

```
alias atocker='docker run  \
    --rm \
    -v /etc/localtime:/etc/localtime:ro \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v `pwd`:/work \
    -v `pwd`/.atock:/devhome/.atom \
    -e DISPLAY=$DISPLAY \
    -e HOSTUSER=`id -un` \
    -e HOSTGROUP=`id -gn` \
    ulrichschreiner/atock >/dev/null 2>&1'
```

