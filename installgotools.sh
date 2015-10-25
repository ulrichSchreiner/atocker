#!/bin/sh

mkdir -p /devhome/go 
mkdir -p /devhome/go/bin 
mkdir -p /devhome/go/src 
mkdir -p /devhome/go/pkg

/usr/local/go/bin/go get -u \
    github.com/nsf/gocode \
    github.com/golang/lint/golint \
    golang.org/x/tools/cmd/goimports \
    github.com/constabulary/gb/...
