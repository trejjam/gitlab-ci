#!/bin/bash

set -e

if [[ ! -d ~/.ssh ]]; then
	mkdir ~/.ssh
fi

chmod 700 ~/.ssh

cd ~/.ssh
echo "${KNOWN_HOSTS}" >> known_hosts && \
echo "${DEPLOY_KEY}" >> id_rsa
chmod 600 id_rsa
