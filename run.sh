#!/bin/bash
set -e
stack build
stack exec albellipdf-exe
echo "Done running"
