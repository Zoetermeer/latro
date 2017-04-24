#!/bin/bash

set -e

stack build
raco test -t tests/core.rkt tests/scoping.rkt tests/interpreter.rkt tests/typechecker.rkt tests/examples.rkt
