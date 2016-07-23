#!/bin/bash

set -e

cabal configure
cabal build
cabal install
raco test -t tests/interpreter.rkt
raco test -t tests/core.rkt
raco test -t tests/examples.rkt
# raco test -t tests
