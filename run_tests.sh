#!/bin/bash

set -e

cabal configure
cabal build
cabal install
raco test -t tests/core.rkt tests/examples.rkt tests/interpreter.rkt tests/typechecker.rkt
