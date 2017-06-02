#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

stack exec -- latroi ../../lib/Core.l lexer.l parser.l repl.l
