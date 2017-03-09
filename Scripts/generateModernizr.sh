#!/bin/sh

set -e

# run from www
node_modules/.bin/modernizr --config ../modernizr-config.json --dest js/modernizr.js
