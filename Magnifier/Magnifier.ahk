; from https://autohotkey.com/board/topic/10660-screenmagnifier/

#NoEnv
#SingleInstance force

; setting Icon
Menu, Tray, Icon, D:\Pictures\icon\zoom.ico, , 1

SetBatchLines -1

CoordMode Mouse, Screen
OnExit GuiClose
print = 1               ; toggle reprint
zoom = 2                ; initial magnification, 1..32
antialize = 0
Rx = 128                ; half vertical/horizontal side of magnifier window
Ry = 128
Zx := Rx/zoom           ; frame x/y size
Zy := Ry/zoom

left = %A_ScreenWidth%
top = %A_ScreenHeight%
SetFormat, Integer, D

width := 2*Rx
height := 2*Ry
left -= 50 + width
top -= 100 + height

; GUI to show the magnified image
Gui +AlwaysOnTop +Resize +ToolWindow

Gui Show, % "w" width " h" height " x" left " y" top, Magnifier
WinGet MagnifierID, id,  Magnifier
WinSet Transparent, 255, Magnifier ; makes the window invisible to magnification
WinGet PrintSourceID, ID

hdd_frame := DllCall("GetDC", UInt, PrintSourceID)
hdc_frame := DllCall("GetDC", UInt, MagnifierID)

SetTimer Repaint, 50    ; flow through


Repaint:
   if print = 1
     MouseGetPos x, y
     xz := In(x-Zx-6,0,A_ScreenWidth-2*Zx) ; keep the frame on screen
     yz := In(y-Zy-6,0,A_ScreenHeight-2*Zy)
    ; WinMove Frame,,%xz%, %yz%, % 2*Zx, % 2*Zy
     DllCall("gdi32.dll\StretchBlt", UInt,hdc_frame, Int,0, Int,0, Int,2*Rx, Int,2*Ry
     , UInt,hdd_frame, UInt,xz, UInt,yz, Int,2*Zx, Int,2*Zy, UInt,0xCC0020) ; SRCCOPY
Return


GuiSize:
   Rx := A_GuiWidth/2
   Ry := A_GuiHeight/2
   Zx := Rx/zoom
   Zy := Ry/zoom
   TrayTip,,% "Frame  =  " Round(2*Zx) " 01001100160„67301001100160„699 " Round(2*Zy) "`nMagnified to = " A_GuiWidth "01001100160„67301001100160„699" A_GuiHeight
Return

#z::
if print = 1
{
    print = 0
}
else
{
    print = 1
}
return

#a::
  antialize := !antialize
  DllCall( "gdi32.dll\SetStretchBltMode", "uint", hdc_frame, "int", 4*antialize )  ; Antializing ?
Return 


#x::
GuiClose:
   DllCall("gdi32.dll\DeleteDC", UInt,hdc_frame )
   DllCall("gdi32.dll\DeleteDC", UInt,hdd_frame )
ExitApp

#p::
MButton::
   if paused = 
   {
        Gui, 2:Hide 
        Gui, Hide 
        SetTimer, Repaint, Off
        paused = 1
   }
   else
   {
        Gui, 2:Show 
        Gui, Show 
        SetTimer, Repaint, 50
        paused =
   }
Return

^+Up::
^+Down::
^+WheelUp::                      ; Ctrl+Shift+WheelUp to zoom in
^+WheelDown::                    ; Ctrl+Shift+WheelUp to zoom out
   If (zoom < 31 and ( A_ThisHotKey = "^+WheelUp" or A_ThisHotKey = "^+Up" ))
      zoom *= 1.189207115         ; sqrt(sqrt(2))
   If (zoom >  1 and ( A_ThisHotKey = "^+WheelDown" or A_ThisHotKey = "^+Down" ))
      zoom /= 1.189207115
   Zx := Rx/zoom
   Zy := Ry/zoom
   TrayTip,,% "Zoom = " Round(100*zoom) "%"
Return

In(x,a,b) {                      ; closest number to x in [a,b]
   IfLess x,%a%, Return a
   IfLess b,%x%, Return b
   Return x
}