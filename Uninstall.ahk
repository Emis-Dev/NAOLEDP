#Requires AutoHotkey v2.0
#SingleInstance Force

; ╔══════════════════════════════════════════════════════════════════════════════╗
; ║                         PowerNAPS Uninstaller                                ║
; ╚══════════════════════════════════════════════════════════════════════════════╝

; Request admin if needed
if !A_IsAdmin {
    Run('*RunAs "' . A_ScriptFullPath . '"')
    ExitApp()
}

InstallDir := EnvGet("USERPROFILE") . "\PowerNAPS"
AppDataDir := EnvGet("APPDATA") . "\PowerNAPS"

result := MsgBox("This will uninstall PowerNAPS and remove all files.`n`nContinue?", "PowerNAPS Uninstall", 52)
if result != "Yes"
    ExitApp()

try {
    ; Stop running process
    Run('taskkill /F /IM PowerNAPS.exe /T',, "Hide")
    Sleep(1000)
    
    ; Remove watchdog task
    Run('schtasks /delete /tn "PowerNAPS-Watchdog" /f',, "Hide")
    Sleep(500)
    
    ; Delete installation directory
    if DirExist(InstallDir)
        DirDelete(InstallDir, true)
    
    ; Delete settings (optional - ask user)
    if DirExist(AppDataDir) {
        keepSettings := MsgBox("Keep your settings for future reinstall?", "PowerNAPS Uninstall", 52)
        if keepSettings = "No"
            DirDelete(AppDataDir, true)
    }
    
    MsgBox("PowerNAPS has been uninstalled.", "PowerNAPS Uninstall", 64)
    
} catch as e {
    MsgBox("Uninstall error: " . e.Message, "PowerNAPS Uninstall", 16)
}

ExitApp()
