#!/bin/bash
#
# Copyright (C) 2018 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=beryllium
VENDOR=xiaomi

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$MY_DIR" ]]; then MY_DIR="$PWD"; fi

LINEAGE_ROOT="$MY_DIR"/../../..

HELPER="$LINEAGE_ROOT"/vendor/lineage/build/tools/extract_utils.sh
if [ ! -f "$HELPER" ]; then
    echo "Unable to find helper script at $HELPER"
    exit 1
fi
. "$HELPER"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

while [ "$1" != "" ]; do
    case $1 in
        -n | --no-cleanup )     CLEAN_VENDOR=false
                                ;;
        -s | --section )        shift
                                SECTION=$1
                                CLEAN_VENDOR=false
                                ;;
        * )                     SRC=$1
                                ;;
    esac
    shift
done

if [ -z "$SRC" ]; then
    SRC=adb
fi

# Initialize the helper for common device
setup_vendor "$DEVICE" "$VENDOR" "$LINEAGE_ROOT" true "$CLEAN_VENDOR"

extract "$MY_DIR"/proprietary-files.txt "$SRC" "$SECTION"

BLOB_ROOT="$LINEAGE_ROOT"/vendor/"$VENDOR"/"$DEVICE"/proprietary

# Using in vendor libgui for Xiaomi displayfeature HAL
sed -i "s|libgui.so|libPui.so|g" "$BLOB_ROOT"/vendor/lib/hw/displayfeature.default.so
sed -i "s|libgui.so|libPui.so|g" "$BLOB_ROOT"/vendor/lib64/hw/displayfeature.default.so

sed -i "s|libbufferhubqueue.so|libPufferhubqueue.so|g" "$BLOB_ROOT"/vendor/lib/libPui.so
sed -i "s|libbufferhubqueue.so|libPufferhubqueue.so|g" "$BLOB_ROOT"/vendor/lib64/libPui.so

sed -i "s|libpdx_default_transport.so|libPdx_default_transport.so|g" "$BLOB_ROOT"/vendor/lib/libPufferhubqueue.so
sed -i "s|libpdx_default_transport.so|libPdx_default_transport.so|g" "$BLOB_ROOT"/vendor/lib64/libPufferhubqueue.so

sed -i "s|libpdx_default_transport.so|libPdx_default_transport.so|g" "$BLOB_ROOT"/vendor/lib/libPui.so
sed -i "s|libpdx_default_transport.so|libPdx_default_transport.so|g" "$BLOB_ROOT"/vendor/lib64/libPui.so

#
# Correct android.hidl.manager@1.0-java jar name
#
sed -i "s|name=\"android.hidl.manager-V1.0-java|name=\"android.hidl.manager@1.0-java|g" \
    "$BLOB_ROOT"/etc/permissions/qti_libpermissions.xml

"$MY_DIR"/setup-makefiles.sh
