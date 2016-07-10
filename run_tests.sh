#!/bin/bash

cabal configure
cabal build
cabal install
raco test -t tests
