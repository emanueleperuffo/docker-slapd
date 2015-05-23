#!/bin/bash
set -e
source /build/buildconfig
set -x

## Install slapd
$minimal_apt_get_install slapd ldap-utils

# runit service
mkdir /etc/service/slapd
cp /build/runit/slapd /etc/service/slapd/run

## Remote syslog
cp /build/config/syslog-ng/conf.d/* /etc/syslog-ng/conf.d/