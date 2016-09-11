;##############################################################################
; Loading ahk when system starup
; just set this one ahk file to 
; HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
; to keep the rest ahk file run in priority
;##############################################################################

run, %A_ScriptDir%\WindowHook.ahk
run, %A_ScriptDir%\Brightness.ahk
run, %A_ScriptDir%\Main.ahk

ExitApp