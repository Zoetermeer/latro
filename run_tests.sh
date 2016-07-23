#!/bin/bash

set -e

cabal configure
cabal build
cabal install
raco test -t tests/interpreter.rkt
raco test -t examples/monads
raco test -t examples/rope
# raco test -t tests
