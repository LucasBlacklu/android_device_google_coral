#!/bin/bash
#
# SPDX-FileCopyrightText: 2016 The CyanogenMod Project
# SPDX-FileCopyrightText: 2017-2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=coral
VENDOR=google

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../../.."

export TARGET_ENABLE_CHECKELF=true

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

function vendor_imports() {
    cat <<EOF >>"$1"
		"hardware/google/interfaces",
		"hardware/google/pixel",
		"hardware/qcom/sm8150/display",
		"hardware/qcom/sm8150/gps",
		"hardware/qcom/wlan/legacy",
		"vendor/qcom/opensource/display"
EOF
}

# Initialize the helper
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}"

# Warning headers and guards
write_headers

write_makefiles "${MY_DIR}/proprietary-files.txt"
write_makefiles "${MY_DIR}/proprietary-files-carriersettings.txt"
write_makefiles "${MY_DIR}/proprietary-files-vendor.txt"

append_firmware_calls_to_makefiles "${MY_DIR}/proprietary-firmware.txt"

# Finish
write_footers
