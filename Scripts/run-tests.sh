#!/bin/bash

set -e

export PHP_IDE_CONFIG="serverName=_"

Application/vendor/bin/tester -p php -c Application/tests/php.unix.ini tests
