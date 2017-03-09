#!/bin/sh

set -e

# run from project root
cp -R Config/nginx Application/

mkdir Application/bin
cp -R Scripts/* Application/bin/
