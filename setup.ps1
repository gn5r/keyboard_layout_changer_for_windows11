function Copy-Current-Hardware-Keyboad-Layout($filename) {
  Write-Host "現在のハードウェアキーボードレイアウトのレジストリのバックアップを作成します"
  $ymdhms = Get-Date -UFormat "%Y%m%d%H%M%S"
  reg export HKLM\SYSTEM\CurrentControlSet\Services\i8042prt\Parameters $ymdhms"_"$filename
}

function Update-Hardware-Keyboad-Layout() {
  $HKLM_HARDWARE_KEYBOARD_LAYOUT_PATH = "HKLM:\SYSTEM\CurrentControlSet\Services\i8042prt\Parameters"
  $hardware_keyboard_layout = Get-ItemProperty -Path $HKLM_HARDWARE_KEYBOARD_LAYOUT_PATH

  if (($null -ne $hardware_keyboard_layout.'LayerDriver JPN') -and ($null -ne $hardware_keyboard_layout.OverrideKeyboardIdentifier) -and ($hardware_keyboard_layout.OverrideKeyboardType -eq 7) -and ($hardware_keyboard_layout.OverrideKeyboardSubtype -eq 2)) {
    Write-Host "ハードウェアキーボードレイアウトを「日本語キーボード(106/109)」から「接続済みキーボードレイアウトを使用する」に変更します"
    Remove-ItemProperty -Path $HKLM_HARDWARE_KEYBOARD_LAYOUT_PATH -Name "LayerDriver JPN"
    Remove-ItemProperty -Path $HKLM_HARDWARE_KEYBOARD_LAYOUT_PATH -Name "OverrideKeyboardIdentifier"
    Remove-ItemProperty -Path $HKLM_HARDWARE_KEYBOARD_LAYOUT_PATH -Name "OverrideKeyboardType"
    Remove-ItemProperty -Path $HKLM_HARDWARE_KEYBOARD_LAYOUT_PATH -Name "OverrideKeyboardSubtype"
    Write-Host "変更しました"
  }
}

function Add-PS2-Keyboard-Layout() {
  Write-Host "内臓キーボードのキーボードレイアウトを固定します"
  $HKLM_DEVICE_INSTANCE_PATH_PREFIX = "HKLM:\SYSTEM\CurrentControlSet\Enum\"
  $device_instance_path = Get-WmiObject -Class Win32_Keyboard | Select-Object -ExpandProperty DeviceID | Select-String ACPI
  $HKLM_DEVICE_INSTANCE_PATH = "$HKLM_DEVICE_INSTANCE_PATH_PREFIX$device_instance_path\Device Parameters"

  if ($null -eq (Get-ItemProperty -Path $HKLM_DEVICE_INSTANCE_PATH).OverrideKeyboardType) {
    Write-Host "内臓キーボードのOverrideKeyboardTypeを作成します"
    New-ItemProperty -Path $HKLM_DEVICE_INSTANCE_PATH -Name "OverrideKeyboardType" -PropertyType "DWORD" -Value 7
    Write-Host "作成しました"
  }

  if ($null -eq (Get-ItemProperty -Path $HKLM_DEVICE_INSTANCE_PATH).OverrideKeyboardSubtype) {
    Write-Host "内臓キーボードのOverrideKeyboardSubtypeを作成します"
    New-ItemProperty -Path $HKLM_DEVICE_INSTANCE_PATH -Name "OverrideKeyboardSubtype" -PropertyType "DWORD" -Value 2
    Write-Host "作成しました"
  }
}

Copy-Current-Hardware-Keyboad-Layout before_hardware_keyboard_layout.reg
Update-Hardware-Keyboad-Layout
Add-PS2-Keyboard-Layout
Copy-Current-Hardware-Keyboad-Layout after_hardware_keyboard_layout.reg

Write-Host "レジストリの設定が完了しました。再起動をしてキーボードレイアウトが変更されているか確認してください"