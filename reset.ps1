function Reset-Hardware-Keyboard-Layout() {
  Write-Host "�n�[�h�E�F�A�L�[�{�[�h���C�A�E�g���u���{��L�[�{�[�h(106/109)�v�Ƀ��Z�b�g���܂�"
  $HKLM_HARDWARE_KEYBOARD_LAYOUT_PATH = "HKLM:\SYSTEM\CurrentControlSet\Services\i8042prt\Parameters"

  New-ItemProperty -Path $HKLM_HARDWARE_KEYBOARD_LAYOUT_PATH -Name "LayerDriver JPN" -Value "kbd106.dll"
  New-ItemProperty -Path $HKLM_HARDWARE_KEYBOARD_LAYOUT_PATH -Name "OverrideKeyboardIdentifier" -Value "PCAT_106KEY"
  New-ItemProperty -Path $HKLM_HARDWARE_KEYBOARD_LAYOUT_PATH -Name "OverrideKeyboardType" -PropertyType "DWORD" -Value 7
  New-ItemProperty -Path $HKLM_HARDWARE_KEYBOARD_LAYOUT_PATH -Name "OverrideKeyboardSubtype" -PropertyType "DWORD" -Value 2
}

function Remove-PS2-Keyboard-Layout() {
  Write-Host "�����L�[�{�[�h�̃L�[�{�[�h���C�A�E�g���Œ肵�܂�"
  $HKLM_DEVICE_INSTANCE_PATH_PREFIX = "HKLM:\SYSTEM\CurrentControlSet\Enum\"
  $device_instance_path = Get-WmiObject -Class Win32_Keyboard | Select-Object -ExpandProperty DeviceID | Select-String ACPI

  $HKLM_DEVICE_INSTANCE_PATH = "$HKLM_DEVICE_INSTANCE_PATH_PREFIX$device_instance_path\Device Parameters"

  Remove-ItemProperty -Path $HKLM_DEVICE_INSTANCE_PATH -Name "OverrideKeyboardType"
  Remove-ItemProperty -Path $HKLM_DEVICE_INSTANCE_PATH -Name "OverrideKeyboardSubType"
}

Reset-Hardware-Keyboard-Layout
Remove-PS2-Keyboard-Layout

Write-Host "���W�X�g���̃��Z�b�g���������܂����B�ċN�������ăL�[�{�[�h���C�A�E�g���ύX����Ă��邩�m�F���Ă�������"