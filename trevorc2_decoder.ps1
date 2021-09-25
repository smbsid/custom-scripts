#PowerShell script to decrypt response for TrevorC2
#
# === Credits to  ===
# TrevorC2 - legitimate looking command and control
# Written by: Dave Kennedy @HackingDave
# Website: https://www.trustedsec.com
# GIT: https://github.com/trustedsec
# PowerShell Module by Alex Williams @offsec_ginger
# ====

$CIPHER = "Tr3v0rC2R0x@nd1s@w350m3#TrevorForget"

function Create-AesManagedObject($key, $IV) {
    $aesManaged = New-Object "System.Security.Cryptography.AesManaged"
    $aesManaged.Mode = [System.Security.Cryptography.CipherMode]::CBC
    $aesManaged.Padding = [System.Security.Cryptography.PaddingMode]::PKCS7
    $aesManaged.BlockSize = 128
    $aesManaged.KeySize = 256
    if ($IV) {
        if ($IV.getType().Name -eq "String") {
            $aesManaged.IV = [System.Convert]::FromBase64String($IV)
        }
        else {
            $aesManaged.IV = $IV
        }
    }
    if ($key) {
        if ($key.getType().Name -eq "String") {
            $aesManaged.Key = [System.Convert]::FromBase64String($key)
        }
        else {
            $aesManaged.Key = $key
        }
    }
    $aesManaged
}
function Create-AesKey() {
    $aesManaged = Create-AesManagedObject
    $hasher = New-Object System.Security.Cryptography.SHA256Managed
    $toHash = [System.Text.Encoding]::UTF8.GetBytes($CIPHER)
    $hashBytes = $hasher.ComputeHash($toHash)
    $final = [System.Convert]::ToBase64String($hashBytes)
    return $final
}
function Encrypt-String($key, $unencryptedString) {
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($unencryptedString)
    $aesManaged = Create-AesManagedObject $key
    $encryptor = $aesManaged.CreateEncryptor()
    $encryptedData = $encryptor.TransformFinalBlock($bytes, 0, $bytes.Length);
    $fullData = $aesManaged.IV + $encryptedData
    [System.Convert]::ToBase64String($fullData)
}
function Decrypt-String($key, $encryptedStringWithIV) {
    $bytes = [System.Convert]::FromBase64String($encryptedStringWithIV)
    $IV = $bytes[0..15]
    $aesManaged = Create-AesManagedObject $key $IV
    $decryptor = $aesManaged.CreateDecryptor();
    $unencryptedData = $decryptor.TransformFinalBlock($bytes, 16, $bytes.Length - 16);
    [System.Text.Encoding]::UTF8.GetString($unencryptedData).Trim([char]0)
}
##Put between the quotes the value of oldcss##
$ENCRYPTED = ''
$key = Create-AesKey
$DECRYPTED = Decrypt-String $key $ENCRYPTED
Write-Output $ENCRYPTED
Write-Output $DECRYPTED
