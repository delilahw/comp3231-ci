#!/usr/bin/env bash
# shellcheck disable=SC2164
set -e

# User-level programs
echo "::group::Build userland"
cd "$ASST_PATH"
./configure
bmake
bmake install
echo "::endgroup::"

# Configure kernel
echo "::group::Configure kernel"
cd "$ASST_PATH"/kern/conf
./config "$ASST_NAME"
echo "::endgroup::"

# Compile kernel
echo "::group::Build kernel"
cd "$ASST_PATH"
"$ASST_PATH"/run.sh compile install-kernel
echo "::endgroup::"

# Get conf
echo "::group::Get system config"
mkdir -p "$CS_PATH"/root
cd "$CS_PATH"/root
wget http://cgi.cse.unsw.edu.au/~cs3231/21T1/assignments/asst2/sys161.conf
echo "::endgroup::"
