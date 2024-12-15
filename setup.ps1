function Copy-Current-Hardware-Keyboad-Layout($filename) {
  Write-Host "���݂̃n�[�h�E�F�A�L�[�{�[�h���C�A�E�g�̃��W�X�g���̃o�b�N�A�b�v���쐬���܂�"
  $ymdhms = Get-Date -UFormat "%Y%m%d%H%M%S"
  reg export HKLM\SYSTEM\CurrentControlSet\Services\i8042prt\Parameters $ymdhms"_"$filename
}

function Update-Hardware-Keyboad-Layout() {
  $HKLM_HARDWARE_KEYBOARD_LAYOUT_PATH = "HKLM:\SYSTEM\CurrentControlSet\Services\i8042prt\Parameters"
  $hardware_keyboard_layout = Get-ItemProperty -Path $HKLM_HARDWARE_KEYBOARD_LAYOUT_PATH

  if (($null -ne $hardware_keyboard_layout.'LayerDriver JPN') -and ($null -ne $hardware_keyboard_layout.OverrideKeyboardIdentifier) -and ($hardware_keyboard_layout.OverrideKeyboardType -eq 7) -and ($hardware_keyboard_layout.OverrideKeyboardSubtype -eq 2)) {
    Write-Host "�n�[�h�E�F�A�L�[�{�[�h���C�A�E�g���u���{��L�[�{�[�h(106/109)�v����u�ڑ��ς݃L�[�{�[�h���C�A�E�g���g�p����v�ɕύX���܂�"
    Remove-ItemProperty -Path $HKLM_HARDWARE_KEYBOARD_LAYOUT_PATH -Name "LayerDriver JPN"
    Remove-ItemProperty -Path $HKLM_HARDWARE_KEYBOARD_LAYOUT_PATH -Name "OverrideKeyboardIdentifier"
    Remove-ItemProperty -Path $HKLM_HARDWARE_KEYBOARD_LAYOUT_PATH -Name "OverrideKeyboardType"
    Remove-ItemProperty -Path $HKLM_HARDWARE_KEYBOARD_LAYOUT_PATH -Name "OverrideKeyboardSubtype"
    Write-Host "�ύX���܂���"
  }
}

function Add-PS2-Keyboard-Layout() {
  Write-Host "�����L�[�{�[�h�̃L�[�{�[�h���C�A�E�g���Œ肵�܂�"
  $HKLM_DEVICE_INSTANCE_PATH_PREFIX = "HKLM:\SYSTEM\CurrentControlSet\Enum\"
  $device_instance_path = Get-WmiObject -Class Win32_Keyboard | Select-Object -ExpandProperty DeviceID | Select-String ACPI
  $HKLM_DEVICE_INSTANCE_PATH = "$HKLM_DEVICE_INSTANCE_PATH_PREFIX$device_instance_path\Device Parameters"

  if ($null -eq (Get-ItemProperty -Path $HKLM_DEVICE_INSTANCE_PATH).OverrideKeyboardType) {
    Write-Host "�����L�[�{�[�h��OverrideKeyboardType���쐬���܂�"
    New-ItemProperty -Path $HKLM_DEVICE_INSTANCE_PATH -Name "OverrideKeyboardType" -PropertyType "DWORD" -Value 7
    Write-Host "�쐬���܂���"
  }

  if ($null -eq (Get-ItemProperty -Path $HKLM_DEVICE_INSTANCE_PATH).OverrideKeyboardSubtype) {
    Write-Host "�����L�[�{�[�h��OverrideKeyboardSubtype���쐬���܂�"
    New-ItemProperty -Path $HKLM_DEVICE_INSTANCE_PATH -Name "OverrideKeyboardSubtype" -PropertyType "DWORD" -Value 2
    Write-Host "�쐬���܂���"
  }
}

Copy-Current-Hardware-Keyboad-Layout before_hardware_keyboard_layout.reg
Update-Hardware-Keyboad-Layout
Add-PS2-Keyboard-Layout
Copy-Current-Hardware-Keyboad-Layout after_hardware_keyboard_layout.reg

Write-Host "���W�X�g���̐ݒ肪�������܂����B�ċN�������ăL�[�{�[�h���C�A�E�g���ύX����Ă��邩�m�F���Ă�������"