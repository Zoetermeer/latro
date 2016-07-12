#!/bin/bash

set -e

cabal configure
cabal build
cabal install
raco test -t tests
