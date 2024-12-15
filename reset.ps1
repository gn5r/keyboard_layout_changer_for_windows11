function Reset-Hardware-Keyboard-Layout() {
  Write-Host "ハードウェアキーボードレイアウトを「日本語キーボード(106/109)」にリセットします"
  $HKLM_HARDWARE_KEYBOARD_LAYOUT_PATH = "HKLM:\SYSTEM\CurrentControlSet\Services\i8042prt\Parameters"

  New-ItemProperty -Path $HKLM_HARDWARE_KEYBOARD_LAYOUT_PATH -Name "LayerDriver JPN" -Value "kbd106.dll"
  New-ItemProperty -Path $HKLM_HARDWARE_KEYBOARD_LAYOUT_PATH -Name "OverrideKeyboardIdentifier" -Value "PCAT_106KEY"
  New-ItemProperty -Path $HKLM_HARDWARE_KEYBOARD_LAYOUT_PATH -Name "OverrideKeyboardType" -PropertyType "DWORD" -Value 7
  New-ItemProperty -Path $HKLM_HARDWARE_KEYBOARD_LAYOUT_PATH -Name "OverrideKeyboardSubtype" -PropertyType "DWORD" -Value 2
}

function Remove-PS2-Keyboard-Layout() {
  Write-Host "内臓キーボードのキーボードレイアウトを固定します"
  $HKLM_DEVICE_INSTANCE_PATH_PREFIX = "HKLM:\SYSTEM\CurrentControlSet\Enum\"
  $device_instance_path = Get-WmiObject -Class Win32_Keyboard | Select-Object -ExpandProperty DeviceID | Select-String ACPI

  $HKLM_DEVICE_INSTANCE_PATH = "$HKLM_DEVICE_INSTANCE_PATH_PREFIX$device_instance_path\Device Parameters"

  Remove-ItemProperty -Path $HKLM_DEVICE_INSTANCE_PATH -Name "OverrideKeyboardType"
  Remove-ItemProperty -Path $HKLM_DEVICE_INSTANCE_PATH -Name "OverrideKeyboardSubType"
}

Reset-Hardware-Keyboard-Layout
Remove-PS2-Keyboard-Layout

Write-Host "レジストリのリセットが完了しました。再起動をしてキーボードレイアウトが変更されているか確認してください"