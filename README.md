# Device Tree: Redmi Note 12 4G NFC (`topaz`) -> Android 17

Чистое монолитное дерево устройства `device/xiaomi/topaz`, собранное с нуля на основе официального дампа **HyperOS 2 (`OS2.0.210.0.VMGMIXM`, Android 15)** и адаптированное под **LineageOS 24 / crDroid 13 (Android 17)**.

## Структура дерева

- `AndroidProducts.mk`, `lineage_topaz.mk`, `Android.mk`, `Android.bp` — описание продукта `lineage_topaz` (`Redmi Note 12`).
- `BoardConfig.mk` — конфигурация железа (`bengal` / SM6225), разметки разделов (`boot`, `init_boot`, `vendor_boot`, `recovery`, `dtbo`, `super`), prebuilt GKI `5.15.194` и модулей (`vendor_boot` + `vendor_dlkm`), AVBv2, VINTF и SELinux.
- `device.mk` — пакеты A/B OTA, `fastbootd`, разрешения железа (включая NFC), оверлеи, скрипты `rootdir` и подключение `vendor/xiaomi/topaz`.
- `props/` — очищенные от HyperOS-мусора `system.prop`, `vendor.prop`, `odm.prop`, `product.prop` (в `system.prop` добавлен доступ для `org.lineageos.aperture` и `com.android.camera` к доп. модулям камеры).
- `rootdir/` — UFS-разметка `fstab.default`, `.rc`-скрипты и `.sh`-скрипты инициализации.
- `vintf/` — `manifest.xml` (целевой уровень `7`) и `framework_compatibility_matrix.xml` для QTI/Xiaomi HAL.
- `prebuilts/` — prebuilt-ядро `5.15.194`, `dtb.img`, `dtbo.img` и все `.ko`-модули из стока (`vendor_boot` и `vendor_dlkm`).
- `overlay/` — оверлей системы (120Hz AMOLED, AoD, боковой сканер отпечатков, VoLTE/IMS).
- `sepolicy/vendor/` — базовые SELinux-контексты для NFC (`STFlashTool`) и сканера отпечатков.
- `proprietary-files.txt`, `extract-files.py`, `setup-makefiles.py` — очищенный список проприетарных бинарников из дампа (без перезаписи системных библиотек Android 17).

## Что сделать на этапе сборки (на арендованном Linux-сервере)

1. **Сервер:** Ubuntu 22.04 или 24.04 x86_64, **32–64 ГБ ОЗУ** (+ swap 32 ГБ), **400–500 ГБ NVMe SSD**.
2. **Уточнить точный размер `super` на твоём телефоне** (в fastboot или adb):
   - `fastboot getvar partition-size:super` (перевести из hex в байты и при необходимости поправить `BOARD_SUPER_PARTITION_SIZE` и `BOARD_XIAOMI_DYNAMIC_PARTITIONS_SIZE` в `BoardConfig.mk`).
3. **Синхронизировать исходники crDroid 13 / LineageOS 24** (`repo init ... && repo sync`).
4. **Поместить это дерево** (без папок `_aospdtgen_draft` и `_dump_info*.txt`) в `device/xiaomi/topaz/`.
5. **Сгенерировать `vendor/xiaomi/topaz` из твоего дампа:**
   ```bash
   cd device/xiaomi/topaz
   chmod +x extract-files.py setup-makefiles.py
   ./extract-files.py /путь/к/распакованному/dump
   ```
6. **Запустить тестовую сборку:**
   ```bash
   source build/envsetup.sh
   breakfast topaz
   mka bacon
   ```
7. **Отладка при первом запуске и камере:**
   - Снимать логи через `adb logcat -b all > logcat.txt` и `adb shell dmesg > dmesg.txt`.
   - Если `checkvintf` или `sepolicy` ругнутся на конкретный HAL/сервис на Android 17 — ошибки правятся точечно в `vintf/` и `sepolicy/vendor/`.
   - Если базовая камера (Aperture) уже запускается, а нужно завести стоковую **MIUICamera** — по логам падений добираются нужные библиотеки/зависимости из `mi_ext` / `system_ext` (или порт MIUICamera для Android 17).
