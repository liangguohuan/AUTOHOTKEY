/*
From: http://ahk8.com/thread-5029.html
===========================================
  �����ץȡ��������Ļ����/ͼ���ַ�����v4.6  By FeiYue
===========================================

  ������ʷ��

  v4.6 �Ľ������ӶԶ���ʾ����չ��ʾ��֧�֡�
       Ϊ�����Կ��ǣ�������һ�����û�����ġ�AHK_OCR��������
       �ݲ���Ϊ�����ɵ�����������������ٶ���һЩ�������ݲ�������

  v4.5 �Ľ���������Win10-64λϵͳ��һЩ���������⡣
       �����ץ�ִ����ж�ֵ����ɾ�������ķ�Ӧ�ٶȡ�

  v4.3 �Ľ������ֲ����У�ÿ���ֿ����ֿ��������������������
       ��������û�������Ų��á��������֡������е��ݲ������

  v4.2 �Ľ���������64λϵͳ�Ļ����룬������AHK 64λ�档

  v4.1 �Ľ�������ʹ��GDI+��ȡ��Ļͼ��ֱ����GDIʵ�֡�

  v4.0 �Ľ������ֲ����������߷ָ����ֿ���ʽ�����Խ���
       OCRʶ��������ʽҲ������ͬʱ���Ҷ������/ͼƬ��

  v3.5 �Ľ������û�����ʵ��ͼ�����֣������������ٶȡ�

  ʹ��˵����

      1����ץȡ����ͼ���ַ�����Ȼ��ȫ�����Ҳ��ԣ����Գɹ���
         ������ƴ��룬��ճ�����Լ��Ľű��У�����������
         ���������֡�����������ĺ������Ƶ��Լ��Ľű��о����ˡ�

      2���Զ���ֵ����ͼ����������⣬�����ֶ����뷧ֵ���ԡ�
         �ֿ���������һ�����ɶ�����ֵ�ģ�塣������ҽṹ
         ���ֱ��ֿ������Ե����ü�����һ���֣�Ȼ�������ơ�

      3������������ػ�Ӱ����Ļͼ�����Ի�һ̨����һ���Ҫ
         ����ץ��/ͼ������ʹ����ɫģʽץ�֣�����ͨ����ǿЩ

===========================================

  �Ƿ�ɹ� := ��������( ���ĵ�X, ���ĵ�Y, ����, ��ɫ, ����ƫ��W
             , ����ƫ��H, ����X, ����Y, ����OCR���, �ݲ� )

  ���У���ɫ��*�ŵ�Ϊ�Ҷȷ�ֵģʽ�����ڷǵ�ɫ�����ֱȽϺ��á�
       �ݲ���������м����㲻ͬ������ڻҶȷ�ֵģʽ�����á�

===========================================
*/

#NoEnv
#SingleInstance Force
SetBatchLines, -1
CoordMode, Mouse
CoordMode, Pixel
CoordMode, ToolTip
SetWorkingDir, %A_ScriptDir%
;----------------------------
Menu, Tray, Icon, Shell32.dll, 23
Menu, Tray, Add
Menu, Tray, Add, ��ʾ������
Menu, Tray, Default, ��ʾ������
Menu, Tray, Click, 1
;----------------------------
  ww:=35, hh:=12    ; ��������ץ��ץͼ�ķ�Χ
  nW:=2*ww+1, nH:=2*hh+1
;----------------------------
Gosub, ����ץ�ִ���
Gosub, ����������
OnExit, savescr
Gosub, readscr
Return

F12::    ; ����F12�������޸Ĳ������ű�
SetTitleMatchMode, 2
SplitPath, A_ScriptName,,,, name
IfWinExist, %name%
{
  ControlSend, ahk_parent, {Ctrl Down}s{Ctrl Up}
  Sleep, 500
}
Reload
Return

readscr:
f=%A_Temp%\~scr1.tmp
FileRead, s, %f%
GuiControl, 6:, Edit1, %s%
s=
Return

savescr:
f=%A_Temp%\~scr1.tmp
GuiControlGet, s, 6:, Edit1
FileDelete, %f%
FileAppend, %s%, %f%
ExitApp

��ʾ������:
Gui, 6:Show, Center
Return

����������:
Gui, 6:Default
Gui, +AlwaysOnTop +Hwndgui6_id
Gui, Margin, 15, 15
Gui, Font, s12 cBlue, Verdana
Gui, Color, EEFFFF, EEFFFF
Gui, Add, Button, w250 gRun6, ץȡ����ͼ��
Gui, Add, Button, x+0 wp gRun6, ȫ�����Ҳ���
Gui, Add, Button, x+0 wp gRun6, ���ƴ���
Gui, Add, Edit, xm w750 h400 -Wrap HScroll
Gui, Show, NA, ����/ͼ���ַ������ɹ���
Return

Run6:
k:=A_GuiControl
WinMinimize
Gui, Hide
DetectHiddenWindows, Off
WinWaitClose, ahk_id %gui6_id%
if IsLabel(k)
  Gosub, %k%
Gui, 6:Show
GuiControl, 6:Focus, Edit1
Return

���ƴ���:
GuiControlGet, s,, Edit1
Clipboard:=RegExReplace(s,"\n","`r`n"), s:=""
Return

ץȡ����ͼ��:
;------------------------------
; ����һ��΢��GUI��ʾץ�ַ�Χ
Gui, 9:+LastFound +AlwaysOnTop
  -Caption +ToolWindow +E0x08000000
WinSet, Transparent, 100
Gui, 9:Color, Red
Gui, 9:Show, Hide w%nW% h%nH%
;------------------------------
ListLines, Off
While !GetKeyState("LButton","P") {
  MouseGetPos, px, py
  Gui, 9:Show, % "NA x" px-ww " y" py-hh
  ToolTip, % "��ǰ���λ�ã�" px "," py
    . "`n���Ƶ�Ŀ��λ�ú������"
  Sleep, 20
}
KeyWait, LButton
Gui, 9:Color, White
Loop {
  MouseGetPos, x, y
  Gui, 9:Show, % "NA x" x-ww " y" y-hh
  ToolTip, ������ɹ�`n�������ƿ�
  Sleep, 20
  if Abs(px-x)+Abs(py-y)>100
    Break
}
ToolTip
ListLines, On
Gui, 9:Destroy
WinWaitClose
cors:=getc(px,py)
;---------------------------------
Gui, 5:Default
GuiControl,, Edit1
GuiControl,, Edit2
GuiControl,, Edit3
GuiControl,, �޸�, % xiugai:=0
Gosub, �ض�
Gui, Show, Center
OnMessage(0x201,"WM_LBUTTONDOWN")
DetectHiddenWindows, Off
WinWaitClose, ahk_id %gui5_id%
OnMessage(0x201,"")
Return

WM_LBUTTONDOWN() {
  global
  ListLines, Off
  MouseGetPos,,,, mclass
  if (A_Gui!=5) or !InStr(mclass,"progress")
    Return
  MouseGetPos,,,, mid, 2
  For k,v in C_
    if (v=mid)
    {
      if (xiugai and bg!="")
      {
        c:=cc[k], cc[k]:=c="0" ? "_" : c="_" ? "0" : c
        c:=c="0" ? "White" : c="_" ? "Black" : "0xDDEEFF"
        Gosub, SetColor
      }
      else
        GuiControl, 5:, Edit1, % cors[k]
      Return
    }
}

getc(px, py) {
  global ww, hh, nW, nH
  ; ����ƫ�Ʒ�Χת���Ͽ�߷�Χ
  xywh2xywh(px,py,ww,hh,x,y,w,h)
  ;--------------------------------------
  GetBitsFromScreen(x,y,w,h,Scan0,Stride,bits)
  ;--------------------------------------
  bch:=A_BatchLines, fmt:=A_FormatInteger
  SetBatchLines, -1
  SetFormat, IntegerFast, H
  cors:=[], k:=0
  Loop, %nH% {
    j:=py-hh-y+A_Index-1
    Loop, %nW% {
      i:=px-ww-x+A_Index-1
      if (i>=0) and (i< w) and (j>=0) and (j< h)
      {
        c:=NumGet(Scan0+0,i*4+j*Stride,"uint")
        cors[++k]:="0x" . SubStr(0x1000000|c,-5)
      }
      else  cors[++k]:="0xFFFFFF"
    }
  }
  SetFormat, IntegerFast, %fmt%
  SetBatchLines, %bch%
  cors.left:=Abs(px-ww-x), cors.top:=Abs(py-hh-y)
  cors.right:=Abs(px+ww-(x+w-1))
  cors.end:=Abs(py+hh-(y+h-1))
  Return, cors
}

ȫ�����Ҳ���:
GuiControlGet, s, 6:, Edit1
if !RegExMatch(s,"��������\(([^\)\n]+)\)",r)
  Return
StringReplace, s, s, %r%
StringSplit, r, r1, `,, "
if r0< 6
  Return
t1:=A_TickCount
ok:=��������(r1,r2,s,r4,r5,r6,X,Y,OCR,r10)
t1:=A_TickCount-t1
MsgBox, 4096,, % "���ҽ����" (ok ? "�ɹ�":"ʧ��")
  . "`n`n����ʶ������" OCR
  . "`n`n��ʱ��" t1 " ���룬�ҵ���λ�ã�" (ok ? X "," Y:"")
if ok
{
  MouseMove, X, Y
  Sleep, 1000
}
Return


����ץ�ִ���:
Gui, 5:Default
Gui, +LastFound +AlwaysOnTop +ToolWindow +Hwndgui5_id
Gui, Margin, 15, 15
Gui, Color, DDEEFF
Gui, Font, s16, Verdana
Loop, % nH*nW {
  j:=A_Index=1 ? "" : Mod(A_Index,nW)=1 ? "x15 y+-1" : "x+-1"
  Gui, Add, Progress, w15 h15 %j% -Theme
}
Gui, Add, Text,   xm y+21   w50 Center, ѡɫ
Gui, Add, Edit,   x+2       w130
Gui, Add, Button, x+2 yp-6  w140 gRun, ��ɫ��ֵ��
Gui, Add, Text,   x+10 yp+6 w50 Center, ��ֵ
Gui, Add, Edit,   x+2       w70
Gui, Add, Button, x+2 yp-6  w140 gRun Default, �Զ���ֵ��
Gui, Add, Text,   x+10 yp+6 w50 Center, �ֿ�
Gui, Add, Edit,   x+2       w90
Gui, Add, Checkbox, x+4 yp+6 w80 gRun, �޸�
Gui, Add, Button, x+0 yp-6  wp gRun, �ָ�
Gui, Add, Button, x+0       wp gRun, ����
Gui, Add, Button, xm        wp gRun, ��ɾ
Gui, Add, Button, x+0       wp gRun, ��3ɾ
Gui, Add, Button, x+25      wp gRun, ��ɾ
Gui, Add, Button, x+0       wp gRun, ��3ɾ
Gui, Add, Button, x+25      wp gRun, ��ɾ
Gui, Add, Button, x+0       wp gRun, ��3ɾ
Gui, Add, Button, x+25      wp gRun, ��ɾ
Gui, Add, Button, x+0       wp gRun, ��3ɾ
Gui, Add, Button, x+25      wp gRun, ��ɾ
Gui, Add, Button, x+14      wp gRun, �ض�
Gui, Add, Button, x+0      wp gRun, ����
Gui, Show, Hide, ץ�����ɶ�ֵ���ַ���
WinGet, s, ControlListHwnd
C_:=StrSplit(s,"`n"), s:=""
Return

Run:
Critical
k:=A_GuiControl
if IsLabel(k)
  Goto, %k%
Return

�޸�:
GuiControlGet, xiugai,, %A_GuiControl%
Return

SetColor:
c:=c="White" ? 0xFFFFFF : c="Black" ? 0
  : ((c&0xFF)<< 16)|(c&0xFF00)|(c>>16&0xFF)
SendMessage, 0x2001, 0, c,, % "ahk_id " . C_[k]
Return

�ض�:
if !IsObject(cc)
  cc:=[], pp:=[]
left:=right:=top:=end:=k:=0, bg:=""
Loop, % nH*nW {
  cc[++k]:=1, c:=cors[k]
  Gosub, SetColor
}
; �ü�ץ�ַ�Χ������Ļ�߽�Ĳ���
Loop, % cors.top
  Gosub, ��ɾ
Loop, % cors.right
  Gosub, ��ɾ
Loop, % cors.end
  Gosub, ��ɾ
Loop, % cors.left
  Gosub, ��ɾ
Return

��ɫ��ֵ��:
GuiControlGet, r,, Edit1
if r=
{
  MsgBox, 4096,, `n    ���Ƚ���ѡɫ��    `n, 1
  Return
}
color:=r, k:=i:=0
Loop, % nH*nW {
  if (cc[++k]="")
    Continue
  if (cors[k]=color)
    cc[k]:="0", c:="Black", i++
  else
    cc[k]:="_", c:="White", i--
  Gosub, SetColor
}
bg:=i>0 ? "0":"_"  ; ����ɫ
Return

�Զ���ֵ��:  ; ���Զ���ֶ����뷧ֵ����շ�ֵ�Զ���ֵ��
GuiControl, Focus, Edit2
Loop, 256    ; ͳ�ƻҶ�ֱ��ͼ
  pp[A_Index-1]:=0
k:=0
Loop, % nH*nW {
  if (cc[++k]="")
    Continue
  c:=cors[k], cc[k]:=c:=((c>>16&0xFF)*299
    +(c>>8&0xFF)*587+(c&0xFF)*114)//1000, pp[c]++
}
GuiControlGet, fazhi,, Edit2
if fazhi=
{
  ; ���������ֵ����ֵ��������20�Σ�����㷨�ǳ�����
  IP:=IS:=0
  Loop, 256
    k:=A_Index-1, IP+=k*pp[k], IS+=pp[k]
  Newfazhi:=Floor(IP/IS)
  Loop, 20 {
    fazhi:=Newfazhi
    IP1:=IS1:=0
    Loop, % fazhi+1
      k:=A_Index-1, IP1+=k*pp[k], IS1+=pp[k]
    IP2:=IP-IP1, IS2:=IS-IS1
    if (IS1!=0 and IS2!=0)
      Newfazhi:=Floor((IP1/IS1+IP2/IS2)/2)
    if (Newfazhi=fazhi)
      Break
  }
  GuiControl,, Edit2, %fazhi%
}
color:="*" fazhi, k:=i:=0
Loop, % nH*nW {
  if (cc[++k]="")
    Continue
  if (cc[k]< fazhi+1)
    cc[k]:="0", c:="Black", i++
  else
    cc[k]:="_", c:="White", i--
  Gosub, SetColor
}
bg:=i>0 ? "0":"_"  ; ����ɫ
Return

gui_del:
cc[k]:="", c:="0xDDEEFF"
Gosub, SetColor
Return

��3ɾ:
Loop, 3
  Gosub, ��ɾ
Return

��ɾ:
if (left+right>=nW)
  Return
left++, k:=left
Loop, %nH% {
  Gosub, gui_del
  k+=nW
}
Return

��3ɾ:
Loop, 3
  Gosub, ��ɾ
Return

��ɾ:
if (left+right>=nW)
  Return
right++, k:=nW+1-right
Loop, %nH% {
  Gosub, gui_del
  k+=nW
}
Return

��3ɾ:
Loop, 3
  Gosub, ��ɾ
Return

��ɾ:
if (top+end>=nH)
  Return
top++, k:=(top-1)*nW
Loop, %nW% {
  k++
  Gosub, gui_del
}
Return

��3ɾ:
Loop, 3
  Gosub, ��ɾ
Return

��ɾ:
if (top+end>=nH)
  Return
end++, k:=(nH-end)*nW
Loop, %nW% {
  k++
  Gosub, gui_del
}
Return

getwz:
wz=
if bg=
  Return
k:=0
Loop, %nH% {
  v=
  Loop, %nW%
    v.=cc[++k]
  wz.=v="" ? "" : v "`n"
}
Return

��ɾ:
Gosub, getwz
if wz=
{
  MsgBox, 4096, ��ʾ, `n���Ƚ���һ�ֶ�ֵ����, 1
  Return
}
While InStr(wz,bg) {
  if (wz~="^" bg "+\n")
  {
    wz:=RegExReplace(wz,"^" bg "+\n")
    Gosub, ��ɾ
  }
  else if !(wz~="m`n)[^\n" bg "]$")
  {
    wz:=RegExReplace(wz,"m`n)" bg "$")
    Gosub, ��ɾ
  }
  else if (wz~="\n" bg "+\n$")
  {
    wz:=RegExReplace(wz,"\n\K" bg "+\n$")
    Gosub, ��ɾ
  }
  else if !(wz~="m`n)^[^\n" bg "]")
  {
    wz:=RegExReplace(wz,"m`n)^" bg)
    Gosub, ��ɾ
  }
  else Break
}
wz=
Return

����:
�ָ�:
Gosub, getwz
if wz=
{
  MsgBox, 4096, ��ʾ, `n���Ƚ���һ�ֶ�ֵ����, 1
  Return
}
Gui, Hide
if (bg="0")    ; �Ż��ַ�������ʾ���
{
  color:="-" color, bg:="_"
  wz:=RegExReplace(wz,"0","1")
  wz:=RegExReplace(wz,"_","0")
  wz:=RegExReplace(wz,"1","_")
}
; ���ɴ����е�����Ϊ�ü����������ֵ�����λ��
px1:=px-ww+left+(nW-left-right-1)//2
py1:=py-hh+top+(nH-top-end-1)//2
GuiControlGet, ziku,, Edit3
s:="`n����=`n", ziku:=Trim(ziku)
if A_ThisLabel=�ָ�
{
  SetFormat, IntegerFast, d    ; ������ʽ��������Ҫʮ����
  Loop {
    While InStr(wz,bg) and !(wz~="m`n)^[^\n" bg "]")
      wz:=RegExReplace(wz,"m`n)^.")
    Loop, % InStr(wz,"`n")-1 {
      i:=A_Index
      if !(wz~="m`n)^.{" i "}[^\n" bg "]")
      {
        ; �Զ��ָ��ñߣ�С����ȵ��ֿ�Ҫ�ֶ�����
        v:=RegExReplace(wz,"m`n)^(.{" i "}).*","$1")
        v:=RegExReplace(v,"^(" bg "+\n)+")
        v:=RegExReplace(v,"\n\K(" bg "+\n)+$")
        k:=SubStr(ziku,1,1), ziku:=SubStr(ziku,2)
        s.="`n����=%����%|< " k " >`n(`n" v ")`n"
        wz:=RegExReplace(wz,"m`n)^.{" i "}")
        Continue, 2
      }
    }
    Break
  }
}
else
  s.="`n����=%����%|< " ziku " >`n(`n" wz ")`n"
s.="`nif ��������(" px1 "," py1
  . ",����,""" color """,150000,150000,X,Y,OCR,0)`n{"
  . "`n  CoordMode, Mouse"
  . "`n  MouseMove, X, Y`n}`n"
GuiControl, 6:, Edit1, %s%
s=
Return

����:
Gosub, getwz
Gui, Hide
if wz=
  Return
if (bg="0")    ; �Ż��ַ�������ʾ���
{
  wz:=RegExReplace(wz,"0","1")
  wz:=RegExReplace(wz,"_","0")
  wz:=RegExReplace(wz,"1","_")
}
GuiControlGet, ziku,, Edit3
Clipboard:="`r`n����=%����%|< " ziku " >`r`n(`r`n"
  . RegExReplace(wz,"\n","`r`n") . ")`r`n"
Return


;---- ������ĺ������ӵ��Լ��Ľű��� ----


;-----------------------------------------
; ������Ļ����/ͼ���ַ�����OCRʶ��
;-----------------------------------------
��������(x,y,wz,c,w=150,h=150,ByRef rx="",ByRef ry=""
  ,ByRef ocr="",chamax=0)
{
  ; ע�⣺������x��yΪ���ĵ����꣬w��hΪ��������ƫ��
  ; ����ƫ�Ʒ�Χת���Ͽ�߷�Χ
  xywh2xywh(x,y,w,h,x,y,w,h)
  if (w< 1 or h< 1)
    Return, 0
  ;--------------------------------------
  GetBitsFromScreen(x,y,w,h,Scan0,Stride,bits)
  ;--------------------------------------
  ; �趨ͼ�ڲ��ҷ�Χ��ע�ⲻҪԽ��
  sx:=0, sy:=0, sw:=w, sh:=h
  if PicOCR(Scan0,Stride,sx,sy,sw,sh,wz,c,chamax,rx,ry,ocr)
  {
    rx+=x, ry+=y
    Return, 1
  }
  Return, 0
}

;------------------------------
; ����ƫ�Ʒ�Χת���Ͽ�߷�Χ
;------------------------------
xywh2xywh(x1,y1,w1,h1,ByRef x,ByRef y,ByRef w,ByRef h)
{
  left:=x1-w1, right:=x1+w1, top:=y1-h1, end:=y1+h1
  ; ��ȡ������Ļ�����Ͽ�߷�Χ
  SysGet, zx, 76
  SysGet, zy, 77
  SysGet, zw, 78
  SysGet, zh, 79
  left:=left< zx ? zx:left, top:=top< zy ? zy:top
  right:=right>zx+zw-1 ? zx+zw-1:right
  end:=end>zy+zh-1 ? zy+zh-1:end
  x:=left, y:=top, w:=right-left+1, h:=end-top+1
}

;------------------------------
; ��ȡ������Ļ��ͼ������
;------------------------------
GetBitsFromScreen(x,y,w,h,ByRef Scan0,ByRef Stride,ByRef bits)
{
  VarSetCapacity(bits, w*h*4, 0)
  Ptr:=A_PtrSize ? "UPtr" : "UInt"
  ; ���洰�ڶ�Ӧ����������ʾ����������Ļ
  win:=DllCall("GetDesktopWindow", Ptr)
  hDC:=DllCall("GetDC", Ptr,win, Ptr)
  mDC:=DllCall("CreateCompatibleDC", Ptr,hDC, Ptr)
  hBM:=DllCall("CreateCompatibleBitmap", Ptr,hDC
    , "int",w, "int",h, Ptr)
  oBM:=DllCall("SelectObject", Ptr,mDC, Ptr,hBM, Ptr)
  DllCall("BitBlt", Ptr,mDC, "int",0, "int",0, "int",w
    , "int",h, Ptr,hDC, "int",x, "int",y, "uint",0x00CC0020)
  DllCall("ReleaseDC", Ptr,win, Ptr,hDC)
  VarSetCapacity(bi, 40, 0)
  NumPut(40, bi, 0, "int"), NumPut(w, bi, 4, "int")
  NumPut(-h, bi, 8, "int"), NumPut(1, bi, 12, "short")
  NumPut(bpp:=32, bi, 14, "short"), NumPut(0, bi, 16, "int")
  DllCall("GetDIBits", Ptr,mDC, Ptr,hBM
    , "int",0, "int",h, Ptr,&bits, Ptr,&bi, "int",0)
  DllCall("SelectObject", Ptr,mDC, Ptr,oBM)
  DllCall("DeleteObject", Ptr,hBM)
  DllCall("DeleteDC", Ptr,mDC)
  Scan0:=&bits, Stride:=((w*bpp+31)//32)*4
}

;-----------------------------------------
; ͼ���ڲ�������/ͼ���ַ�����OCR����
;-----------------------------------------
PicOCR(Scan0, Stride, sx, sy, sw, sh
  , wenzi, c, chamax, ByRef rx, ByRef ry, ByRef ocr)
{
  static MyFunc
  if !MyFunc
  {
    if A_PtrSize=8    ; AHK 64λ��
    MCode( MyFunc, ""
    . "554889E54881EC7000000048894D10488955184C8945204C89"
    . "4D288B45408B4D300FAFC18B4D38C1E10201C88945F48B4548"
    . "C1E0028B4D3029C1894DF0B8000000008945EC8B451083F801"
    . "0F85380100008B4518C1E81081E0FF0000008945E88B4518C1"
    . "E80881E0FF0000008945E48B451881E0FF0000008945E0B800"
    . "0000008945F88B45F88B4D5039C80F8DF3000000E916000000"
    . "8B45F883C0018945F88B45F48B4DF001C88945F4EBD7B80000"
    . "00008945FC8B45FC8B4D4839C80F8DBD000000E9140000008B"
    . "45FC83C0018945FC8B45F483C0048945F4EBD98B45EC4889C1"
    . "83C0018945EC4863C9488B45584801C88B4DF483C1024863C9"
    . "488B55284801CA0FB60A8B55E839D1488945D80F8540000000"
    . "8B45F483C0014863C0488B4D284801C10FB6018B4DE439C80F"
    . "85220000008B45F44863C0488B4D284801C10FB6018B4DE039"
    . "C80F8507000000B801000000EB05B80000000085C00F840500"
    . "0000E90A000000B830000000E905000000B831000000488B4D"
    . "D88801E948FFFFFFE912FFFFFFE9160100008B451883C001B9"
    . "E80300000FAFC1894518B8000000008945F88B45F88B4D5039"
    . "C80F8DEF000000E9160000008B45F883C0018945F88B45F48B"
    . "4DF001C88945F4EBD7B8000000008945FC8B45FC8B4D4839C8"
    . "0F8DB9000000E9140000008B45FC83C0018945FC8B45F483C0"
    . "048945F4EBD98B45EC4889C183C0018945EC4863C9488B4558"
    . "4801C88B4DF483C1024863C9488B55284801CA0FB60ABA2B01"
    . "00000FAFCA8B55F483C2014863D2488945D0488B45284801D0"
    . "0FB610B84B0200000FAFD001D18B45F44863C0488B55284801"
    . "C20FB602BA720000000FAFC201C18B451839C1B8000000000F"
    . "92C085C00F8405000000E90A000000B830000000E905000000"
    . "B831000000488B4DD08801E94CFFFFFFE916FFFFFFB8000000"
    . "008945A8B8000000008945A48B45488945A08B455089459CB8"
    . "000000008945988B45A48B4D480FAFC18B4DA801C88945F4B8"
    . "000000008945FC8B45FC8B4DA039C80F8D39050000E90B0000"
    . "008B45FC83C0018945FCEBE2B8000000008945F88B45F88B4D"
    . "9C39C80F8D0E050000E90B0000008B45F883C0018945F8EBE2"
    . "B8000000008945EC8B45EC8B4D6839C80F8DE3040000E90B00"
    . "00008B45EC83C0018945ECEBE28B45ECB9060000000FAFC183"
    . "C0014863C048C1E002488B4D704801C18B018945BC8B45ECB9"
    . "060000000FAFC183C0024863C048C1E002488B4D704801C18B"
    . "018945B88B45FC8B4DBC01C88B4DA039C80F8F180000008B45"
    . "F88B4DB801C88B4D9C39C80F8F05000000E905000000E983FF"
    . "FFFF8B45ECB9060000000FAFC183C0034863C048C1E002488B"
    . "4D704801C18B018945C48B45ECB9060000000FAFC183C00448"
    . "63C048C1E002488B4D704801C18B018945C08B45F88B4DC001"
    . "C88B4D480FAFC88B45F401C88B4DFC8B55C401D101C88945CC"
    . "8B45ECB9060000000FAFC14863C048C1E002488B4D704801C1"
    . "8B45BC8B55C00FAFC28B1101C28B45C401C28955C88B45C848"
    . "63C0488B4D604801C10FBE018945188B45ECB9060000000FAF"
    . "C183C0054863C048C1E002488B4D704801C18B018945AC8B45"
    . "488B4DBC29C88945F08B45C48945B48B45B48B4DBC39C80F8D"
    . "63000000E90B0000008B45B483C0018945B4EBE28B45CC4889"
    . "C183C0018945CC4863C9488B45584801C88B4DC84889CA83C1"
    . "01894DC84863D2488B4D604801D10FBE100FBE0139C20F8417"
    . "0000008B45AC83C0FF8945AC83F8000F8D05000000E9130300"
    . "00EBA28B45CC8B4DF001C88945CC8B45C083C0018945B08B45"
    . "B08B4DB839C80F8D99000000E9160000008B45B083C0018945"
    . "B08B45CC8B4DF001C88945CCEBD7B8000000008945B48B45B4"
    . "8B4DBC39C80F8D63000000E90B0000008B45B483C0018945B4"
    . "EBE28B45CC4889C183C0018945CC4863C9488B45584801C88B"
    . "4DC84889CA83C101894DC84863D2488B4D604801D10FBE100F"
    . "BE0139C20F84170000008B45AC83C0FF8945AC83F8000F8D05"
    . "000000E95D020000EBA2E96CFFFFFF8B45488B4DF80FAFC18B"
    . "4DF401C18B45FC01C1894DCCB8000000008945B08B45B08B4D"
    . "C039C80F8D80000000E9160000008B45B083C0018945B08B45"
    . "CC8B4DF001C88945CCEBD7B8000000008945B48B45B48B4DBC"
    . "39C80F8D4D000000E90B0000008B45B483C0018945B4EBE28B"
    . "45CC4889C183C0018945CC4863C9488B45584801C80FBE088B"
    . "451839C10F84170000008B45AC83C0FF8945AC83F8000F8D05"
    . "000000E9AE010000EBB8EB85B8000000008945B48B45B48B4D"
    . "C439C80F8D4D000000E90B0000008B45B483C0018945B4EBE2"
    . "8B45CC4889C183C0018945CC4863C9488B45584801C80FBE08"
    . "8B451839C10F84170000008B45AC83C0FF8945AC83F8000F8D"
    . "05000000E949010000EBB88B459883F8000F85A3000000488B"
    . "45788B4D388B55FC01D18908488B45784883C0048B4D408B55"
    . "F801D18908488B45784883C0088B4DBC8908488B45784883C0"
    . "0C8B4DB88908B8040000008945988B45F88B4DB829C88945A4"
    . "8B45B8B9030000000FAFC189459C8B45B8B90A0000000FAFC1"
    . "83C0648945A08B45A483F8000F8D08000000B8000000008945"
    . "A48B45508B4DA429C88B4D9C39C10F8E0B0000008B45508B4D"
    . "A429C889459CE92F0000008B45FC8B4D2039C80F8E21000000"
    . "8B45984889C183C0018945984863C948C1E102488B45784801"
    . "C8B9FFFFFFFF89088B45984889C183C0018945984863C948C1"
    . "E102488B45784801C88B4DEC83C10189088B459881F8FD0300"
    . "000F8E05000000E95D0000008B45FC8B4DBC01C88B4DA801C1"
    . "894DA88B45488B4DA829C88B4DA039C10F8E0B0000008B4548"
    . "8B4DA829C88945A0E9B4FAFFFFE927FBFFFFE922FBFFFFE9F7"
    . "FAFFFFE9CCFAFFFF8B459883F8000F850A000000B800000000"
    . "E9220000008B45984863C048C1E002488B4D784801C1B80000"
    . "00008901B801000000E900000000C9C3000000010402050403"
    . "0150" )
    else    ; AHK 32λ��
    MCode( MyFunc, ""
    . "5589E581EC60000000908B45208B4D180FAFC18B4D1CC1E102"
    . "01C88945F48B4524C1E0028B4D1829C1894DF0B80000000089"
    . "45EC8B450883F8010F85190100008B450CC1E81081E0FF0000"
    . "008945E88B450CC1E80881E0FF0000008945E48B450C81E0FF"
    . "0000008945E0B8000000008945F88B45F88B4D2839C80F8DD4"
    . "000000E9140000008B45F8408945F88B45F48B4DF001C88945"
    . "F4EBD9B8000000008945FC8B45FC8B4D2439C80F8DA0000000"
    . "E9120000008B45FC408945FC8B45F483C0048945F4EBDB8B45"
    . "EC89C1408945EC8B452C01C88B4DF483C1028B551401CA0FB6"
    . "0A8B55E839D18945DC0F85340000008B45F4408B4D1401C10F"
    . "B6018B4DE439C80F851D0000008B45148B4DF401C80FB6088B"
    . "45E039C10F8507000000B801000000EB05B80000000085C00F"
    . "8405000000E90A000000B830000000E905000000B831000000"
    . "8B4DDC8801E965FFFFFFE931FFFFFFE9F50000008B450C40B9"
    . "E80300000FAFC189450CB8000000008945F88B45F88B4D2839"
    . "C80F8DD0000000E9140000008B45F8408945F88B45F48B4DF0"
    . "01C88945F4EBD9B8000000008945FC8B45FC8B4D2439C80F8D"
    . "9C000000E9120000008B45FC408945FC8B45F483C0048945F4"
    . "EBDB8B45EC89C1408945EC8B452C01C88B4DF483C1028B5514"
    . "01CA0FB60ABA2B0100000FAFCA8B55F4428945D88B451401D0"
    . "0FB610B84B0200000FAFD001D18B45148B55F401D00FB610B8"
    . "720000000FAFD001D18B450C39C1B8000000000F92C085C00F"
    . "8405000000E90A000000B830000000E905000000B831000000"
    . "8B4DD88801E969FFFFFFE935FFFFFFB8000000008945B0B800"
    . "0000008945AC8B45248945A88B45288945A4B8000000008945"
    . "A08B45AC8B4D240FAFC18B4DB001C88945F4B8000000008945"
    . "FC8B45FC8B4DA839C80F8DAC040000E9090000008B45FC4089"
    . "45FCEBE4B8000000008945F88B45F88B4DA439C80F8D830400"
    . "00E9090000008B45F8408945F8EBE4B8000000008945EC8B45"
    . "EC8B4D3439C80F8D5A040000E9090000008B45EC408945ECEB"
    . "E48B45ECB9060000000FAFC140C1E0028B4D3801C18B018945"
    . "C48B45ECB9060000000FAFC183C002C1E0028B4D3801C18B01"
    . "8945C08B45FC8B4DC401C88B4DA839C80F8F180000008B45F8"
    . "8B4DC001C88B4DA439C80F8F05000000E905000000E993FFFF"
    . "FF8B45ECB9060000000FAFC183C003C1E0028B4D3801C18B01"
    . "8945CC8B45ECB9060000000FAFC183C004C1E0028B4D3801C1"
    . "8B018945C88B45F88B4DC801C88B4D240FAFC88B45F401C88B"
    . "4DFC8B55CC01D101C88945D48B45ECB9060000000FAFC1C1E0"
    . "028B4D3801C18B45C48B55C80FAFC28B1101C28B45CC01C289"
    . "55D08B45308B4DD001C80FBE08894D0C8B45ECB9060000000F"
    . "AFC183C005C1E0028B4D3801C18B018945B48B45248B4DC429"
    . "C88945F08B45CC8945BC8B45BC8B4DC439C80F8D51000000E9"
    . "090000008B45BC408945BCEBE48B45D489C1408945D48B452C"
    . "01C88B4DD089CA41894DD08B4D3001D10FBE100FBE0139C20F"
    . "84170000008B45B483C0FF8945B483F8000F8D05000000E9C9"
    . "020000EBB48B45D48B4DF001C88945D48B45C8408945B88B45"
    . "B88B4DC039C80F8D82000000E9140000008B45B8408945B88B"
    . "45D48B4DF001C88945D4EBD9B8000000008945BC8B45BC8B4D"
    . "C439C80F8D51000000E9090000008B45BC408945BCEBE48B45"
    . "D489C1408945D48B452C01C88B4DD089CA41894DD08B4D3001"
    . "D10FBE100FBE0139C20F84170000008B45B483C0FF8945B483"
    . "F8000F8D05000000E929020000EBB4EB838B45248B4DF80FAF"
    . "C18B4DF401C18B45FC01C1894DD4B8000000008945B88B45B8"
    . "8B4DC839C80F8D74000000E9140000008B45B8408945B88B45"
    . "D48B4DF001C88945D4EBD9B8000000008945BC8B45BC8B4DC4"
    . "39C80F8D43000000E9090000008B45BC408945BCEBE48B45D4"
    . "89C1408945D48B452C01C80FBE088B450C39C10F8417000000"
    . "8B45B483C0FF8945B483F8000F8D05000000E989010000EBC2"
    . "EB91B8000000008945BC8B45BC8B4DCC39C80F8D43000000E9"
    . "090000008B45BC408945BCEBE48B45D489C1408945D48B452C"
    . "01C80FBE088B450C39C10F84170000008B45B483C0FF8945B4"
    . "83F8000F8D05000000E92E010000EBC28B45A083F8000F859C"
    . "0000008B453C8B4D1C8B55FC01D189088B453C83C0048B4D20"
    . "8B55F801D189088B453C83C0088B4DC489088B453C83C00C8B"
    . "4DC08908B8040000008945A08B45F88B4DC029C88945AC8B45"
    . "C0B9030000000FAFC18945A48B45C0B90A0000000FAFC183C0"
    . "648945A88B45AC83F8000F8D08000000B8000000008945AC8B"
    . "45288B4DAC29C88B4DA439C10F8E0B0000008B45288B4DAC29"
    . "C88945A4E9260000008B45FC8B4D1039C80F8E180000008B45"
    . "A089C1408945A0C1E1028B453C01C8B9FFFFFFFF89088B45A0"
    . "89C1408945A0C1E1028B453C01C88B4DEC4189088B45A081F8"
    . "FD0300000F8E05000000E95D0000008B45FC8B4DC401C88B4D"
    . "B001C1894DB08B45248B4DB029C88B4DA839C10F8E0B000000"
    . "8B45248B4DB029C88945A8E941FBFFFFE9B0FBFFFFE9ABFBFF"
    . "FFE982FBFFFFE959FBFFFF8B45A083F8000F850A000000B800"
    . "000000E91C0000008B45A0C1E0028B4D3C01C1B80000000089"
    . "01B801000000E900000000C9C23800" )
  }
  ;--------------------------------------
  ; ͳ���ֿ����ֵĸ����Ϳ�ߣ����������ִ������鲢ɾ��< >
  ;--------------------------------------
  wenzitab:=[], n:=0, wz:="", j:=""
  fmt:=A_FormatInteger
  SetFormat, IntegerFast, d    ; ������ʽ��Ҫ��ʮ����
  Loop, Parse, wenzi, |
  {
    v:=A_LoopField, txt:="", cha:=Round(chamax)
    ; �ý���������ÿ���ֿ��ַ�����ʶ��������
    if RegExMatch(v,"\x3C([^>]*)>",r)  ; \x3C����< �ַ�
    {
      StringReplace, v, v, %r%
      txt:=r1
    }
    ; ����������������ÿ�����ֵ��������������ݲ����
    if RegExMatch(v,"\[([^\]]*)]",r)
    {
      StringReplace, v, v, %r%
      cha:=Round(r1)
    }
    ;---------------------------------
    v:=RegExReplace(v,"[^_0\n]+")
    v:=Trim(v,"`n") . "`n", w:=InStr(v,"`n")-1
    if (w< 1 or RegExReplace(v,"[0_]{" w "}\n")!="")
      Continue
    ; ��¼ÿ�����ֵ���ʼλ�á����ߡ�ͻ�䴦���������
    v:=RegExReplace(v,"\n"), h:=StrLen(v)//w
    i:=v~="0_|_0", i+=!i-1, x:=Mod(i,w), y:=i//w
    j.=StrLen(wz) . "|" w "|" h "|" x "|" y "|" cha "|"
    wz.=v, wenzitab[++n]:=Trim(txt)
  }
  SetFormat, IntegerFast, %fmt%
  if wz=
    Return, 0
  if InStr(c,"-")
    wz:=RegExReplace(wz,"_","1"), c:=RegExReplace(c,"-")
  else
    wz:=RegExReplace(RegExReplace(wz,"0","1"),"_","0")
  VarSetCapacity(in,n*6*4,0), i:=-4, k:=n*6+1
  Loop, Parse, j, |
    if (A_Index< k)
      NumPut(A_LoopField, in, i+=4, "int")
  ;--------------------------------------
  ; wz ʹ��Astr�������Ϳ����Զ�תΪANSI���ַ���
  ; in ��������ֵ���ʼλ�õ���Ϣ��out ���ؽ��
  ; ss ��Ϊ��ʱ�ڴ棬jiange ��������ͻ����*��
  ;--------------------------------------
  mode:=!InStr(c,"*"), c:=RegExReplace(c,"\*"), jiange:=5
  if (chamax< 0)
  {
    Return, AHK_OCR(mode, c, jiange, Scan0, Stride
    , sx, sy, sw, sh, wz, n, in, rx, ry, ocr, wenzitab)
  }
  VarSetCapacity(ss,sw*sh), VarSetCapacity(out,1024*4,0)
  if DllCall(&MyFunc, "int",mode, "uint",c
    , "int",jiange, "ptr",Scan0, "int",Stride
    , "int",sx, "int",sy, "int",sw, "int",sh
    , "ptr",&ss, "Astr",wz, "int",n, "ptr",&in, "ptr",&out)
  {
    ocr:="", i:=-4  ; ���ص�һ�����ֵ�����λ��
    x:=NumGet(out,i+=4,"int"), y:=NumGet(out,i+=4,"int")
    w:=NumGet(out,i+=4,"int"), h:=NumGet(out,i+=4,"int")
    rx:=x+(w-1)//2, ry:=y+(h-1)//2
    While (k:=NumGet(out,i+=4,"int"))
      v:=wenzitab[k], ocr.=v="" ? "*" : v
    Return, 1
  }
  Return, 0
}

MCode(ByRef code, hex)
{
  ListLines, Off
  bch:=A_BatchLines
  SetBatchLines, -1
  VarSetCapacity(code, StrLen(hex)//2)
  Loop, % StrLen(hex)//2
    NumPut("0x" . SubStr(hex,2*A_Index-1,2)
      , code, A_Index-1, "char")
  Ptr:=A_PtrSize ? "UPtr" : "UInt"
  DllCall("VirtualProtect", Ptr,&code, Ptr
    ,VarSetCapacity(code), "uint",0x40, Ptr . "*",0)
  SetBatchLines, %bch%
  ListLines, On
}


/************  �������CԴ�� ************

int __attribute__((__stdcall__)) OCR( int mode, unsigned int c
  , int jiange, unsigned char * Bmp, int Stride
  , int sx, int sy, int sw, int sh
  , char * ss, char * wz, int number, int * in, int * out )
{
  //׼���������Ƚ�ͼ���������ʱ�ڴ�ss��ת��Ϊ01�ַ�
  int x, y, o=sy*Stride+sx*4, j=Stride-4*sw, i=0;
  if (mode == 1)    //��ɫģʽ
  {
    int R=(c>>16)&0xFF, G=(c>>8)&0xFF, B=c&0xFF;
    for (y=0; y< sh; ++y, o+=j)
      for (x=0; x< sw; ++x, o+=4)
        ss[i++]=(Bmp[2+o]==R && Bmp[1+o]==G && Bmp[o]==B) ? '1':'0';
  }
  else    //�Ҷȷ�ֵģʽ
  {
    c=(c+1)*1000;
    for (y=0; y< sh; ++y, o+=j)
      for (x=0; x< sw; ++x, o+=4)
        ss[i++]=(Bmp[2+o]*299+Bmp[1+o]*587+Bmp[o]*114< c) ? '1':'0';
  }

  //��ʽ������ss��ÿһ�㶼����һ��ȫ�ֿ�ƥ��
  int o1, o2, x2, y2, w2, h2, tx, ty, cha;
  int sx1=0, sy1=0, sw1=sw, sh1=sh, Ptr=0;

  NextWenzi:
  o=sy1*sw+sx1;
  for (x=0; x< sw1; ++x)
  {
    for (y=0; y< sh1; ++y)
    {
      for (i=0; i< number; ++i)
      {
        w2=in[i*6+1]; h2=in[i*6+2];
        if (x+w2>sw1 || y+h2>sh1)
          continue;
        x2=in[i*6+3]; y2=in[i*6+4];
        o1=o+sw*(y+y2)+(x+x2); o2=in[i*6]+w2*y2+x2;
        c=wz[o2]; cha=in[i*6+5]; j=sw-w2;

        //��01ͻ�䴦��Ϊ4��������ƥ��
        for (tx=x2; tx< w2; ++tx)
        {
          if (ss[o1++]!=wz[o2++] && (--cha)< 0)
            goto NoMatch;
        }
        for (o1+=j, ty=y2+1; ty< h2; ++ty, o1+=j)
        {
          for (tx=0; tx< w2; ++tx)
            if (ss[o1++]!=wz[o2++] && (--cha)< 0)
              goto NoMatch;
        }
        for (o1=o+sw*y+x, ty=0; ty< y2; ++ty, o1+=j)
        {
          for (tx=0; tx< w2; ++tx)
            if (ss[o1++]!=c && (--cha)< 0)
              goto NoMatch;
        }
        for (tx=0; tx< x2; ++tx)
        {
          if (ss[o1++]!=c && (--cha)< 0)
            goto NoMatch;
        }

        //�ɹ��ҵ����ֻ�ͼ��
        if (Ptr==0)
        {
          out[0]=sx+x; out[1]=sy+y;
          out[2]=w2; out[3]=h2; Ptr=4;
          //�ҵ���һ���־�ȷ���������ҵ����·�Χ���ұ߷�Χ
          sy1=y-h2; sh1=h2*3; sw1=h2*10+100;
          if (sy1< 0)
            sy1=0;
          if (sh1>sh-sy1)
            sh1=sh-sy1;
        }
        else if (x>jiange)  //��ǰһ�ּ����Զ�����*��
          out[Ptr++]=-1;
        out[Ptr++]=i+1;
        if (Ptr>1021)    //���ص�int������Ԫ�ظ���������1024
          goto ReturnOK;
        //�����ӵ�ǰ�����ұ��ٴβ���
        sx1+=x+w2;
        if (sw1>sw-sx1)
          sw1=sw-sx1;
        goto NextWenzi;
        //------------
        NoMatch:
        continue;
      }
    }
  }
  if (Ptr==0)
    return 0;
  ReturnOK:
  out[Ptr]=0;
  return 1;
}

*/


;------------------------------------------------
; CԴ����OCR�����Ĵ�AHKʵ�֣������ݲ�ܣ�
;------------------------------------------------
AHK_OCR(mode, c, jiange, Scan0, Stride
  , sx, sy, sw, sh, ByRef wz, number, ByRef in
  , ByRef rx, ByRef ry, ByRef ocr, wenzitab)
{
  bch:=A_BatchLines
  SetBatchLines, -1
  fmt:=A_FormatInteger
  SetFormat, IntegerFast, d    ; ������ʽ��Ҫ��ʮ����
  ; ׼���������Ƚ�ͼ�������ss��ת��Ϊ01�ַ�
  ListLines, Off
  VarSetCapacity(ss,sw*sh,48), k:=-1
  i:=sy*Stride+sx*4-4, j:=Stride-4*sw
  if (mode=1)  ; ��ɫģʽ
  {
    c&=0xFFFFFF
    Loop, %sh% {
      Loop, %sw% {
        k++
        if NumGet(Scan0+0,i+=4,"uint")&0xFFFFFF=c
          NumPut(49,ss,k,"char")
      }
      i+=j
    }
  }
  else  ; �Ҷȷ�ֵģʽ������ɫģʽ����һ��
  {     ; �����ȡ��ɫ��Ϊ�Ҷȣ������ɫģʽ���Կ�
    c:=(c+1)*1000
    Loop, %sh% {
      Loop, %sw% {
        k++
        if NumGet(Scan0+0,i+=4,"uchar")*114
          +NumGet(Scan0+0,i+1,"uchar")*587
          +NumGet(Scan0+0,i+2,"uchar")*299< c
            NumPut(49,ss,k,"char")
      }
      i+=j
    }
  }
  ss:=ocr:=StrGet(&ss,sw*sh,0), ocr:=""
  ListLines, On
  ; ��ʽ������ss��ÿһ�㶼����һ��ȫ�ֿ�ƥ��
  NextWenzi:
  okx:=sw, okn:=0
  Loop, %number% {
    i:=A_Index-1, j:=i*6*4, w2:=NumGet(in,j+4,"uint")
    if (w2>sw)
      Continue
    o2:=NumGet(in,j,"uint"), h2:=NumGet(in,j+8,"uint")
    x2:=NumGet(in,j+12,"uint"), y2:=NumGet(in,j+16,"uint")
    re:=SubStr(wz,o2+1,w2*h2)
    re:=RegExReplace(re,".{" w2 "}","$0`n")
    re:=SubStr(re,y2*(w2+1)+x2+1,-1)
    re:=RegExReplace(re,"\n",".{" (sw-w2) "}")
    if p:=RegExMatch(ss,re)
    {
      x:=Mod(p-1,sw)-x2, y:=(p-1)//sw-y2
      if (x< okx)
        okx:=x, oky:=y, okw:=w2, okh:=h2, okn:=i+1
    }
  }
  if okn
  {
    if ocr=
    {
      rx:=sx+okx+(okw-1)//2, ry:=sy+oky+(okh-1)//2
      j:=oky-okh< 0 ? 0 : (oky-okh)*sw
      ss:=SubStr(ss,j+1,3*okh*sw), maxw:=10*okh+100
    }
    else if (okx>maxw)
      Goto, ReturnOK
    else if (okx>jiange)
      ocr.="*"
    v:=wenzitab[okn], ocr.=v="" ? "*" : v
    j:=okx+okw, sw-=j
    ss:=RegExReplace(ss,".{" j "}(.{" sw "})","$1")
    if sw>0
      Goto, NextWenzi
  }
  ReturnOK:
  SetFormat, IntegerFast, %fmt%
  SetBatchLines, %bch%
  if ocr=
    Return, 0
  Return, 1
}


;============ �ű����� =================

;