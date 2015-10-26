# atocker
Atom Editor in Docker (with go Dev Tools installed)

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
    quay.io/ulrichschreiner/atocker >/dev/null 2>&1'
```

