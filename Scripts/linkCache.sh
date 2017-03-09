#!/bin/bash

set -e

mkdir -p /cache/composer
mkdir -p /cache/root_home_cache

rm -rf /root/.composer /root/.cache

ln -s /cache/composer /root/.composer
ln -s /cache/root_home_cache /root/.cache
