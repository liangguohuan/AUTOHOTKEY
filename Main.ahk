; 1)'=' and ':=' between different: ':=' Evaluates an expression and stores the result in a variable.
; Example:
;   Rx = 128
;   Ry = 128
;   Zx := Rx/zoom
;   Zy := Ry/zoom
;
; 2)variables can be easy ref just use one '%', see below equal expr: 
;   Gui Show, % "w" width " h" height " x" left " y" top, Magnifier
;   Gui Show, w%width% h%height% x%left% y%top%, Magnifier
;
; 3)starup registe
; RegWrite, REG_SZ, HKEY_LOCAL_MACHINE
;                 , SOFTWARE\Microsoft\Windows\CurrentVersion\Run
;                 , Main, % A_ScriptDir "\Main.ahk"
;
; 4)Flow of control: one line can ignore {}, more line must use {} to wrap codes, 
; and variables dont need '%' but string must be wrap with ""
#NoEnv
#SingleInstance force

; SetTitleMatchMode, 2

; setting Icon
Menu, Tray, Icon, D:\Pictures\icon\smile.ico, , 1

;############################################################################
; common program to be starup
; NOTICE: must code here, any 'return' expr before here will prevent run.
;############################################################################
IfWinNotExist ahk_class VirtualConsoleClass
; Run, "C:\Users\liang\.babun\cygwin\bin\mintty.exe"
; Run, "C:\Users\liang\.babun\babun.bat"
Run, "C:\cmder\Cmder.exe"

; with 'ahk_exe explorer.exe' will be not effected, why? 
; now i known: because more then one 'ahk_exe explorer.exe' have been started when system boot.
IfWinNotExist ahk_class CabinetWClass
Run, explorer.exe, , Max,  

IfWinNotExist ahk_exe Lingoes.exe
Run, "C:\Program Files (x86)\Lingoes\Translator2\Lingoes.exe", , Min, 

IfWinNotExist ahk_exe chrome.exe
Run, "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe", , Max, 

IfWinNotExist ahk_exe sublime_text.exe
{
    Run, "D:\Program Files\Sublime Text 3x64\sublime_text.exe", , Max, 
    ToggleTitleMenuBar("PX_WINDOW_CLASS", 1, 0)
}

;############################################################################
; addition menus
;############################################################################
Menu, tray, add
Menu, tray, add, ScrapyScreenInfo, ScrapyScreenInfoHandler
Menu, tray, add, SearchTheStartMenu, SearchTheStartMenuHandler
Menu, tray, add, Magnifier, MagnifierHandler
Menu, tray, add, RunZ, RunZHandler
Menu, tray, add
Menu, tray, add, Regscanner, RegscannerHandler
Menu, tray, add, Smsniff, SmsniffHandler
Menu, tray, add, Specialfoldersview, SpecialfoldersviewHandler
Menu, tray, add, Renamer, RenamerHandler
Menu, tray, add, RenGod, RenGodHandler
return

SearchTheStartMenuHandler:
Run, %A_ScriptDir%\SearchTheStartMenu\SearchTheStartMenu.ahk
return

ScrapyScreenInfoHandler:
Run, %A_ScriptDir%\ScrapyScreenInfo\ScrapyScreenInfo.ahk
return

MagnifierHandler:
Run, %A_ScriptDir%\Magnifier\Magnifier.ahk
return

RunZHandler:
Run, %A_ScriptDir%\RunZ\RunZ.ahk
return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SmsniffHandler:
Run, "D:\Program Files\Tools\smsniff\smsniff.exe"
return

RegscannerHandler:
Run, "D:\Program Files\Tools\regscanner\RegScanner.exe"
return

SpecialfoldersviewHandler:
Run, "D:\Program Files\Tools\specialfoldersview\SpecialFoldersView.exe"
return

RenamerHandler:
Run, "D:\Program Files\Tools\renamer\Renamer.exe"
return

RenGodHandler:
Run, "D:\Program Files\Tools\RenGod\RenGod.exe"
WinWait, ahk_exe RenGod.exe, , 3
WinMove, A, , 183, 32, 1168, 667
return

;############################################################################
; incldue common files
;############################################################################
#Include, %A_ScriptDir%\Functions.ahk 

;############################################################################
; bind keys
;############################################################################
F11::ToggleFakeFullScreen()

; toggle window title bar and menu bar.
#h::
    ; specail handle
    WinGetclass, winclass, A
    if winclass in PX_WINDOW_CLASS
    {
        WinGet, ahkid, ID, ahk_class PX_WINDOW_CLASS
        ToggleTitleMenuBar(ahkid, 1, 0)
    }
    else
        ToggleTitleMenuBar()
return

; toggle window max size.
#w::
ToggleWinMinMax()
return

:*:opencmd::
Run, % ComSpec
return

:*:openappdata::
Run, % A_AppData
return

:*:openpylib::
Run, "C:\Python27\Lib\site-packages"
return

:*:openqudong::
Run, "C:\Program Files (x86)\MyDrivers\DriverGenius\drivergenius.exe"
return

:*:openahk::
RegRead, ahkPath, HKEY_LOCAL_MACHINE, SOFTWARE\AutoHotkey, InstallDir
Run, % ahkPath
return

; press ahkhelp to open autohotkey's en-help
:*:ahkhelp::
RegRead, ahkPath, HKEY_LOCAL_MACHINE, SOFTWARE\AutoHotkey, InstallDir
Run, % ahkPath "\AutoHotkey-en.chm"
return

; win+PrintScreen: close screen
#PrintScreen::
KeyWait PrintScreen ; Tirgger the cmd below until the key 'left win' has been released
KeyWait LWin        ; Tips: 0x112:WM_SYSCOMMAND, 0xF170:SC_MONITORPOWER, 2: close, -1: recover
SendMessage, 0x112, 0xF170, 2, , Program Manager
return

#f::    ; win+f: open Everything
Run, "C:\Program Files\Everything\Everything.exe"
return

#a::    ; open SystemPropertiesAdvanced
Run, SystemPropertiesAdvanced.exe 
return 

#n::Send #t    ; remap win+t, replace it to open TaskManagerWindow
#t::    ; open TaskManagerWindow
Run, taskmgr.exe 
return

#c::
WinGetClass, winclass, A, 
if ( winclass = "Afx:400000:0" ) {
    Send !{F4}
} else {
    Run, "C:\Program Files (x86)\Lingoes\Translator2\Lingoes.exe"
}
return

~LButton & t::
WinSet, AlwaysOnTop, Toggle, A, , , 
return

>^c:: 
Run, colorcpl.exe
return 

>^x:: 
Run, "C:\xampp\xampp-control.exe"
return 

>^p:: 
Run, "C:\Program Files (x86)\360\360safe\SoftMgr\SoftMgr.exe" "/start=desktop"
return 

>^m:: ; /+/+m+space
Run, "C:\Program Files (x86)\Netease\CloudMusic\cloudmusic.exe"
return

>^h::
MyDocuments = %A_MyDocuments%
StringReplace, MyHome, MyDocuments, Documents, , 
Run, %MyHome%, , Max, 
return

>^l::
Run, %A_MyDocuments%\latest, , Max, 
return

; open current program dir
~LButton & s::    ; hold left click, then press alt
WinGet, ProcessPath, ProcessPath, A
Run, % "explorer.exe /select, " ProcessPath
return

; hotstring map, press abbreviation chars then space, 
; tips: input upper chars will translation all char to be upper case
:*:setcopy:: ; input string from latest copy, very useful for vim command line
sendinput, %clipboard%
return
; oneline example
:*:mygmail::liangguohuan@gmail.com
; multiple lines example
::multiplelines::
(
Tornado is a Python web framework and asynchronous networking library, originally developed at 
FriendFeed. By using non-blocking network I/O, Tornado can scale to tens of thousands of open 
connections, making it ideal for long polling, WebSockets, and other applications that require 
a long-lived connection to each user.
)
return

; press Esc twice to close current window
~Esc::
    if (A_PriorHotkey <> "~Esc" or A_TimeSincePriorHotkey > 400)
    {  
        ; Too much time between presses, so this isn't a double-press.  
        KeyWait, Esc
        return
    }
    WinGetClass, winclass, A
    if winclass in SkinWindowClass
        Send ^q
    else
        Send !{F4}
    ; specail handle
    if winclass in Vim
        WinHide, GvimWinShadow
return

; color picker
>^i::
ColorCopyMousePos()
return

; reload the script
reload the script
#z::
ToolTip, ToolTip: Main Script Reload, 660, 600, 
sleep 500
Reload
return

;############################################################################
; keys remap
; Notice: must add '$', Otherwise it will conflict with the menubar
;############################################################################
$!c::Send ^c
$!x::Send ^x
$!v::Send ^v
$!u::Send {PgUp}
$!d::Send {PgDn}
$!a::Send {Home}
$!e::Send {End}
$!j::Send {left}
$!l::Send {right}
$!i::Send {up}
$!k::Send {down}


; VLC player
#IfWinActive ahk_class SkinWindowClass
left::Send ^{left}
right::Send ^{right}
up::Send ^{up}
down::Send ^{down}
enter::Send f
WheelDown::Send ^{right}
WheelUp::Send ^{left}
q::Send ^q
#IfWinActive

; PotPlayer
#IfWinActive ahk_class PotPlayer
f::Send {Enter}
q::Send !{F4}
#IfWinActive

; cmder keybind
#IfWinActive ahk_class VirtualConsoleClass
^w::Send !{Backspace}
^q::Send ^u
#IfWinActive

; Sublime Text
#IfWinActive ahk_class PX_WINDOW_CLASS
F2::Send ^k^b
#IfWinActive