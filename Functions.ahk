;############################################################################
; common functoins
;############################################################################
ToggleTitleMenuBar(ahkid:=0, bHideTitle:=1, bHideMenuBar:=0)
{
    if ( ahkid = 0 ) ; must with () wrap
        WinGet, ahkid, ID, A
    ; ToolTip, % "AHKID is: " ahkid, 300, 300, 
    if ( bHideTitle = 1 )
    {
        WinSet, Style, ^0xC00000, ahk_id %ahkid%     ; titlebar toggle
    }
    if ( bHideMenuBar = 1 )
    {
        WinSet, Style, ^0x40000, ahk_id %ahkid%      ; menubar toggle
    }
}

ToggleWinMinMax(ahkid:=0)
{
    if ( ahkid = 0 )
        WinGet, ahkid, ID, A
    WinGetclass, winclass, ahk_id %ahkid%
    ; ToolTip, % winclass, 300, 300, 
    if winclass in Vim
    {
        ; specail handle
        WinGetPos, X, Y, Width, Height, ahk_id %ahkid%
        ToggleTitleMenuBar(ahkid, 1, 1)
        if X > 30
        {
            WinMove, ahk_id %ahkid%, , 0, 4, 1370, 722
        }
        else 
        {
            WinMove, ahk_id %ahkid%, , 115, 37, 1176, 669
        }
    }
    else 
    {
        WinGet mx, MinMax, ahk_id %ahkid%
        if mx
            WinRestore ahk_id %ahkid%
        else 
            WinMaximize ahk_id %ahkid%
    }
}

ColorCopyMousePos()
{
    MouseGetPos, MouseX, MouseY
    PixelGetColor, color, %MouseX%, %MouseY%, RGB
    StringReplace, color, color, 0x, #, 
    clipboard = %color%
    MsgBox, 0x40, %A_SPACE%Copy color from current cursor, The color at the current cursor position is %color%., 3
}

;;; Known issues:
;;;
;;; - Weird results for windows with custom decorations such as
;;; Chrome, or programs with a Ribbon interface.
;;; - Emacs will be maximized behind instead of in front of
;;; the taskbar. Workaround: WinHide ahk_class Shell_TrayWnd
ToggleFakeFullscreen()
{
    CoordMode Screen, Window
    static WINDOW_STYLE_UNDECORATED := -0xC40000
    static savedInfo := Object() ;; Associative array!
    WinGet, id, ID, A
    if (savedInfo[id])
    {
        inf := savedInfo[id]
        WinSet, Style, % inf["style"], ahk_id %id%
        WinMove, ahk_id %id%,, % inf["x"], % inf["y"], % inf["width"], % inf["height"]
        savedInfo[id] := ""
    }
    else
    {
        savedInfo[id] := inf := Object()
        WinGet, ltmp, Style, A
        inf["style"] := ltmp
        WinGetPos, ltmpX, ltmpY, ltmpWidth, ltmpHeight, ahk_id %id%
        inf["x"] := ltmpX
        inf["y"] := ltmpY
        inf["width"] := ltmpWidth
        inf["height"] := ltmpHeight
        WinSet, Style, %WINDOW_STYLE_UNDECORATED%, ahk_id %id%
        mon := GetMonitorActiveWindow()
        SysGet, mon, Monitor, %mon%
        WinMove, A,, %monLeft%, %monTop%, % monRight-monLeft, % monBottom-monTop
    }
    WinSet Redraw
}

GetMonitorAtPos(x,y)
{
    ;; Monitor number at position x,y or -1 if x,y outside monitors.
    SysGet monitorCount, MonitorCount
    i := 0
    while(i < monitorCount)
    {
        SysGet area, Monitor, %i%
        if ( areaLeft <= x && x <= areaRight && areaTop <= y && y <= areaBottom )
        {
            return i
        }
        i := i+1
    }
    return -1
}

GetMonitorActiveWindow()
{
    ;; Get Monitor number at the center position of the Active window.
    WinGetPos x,y,width,height, A
    return GetMonitorAtPos(x+width/2, y+height/2)
}

SetLayout(layout, winid)
{
    Result := (DllCall("LoadKeyboardLayout", "Str", layout, "UInt", "257"))
    DllCall("SendMessage", "UInt", winid, "UInt", "80", "UInt", "1", "UInt", Result)
}

GenWinShadow(color, wintitle)
{
    width = %A_ScreenWidth%
    height := A_ScreenHeight - 40
    left = 0
    top = 0
    Gui +ToolWindow -Caption
    Gui Color, % color
    Gui Show, % "w" width " h" height " x" left " y" top, % wintitle
}