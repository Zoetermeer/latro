#!/bin/bash

set -e

stack build
raco test -t tests/core.rkt tests/examples.rkt tests/interpreter.rkt tests/typechecker.rkt
