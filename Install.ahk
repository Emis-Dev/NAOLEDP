#Requires AutoHotkey v2.0
#SingleInstance Force

; ╔══════════════════════════════════════════════════════════════════════════════╗
; ║                         PowerNAPS Installer                                  ║
; ╚══════════════════════════════════════════════════════════════════════════════╝

; Request admin if needed
if !A_IsAdmin {
    try Run('*RunAs "' . A_ScriptFullPath . '"')
    ExitApp()
}

InstallDir := EnvGet("USERPROFILE") . "\PowerNAPS"
AppDataDir := EnvGet("APPDATA") . "\PowerNAPS"
ScriptDir := A_ScriptDir
ErrorMsg := ""

; Show progress
MsgBox("PowerNAPS Installer`n`nMakes your computer take tiny naps!`n`nClick OK to install to:`n" . InstallDir, "PowerNAPS Setup", 64)

; Create directories (ignore if exist)
try DirCreate(InstallDir)
try DirCreate(InstallDir . "\assets")
try DirCreate(AppDataDir)
try DirCreate(AppDataDir . "\assets")

; Copy main exe
ExePath := ScriptDir . "\PowerNAPS.exe"
if FileExist(ExePath) {
    try FileCopy(ExePath, InstallDir . "\PowerNAPS.exe", true)
} else {
    ErrorMsg := "PowerNAPS.exe not found in " . ScriptDir
}

; Copy icon (optional, ignore errors)
IcoPath := ScriptDir . "\assets\powernaps-icon.ico"
if FileExist(IcoPath) {
    try FileCopy(IcoPath, InstallDir . "\assets\powernaps-icon.ico", true)
    try FileCopy(IcoPath, AppDataDir . "\assets\powernaps-icon.ico", true)
}

; Register and ENABLE watchdog task by default
XmlPath := ScriptDir . "\install\PowerNAPS-Watchdog.xml"
if FileExist(XmlPath) {
    try RunWait('schtasks /delete /tn "PowerNAPS-Watchdog" /f',, "Hide")
    try RunWait('schtasks /create /tn "PowerNAPS-Watchdog" /xml "' . XmlPath . '"',, "Hide")
    try RunWait('schtasks /change /tn "PowerNAPS-Watchdog" /enable',, "Hide")
}

; Start PowerNAPS
Sleep(500)
try Run(InstallDir . "\PowerNAPS.exe")

; Show result with full feature explanation
if (ErrorMsg = "") {
    helpText := "
    (
Installation complete! PowerNAPS is now running.

Not Another Protector of Screens - OLED Protection
Makes your computer take tiny naps, increasing longevity
and decreasing electricity bills.

═══════════════════════════════════════
FEATURES:
═══════════════════════════════════════

⏱️ TIMER
Inactivity timeout before nap activates.
❤️ Default: 15 minutes

🎯 WAKE TRIGGERS
What can wake the screen:
• Mouse/Keyboard/Gamepad input
• Sound (microphone activity)
• Schedule (disable naps during work hours)

🌑 DARKNESS
Screen dimming level during nap.
❤️ Default: 100% (full OLED protection)
Lower = energy saver mode (less protection)

🔄 WATCHDOG (auto-start)
Ensures PowerNAPS starts with Windows.
❤️ Default: Enabled

═══════════════════════════════════════
HOTKEYS:
═══════════════════════════════════════
• Alt+P = Instant nap
• Ctrl+Alt+Scroll = Adjust darkness
• Alt+Shift+P = Hardware standby

Right-click the tray icon to configure!
    )"
    MsgBox(helpText, "PowerNAPS Setup", 64)
} else {
    MsgBox("Installation had issues:`n`n" . ErrorMsg, "PowerNAPS Setup", 48)
}

ExitApp()
