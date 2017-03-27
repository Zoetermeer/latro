#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

stack exec -- latroi ../../lib/Core.l rope.l tests.l
