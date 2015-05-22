#!/bin/bash
set -e
source /build/buildconfig
set -x

## Set configuration
cat <<-EOF | debconf-set-selections
slapd slapd/password1 password ${LDAP_ADMIN_PASSWORD}
slapd slapd/internal/adminpw password ${LDAP_ADMIN_PASSWORD}
slapd slapd/password2 password ${LDAP_ADMIN_PASSWORD}
slapd slapd/internal/generated_adminpw password ${LDAP_ADMIN_PASSWORD}
slapd slapd/move_old_database boolean true
slapd slapd/allow_ldap_v2 boolean false
slapd slapd/dump_database select when needed
slapd slapd/dump_database_destdir string /var/backups/slapd-VERSION
slapd slapd/no_configuration boolean false
slapd shared/organization string ${LDAP_ORGANISATION}
slapd slapd/purge_database boolean false
slapd slapd/domain string ${LDAP_DOMAIN}
slapd slapd/backend select MDB
EOF

## Install slapd
$minimal_apt_get_install slapd

# runit service
mkdir /etc/service/slapd
cp /build/runit/slapd /etc/service/slapd/run

## Remote syslog
cp /build/config/syslog-ng/conf.d/* /etc/syslog-ng/conf.d/