#!/bin/sh

export GOPATH=/devhome/go:/work/vendor:/work 
export GO15VENDOREXPERIMENT=1 

/go/bin/gocode set package-lookup-mode gb

cd /work && atom --foreground .
