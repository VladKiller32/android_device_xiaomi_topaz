#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from topaz device configuration
$(call inherit-product, device/xiaomi/topaz/device.mk)

# Inherit some common LineageOS / crDroid stuff
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

PRODUCT_DEVICE := topaz
PRODUCT_NAME := lineage_topaz
PRODUCT_BRAND := Redmi
PRODUCT_MODEL := Redmi Note 12
PRODUCT_MANUFACTURER := Xiaomi

PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="topaz_global-user 15 AQ3A.240829.003 OS2.0.210.0.VMGMIXM release-keys" \
    BuildFingerprint=Redmi/topaz_global/topaz:15/AQ3A.240829.003/OS2.0.210.0.VMGMIXM:user/release-keys \
    SystemName=topaz_global
