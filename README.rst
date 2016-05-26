=====
Latro
=====

:Author: James Swaine <james.swaine@gmail.com>

Latro is a general-purpose functional programming language designed
to make people more productive.

.. contents::

.. _Re2: https://github.com/google/re2/wiki/Syntax

Overview
========

Overview here

Examples
========

Examples here

Example 1
---------

::

  1 + 1

This is 1 + 1.

Example 2
---------

::

  "hello world"

This is a hello world string.

Running the interpreter
=======================


::

  $> latro [OPTIONS] <file1> <file2> ...

Runs the interpreter on the program given in the files.

Switches:

--help                Display help information.
-p                    Don't evaluate, just dump a parse tree.
-a                    Don't evaluate, just dump an alpha-converted syntax tree.
-t                    Don't evaluate, just dump a type-annotated syntax tree.
-tc                   Don't evaluate, just display the type of the last expression in the executed module.
