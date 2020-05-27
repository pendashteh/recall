#!/usr/bin/env bash

function __recall {
  __cmd__=$@
  __filename__=$(__recall__filename --)
  if [ -e $__filename__ ]; then
      __recall__load --
  else
      __recall__register --
      __recall__load --
  fi
}

function __recall__puton {
  __datadir__=$HOME/.recall/data
  mkdir -p $__datadir__
  cd $__datadir__
  if [ ! -d '.git' ]; then
      git init
      git commit -m'Recall data repository' --allow-empty
  fi
}

function __recall__load {
    if [ ! "$1" = '--' ]; then
	__cmd__=$@
	__filename__=$(__recall__filename --)
    fi
    cat $__filename__
}

function __recall__filename {
    if [ ! "$1" = '--' ]; then
	__cmd__=$@
    fi
    local filename=${__cmd__//[^a-zA-Z0-9._-]/_}
    case $filename in
	.|..)
	    filename='_'
	    ;;
    esac
    echo $filename
}

function __recall__register {
    if [ ! "$1" = '--' ]; then
	__cmd__=$@
	__filename__=$(__recall__filename --)
    fi
    $__cmd__ > $__filename__
    git add $__filename__
    git commit -m"registers $__cmd__"
}

__recall__puton

__recall $@

