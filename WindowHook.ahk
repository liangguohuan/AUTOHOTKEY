;##############################################################################
; Input method auto switch
; keymap: HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layouts
;##############################################################################
#NoEnv
#Persistent
#SingleInstance force
#InstallKeybdHook
#WinActivateForce
; #NoTrayIcon

DetectHiddenWindows, On

; setting Icon
Menu, Tray, Icon, D:\Pictures\icon\keyboard.ico, , 1

; incldue common files
#Include, %A_ScriptDir%\Functions.ahk

; ### main code
Gui +LastFound
hWnd := WinExist()
DllCall( "RegisterShellHookWindow", UInt, hWnd )
MsgNum := DllCall( "RegisterWindowMessage", Str, "SHELLHOOK" )
OnMessage( MsgNum, "HandleMessage" )
lastlparam = 0
lastdwLayout = 0
HandleMessage( wParam, lParam ) {
    global lastlparam
    WinGetTitle, wintitle, ahk_id %lParam%
    WinGetclass, winclass, ahk_id %lParam%
    WinGetPos, X, Y, Width, Height, ahk_id %lParam%
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Random, random, 1, 9
    ; ToolTip, % random "wintitle:" wintitle ", class:" winclass ", llp:" lastlparam ", lp:" lParam ", wp:" wParam ", X:" X ", Y:" Y ", W:" Width ", H" Height , 300, 300, 
    ; wParam, 1:winopen; 2:winexit; 32772:winswitch

    ;############################################################################
    ; window create event
    ;############################################################################
    if ( wParam = 1 ) {
        if winclass in mintty,
        {
            WinWait, A
            WinMove, 328, 135
        }
        if winclass in PX_WINDOW_CLASS
        {
            WinGet, ahkid, ID, ahk_class PX_WINDOW_CLASS
            ToggleTitleMenuBar(ahkid, 1, 0)
        }
        if winclass in Vim
        {
            WinGet, ahkid, ID, ahk_class Vim
            ToggleWinMinMax(ahkid)
        }
        if winclass in QWidget
        {
            ; WinHide, A
            Sleep, 1000
            WinGetTitle, wintitle, ahk_class QWidget
            if wintitle = DivX Player
            WinMove, ahk_class QWidget, , 395, 82, 932, 598
            ; WinShow, ahk_class QWidget
        }
        if winclass in WMP Skin Host
        {
            Sleep, 1000
            WinMove, A, , 356, 112, 976, 582
        }
        ; if winclass in IrfanView
        ; {
        ;     Send !+m
        ;     Send !+s
        ; }
    }

    ; cmder
    if ( winclass = "VirtualConsoleClass" and ( wParam = 6 or wParam = 1 ) )
    {
        WinWait, ahk_class VirtualConsoleClass
        WinMove, ahk_class VirtualConsoleClass, , 306, 139, 1040, 565
    }

    ; chrome extensions 'Tabs Outliner'
    if ( wintitle = "Tabs Outliner" and wParam = 6 )
    {
        WinMove, A, , 800, 0, 585, 735
    }

    ; fix window bad look when toggle min and max via mouse
    ; bug: why must show ToolTip then hide ToolTip for preventing?
    if ( wParam = 32772 and winclass = "PX_WINDOW_CLASS" ) {
        if ( X < -30000 or ( Height > 750 and Height <> 768 ) )
        {
            Random, random, 1, 10
            ToolTip, % random, 0, 0, 
            ToggleTitleMenuBar()
            ToggleTitleMenuBar()
            ToolTip
        }
    }

    ; make sure sougou pinyin switch to zh when switch IME manually 
    if ( winclass = "IME" )
    {
        Send {LShift}
    }

    if ( ( wParam = 2 or wParam = 6 or wParam = 32772 ) and winclass <> None and winclass <> "IME" and lParam <> lastlparam ) {
        
        ; ToolTip, % "winclass:" winclass ", lParam:" lParam ", wParam:" wParam, 
        ; if (InStr(winclass, "Chrome") > 0) {
        ;     clipboard=%winclass%
        ; }

        ;############################################################################
        ; InputMethodAutoSwitch
        ;############################################################################

        ; NOTICE: behind 'in' can not have space
        if winclass in Chrome_WidgetWin_1,Chrome_RenderWidgetHostHWND,CabinetWClass,CtrlNotifySink,ApplicationFrameWindow
            dwLayout = E0200804
        else
            dwLayout = 00000409
        if lastdwLayout <> dwLayout
        {
            WinGet, winid, id, A
            SetLayout(dwLayout, winid)
        }

        ;############################################################################
        ; gvim handle
        ; let sublime active next to gvim, prevent gvim white board show on other case.
        ;############################################################################
        if winclass in Vim
        {
            WinSet, AlwaysOnTop, On, A
            GenWinShadow("1C1C1C", "GvimWinShadow")
            WinActivate, ahk_class Vim
            WinSet, AlwaysOnTop, Off, A
        }

        ;############################################################################
        ; must Redraw window, and it dont look like well, so disable it.
        ;############################################################################
        ; window titlebar color setting
        ; IfWinActive ahk_class mintty
        ;     accentcolor = 0x00484a4c
        ; else
        ;     accentcolor = 0x00ffffff
        ; RegWrite, REG_DWORD, HKEY_CURRENT_USER, SOFTWARE\Microsoft\Windows\DWM, AccentColor, % accentcolor
        ; RegWrite, REG_DWORD, HKEY_CURRENT_USER, SOFTWARE\Microsoft\Windows\DWM, AccentColorInactive, 0x00ffffff

        ; WinGetPos, X, Y, Width, Height, ahk_class %winclass%
        ; WinMove, ahk_class %winclass%, , % X, % Y, % Width - 1
        ; WinMove, ahk_class %winclass%, , % X, % Y, % Width
        ; WinSet Redraw

        lastlparam = %lParam%
        lastdwLayout = %dwLayout%
    }
}