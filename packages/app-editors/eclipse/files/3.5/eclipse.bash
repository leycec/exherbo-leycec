#!/usr/bin/env bash
#
# Copyright 2010 Cecil Curry <leycec@gmail.com>
# Distributed under the terms of the GNU General Public License v2
#
# --------------------( SYNOPSIS                           )--------------------
# This script launches Eclipse! The Eclipse exheres fabricated this script for
# your convenience. Therefore, avoid modifying the contents of this script
# directly; rather, queue patches against the Eclipse exheres. :)
#
# --------------------( CONFIGURATION                      )--------------------
# This script pulls its configuration from:
#
#      __ECLIPSE_CONFIG_FILE__
#      __ECLIPSE_ENVIRO_FILE__
#
# If Eclipse performs poorly or otherwise complains, consider modifying the
# minimum and maximum memory the configuration file allocates.

# ....................{ ENVIRONMENT VARIABLES              }....................
if [[ -f   "__ECLIPSE_CONFIG_FILE__" ]]; then
    source "__ECLIPSE_CONFIG_FILE__"
else
    echo "\"__ECLIPSE_CONFIG_FILE__\" not found; assuming default configuration." 1>&2 
fi

if [[ -z "${ECLIPSE_HOME}" ]]; then
	echo "\$ECLIPSE_HOME not set; please see \"__ECLIPSE_ENVIRO_FILE__\"." 1>&2
	exit 1
fi

local ECLIPSE_BIN="${ECLIPSE_HOME}/eclipse"

if [[ ! -x "${ECLIPSE_BIN}" ]]; then
	echo "\"${ECLIPSE_BIN}\" not found or not executable by this user." 1>&2
	exit 1
fi

# Naturally, "gcj" needs a classpath massage.
if [[ "$(eclectic java-jdk show)" == gcj* ]]; then 
    export JAVA_PKG_CLASSMAP="${ECLIPSE_HOME}/eclipse.gcjdb"
fi

local VMARGS=( )
[[ -n "${VMARGS_XMS}"            ]] && VMARGS+=( "-Xms${VMARGS_XMS}" )
[[ -n "${VMARGS_XMX}"            ]] && VMARGS+=( "-Xmx${VMARGS_XMX}" )
[[ -n "${VMARGS_XX_PERMSIZE}"    ]] && VMARGS+=( "-XX:PermSize=${VMARGS_XX_PERMSIZE}" )
[[ -n "${VMARGS_XX_MAXPERMSIZE}" ]] && VMARGS+=( "-XX:MaxPermSize=${VMARGS_XX_MAXPERMSIZE}" )

# ....................{ ECLIPSE!                           }....................
echo "${ECLIPSE_BIN}" "$@" -vmargs "${VMARGS[@]}"
exec "${ECLIPSE_BIN}" "$@" -vmargs "${VMARGS[@]}"

