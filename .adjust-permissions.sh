#!/usr/bin/env bash

git ls-tree HEAD | cut -f 2 | xargs chmod 0600
