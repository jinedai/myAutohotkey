; �������̹���
#UseHook
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, force
#WinActivateForce
;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode 2
; DetectHiddenWindows,on
; ����CapsLock��
SetCapsLockState, AlwaysOff
; ������Win��
$Space::SendInput {Space}
<LWin::return
;functions
SetSystemCursor(str)
{
    ;�滻Ĭ��ͼ��
    IDC_ARROW:=32512
    hCursor  := DllCall("LoadCursorFromFile", "Str", "C:\Windows\Cursors\" . str)
    DllCall("SetSystemCursor", "UInt", hCursor, "Int", IDC_ARROW)
    ;�滻"I"�ͱ༭���
    IDC_IBEAM:=32513
    hCursor  := DllCall("LoadCursorFromFile", "Str", "C:\Windows\Cursors\" . str)
    DllCall("SetSystemCursor", "UInt", hCursor, "Int", IDC_IBEAM)
}
RestoreCursors()
{
    SPI_SETCURSORS := 0x57
    DllCall("SystemParametersInfo", "UInt", SPI_SETCURSORS, "UInt", 0, "UInt", 0, "UInt", 0)
}
initShiftCtrlStatus(){
    if GetKeyState("Shift")
    {
        Send {Shift up}
        RestoreCursors()
    }
    if GetKeyState("Ctrl")
    {
        Send {Ctrl up}
        RestoreCursors()
    }
}

Space & a::
    if GetKeyState("Ctrl", "P")
        Send ^{Home}
    else
        Send {Home}
    return
Space & s::
    if GetKeyState("Ctrl", "P")
        Send ^{End}
    else
        Send {End}
    return
Space & `;::Send {Enter}
; ���ƹ����������ҹ���
Space & f::MouseClick,WheelUp,,,1
Space & d::MouseClick,WheelDown,,,1
Space & c::
    IfWinActive ahk_class TNavicatMainForm
    {
        ControlGetFocus, mw_control, A
        SendMessage, 0x114, 0, 0, %mw_control%, A
    }
    else
    {
        sendInput {blind}+{WheelUp}
        Send {Shift up}
    }
    return
Space & v::
    IfWinActive ahk_class TNavicatMainForm
    {
        ControlGetFocus, mw_control, A
        SendMessage, 0x114, 1, 0, %mw_control%, A
    }
    else
    {
        sendInput {blind}+{WheelDown}
        Send {Shift up}
    }
    return

; ʹ��ǰ���ڴ�����ǰ
Space & 3::WinSet, AlwaysOnTop, Toggle, A
; ���˼�
Space & u::Send ^{z}
; ����
Space & y::
    if GetKeyState("Shift")
    {
        Send {Shift up}
    }
    if GetKeyState("Ctrl")
    {
        Send {Ctrl up}
    }
    sleep 10
    IfWinActive ahk_class mintty
    {
        send ^{Ins}
    }
    else
    {
        Send ^{c}
    }
    SetSystemCursor("aero_busy_xl.ani")
    sleep 1000
    RestoreCursors()
    return
; ճ��    
Space & p::
    initShiftCtrlStatus()
    IfWinActive ahk_class mintty
    {
        send +{Ins}
    }
    else
    {
    Send ^{v}
    }
    return
;map Ctrl+CapsLock And Shift+Ctrl+CapsLock
Space & Tab::Send +{Tab}
Space & e::
    Send {Ctrl down}
    Keywait,Ctrl,T1
    Send {Tab down}
    Send {Tab up}
    sleep 10
    Send {Ctrl up}
    return
Space & w::
    Send {Ctrl down}
    Send {Shift down}
    sleep 10
    Send {Tab down}
    Send {Tab up}
    sleep 10
    Send {Shift up}
    Send {Ctrl up}
    return
;�رպ���ӱ�ǩҳ
Space & z::
    initShiftCtrlStatus()
    Send ^{w}
    return
Space & x::
    initShiftCtrlStatus()
    Send ^{x}
    return
Space & t::Send ^{t}
Space & n::
    if GetKeyState("Ctrl", "P")
    {
        Send +{home}{Backspace}
    }
    else
    {
        Send {Backspace}
    }
    return
Space & m::
    if GetKeyState("Ctrl", "P")
        Send +{end}{Delete}
    else
        Send {Delete}
    return
;�����
Space & j:: Send {down}
Space & l:: Send {right}
Space & h:: Send {left}
Space & k:: Send {up}
;ӳ��Ctrl + R
Space & r::
    Send {Ctrl down}
    sleep 10
    Send {r down}
    Send {r up}
    sleep 10
    Send {Ctrl up}
    return
; ӳ�� F5
Space & 5:: Send {F5}
;�رմ���
Space & 4:: Send !{F4}
; �л�����
Space & 2:: Send +{Space}
; ���ƴ��ڵ�͸����
Space & 6::
    WinGet, Transparent, Transparent, A
    if Transparent = 150
        WinSet,Transparent,off,A
    else
        WinSet,Transparent,150,A
    return
+Space::Send +{Space}

$Appskey::SendInput {Appskey}
<#Space::Send #+{t}

; ���ڲ���
Space & q::Send #{left}
Space & o::Send #{right}
Space & g::Send #{up}
Space & b::Send #{down}
; �����ƶ�
; ��
^+!k::
    WinGetActiveStats,title_ActiveWindow,var_width,var_height,var_x,var_y
    var_y:=var_y-60
    ifWinActive ahk_class CabinetWClass
    {
        var_x:=var_x - 8
        var_y:=var_y - 74
    }
    winmove,%title_ActiveWindow%,,%var_x%,%var_y%
    return
; ��
^+!h::
    WinGetActiveStats,title_ActiveWindow,var_width,var_height,var_x,var_y
    var_x:=var_x-60
    ifWinActive ahk_class CabinetWClass
    {
        var_y:=var_y-74
    }
    winmove,%title_ActiveWindow%,,%var_x%,%var_y%
    return
; ��
^+!l::
    WinGetActiveStats,title_ActiveWindow,var_width,var_height,var_x,var_y
    var_x:=var_x+60
    ifWinActive ahk_class CabinetWClass
    {
        var_y:=var_y - 74
    }
    winmove,%title_ActiveWindow%,,%var_x%,%var_y%
    return
; ��
^+!j::
    WinGetActiveStats,title_ActiveWindow,var_width,var_height,var_x,var_y
    var_y:=var_y+60
    ifWinActive ahk_class CabinetWClass
    {           
        var_x:=var_x - 8
        var_y:=var_y - 74
    }
    winmove,%title_ActiveWindow%,,%var_x%,%var_y%
    return
; ���ڵ���
CapsLock & =::
    WinGetActiveStats,title_ActiveWindow,var_width,var_height,var_x,var_y
    var_width:=var_width+10
    var_height:=var_height+10
    winmove,%title_ActiveWindow%,,%var_x%,%var_y%, %var_width%, %var_height%
    return
; ���ڵ�С
CapsLock & -::
    WinGetActiveStats,title_ActiveWindow,var_width,var_height,var_x,var_y
    var_width:=var_width-10
    var_height:=var_height-10
    winmove,%title_ActiveWindow%,,%var_x%,%var_y%, %var_width%, %var_height%
    return

Space & i::
    if  vCount>0
    {
        vCount+=1
        return
    }
    else
    {
        sendInput {Blind}{Raw}`$
        vCount=1
    }
    SetTimer,WaitKeys,400
    return
WaitKeys:
    SetTimer,WaitKeys,off
    if vCount=2
    {
        SendInput {Backspace}
        sendInput {Raw}=
    }
    else if vCount > 2
    {
        SendInput {Backspace}
        sendInput {Raw}=>
    }
    vCount=0
    return
; -----------------------------------------------------------------------------------  ������ start  -----------------------------------------------------------
Appskey & ,::
    GetKeyState, state, LButton
    if state = U
    {
        SendEvent {Click down}
        SetSystemCursor("beam_rl.cur")
    }
    else
    {
        SendEvent {Click up}
        RestoreCursors()
    }
    return
Appskey & i::
    if GetKeyState("Ctrl", "P")
    {
        CoordMode, Mouse, Screen
        MouseMove a_screenwidth/2, a_screenheight/2
        CoordMode, Mouse, Window
    }
    else
    {
        WinGetPos,var_x_1,var_y_1,var_width,var_height,A
        var_x:= var_width/2
        var_y:= var_height/2
        MouseMove var_x,var_y
    }
    return
Appskey & y::
    WinGetPos,var_rx,var_ry,var_width,var_height,A
    if GetKeyState("Ctrl", "P")
    {
        if GetKeyState("Shift", "P")
        {
            var_x:=-var_rx-40
            var_y:=-var_ry-40
        }
        else
        {
            var_x := 50
            var_y := 50
        }
    }
    else
    {
        var_x := var_width / 4
        var_y := var_height /4
    }
    MouseMove %var_x%,%var_y%
    return
Appskey & u::
    WinGetPos,var_rx,var_ry,var_width,var_height,A
    if GetKeyState("Ctrl", "P")
    {
        if GetKeyState("Shift", "P")
        {
            var_x:=a_screenwidth - var_rx -40
            var_y:=-var_ry
        }
        else
        {
            var_x := var_width - 40
            var_y := 40
        }
    }
    else
    {
        var_x := var_width * 3 / 4
        var_y := var_height /4
    }
    MouseMove %var_x%,%var_y%
    return
Appskey & p::
    WinGetPos,var_rx,var_ry,var_width,var_height,A
    if GetKeyState("Ctrl", "P")
    {
        if GetKeyState("Shift", "P")
        {
            var_x:=a_screenwidth-var_rx-40
            var_y:=a_screenheight-var_ry+40
        }
        else
        {
            var_x:= var_width-40
            var_y:= var_height-40
        }
    }
    else
    {
        var_x:= var_width * 3 / 4
        var_y:= var_height * 3 / 4
    }
    MouseMove %var_x%,%var_y%
    return
Appskey & o::
    WinGetPos,var_rx,var_ry,var_width,var_height,A
    if GetKeyState("Ctrl", "P")
    {
        if GetKeyState("Shift", "P")
        {
            var_x:=-var_rx-40
            var_y:=a_screenheight-var_ry+40
        }
        else
        {
            var_x := 40
            var_y := var_height-40
        }
    }
    else
    {
        var_x:= var_width/4
        var_y:= var_height*3/4
    }
    MouseMove %var_x%,%var_y%
    return
Appskey & `;::
    ;��ȡ�������ڴ��ڵ�λ��
    WinGetPos,var_x_1,var_y_1,,,A
    if GetKeyState("Ctrl", "P")
    {
        if GetKeyState("Shift", "P")
        {
            ;���ò˵��ȼ�����ʾ�ı�, Ŀǰ��42��
            IndexArray :=["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","1","2","3","4","5","6","7","8","9","0","[","]","-","=",",","."]

            xSpace := (a_screenwidth  - 200) / 6
            ySpace := (a_screenheight - 200) / 5
            XArray:=[]
            YArray:=[]
            loop ,6
            {
                tmpY := 100 + (a_index - 1) * ySpace
                loop ,7
                {
                    XArray.Push(100 + xSpace * (a_index - 1))
                    YArray.Push(tmpY)
                }
            }

            menuIndex:= % XArray.Length()
            gosub Ever_���ɲ˵�
            gosub Ever_�����ȼ�
        }else{
            if vCount>0
            {
                vCount+=1
                return
            }
            else
            {
                MouseMove a_screenwidth/2 - var_x_1, a_screenheight/4 - var_y_1
                vCount=1
            }
            SetTimer, symmetryHMouse, 300
        }
    }else{
        if vCount>0
        {
            vCount+=1
            return
        }
        else
        {
            MouseMove a_screenwidth/4 -var_x_1, a_screenheight/2 - var_y_1
            vCount=1
        }
        SetTimer, symmetryMouse, 300
    }
    return

symmetryMouse:
    SetTimer, symmetryMouse,off
    if vCount > 1
        MouseMove a_screenwidth*3/4 - var_x_1, a_screenheight/2 - var_y_1
    vCount=0
    return
symmetryHMouse:
    SetTimer, symmetryHMouse,off
    if vCount > 1
        MouseMove a_screenwidth/2 -var_x_1, a_screenheight*3/4 - var_y_1
    vCount=0
    return
;-------------------------------------------------------------------------------------------- acejump��ת����˵��� start  --------------------------------------------------------------
Ever_ִ���ȼ�:
    For index, value in IndexArray
        if (A_ThisHotkey = value){
            if (index<=menuIndex){
                xtip:=% XArray[index]
                ytip:=% YArray[index]
                CoordMode, Mouse, Screen
                MouseMove xtip, ytip
                CoordMode, Mouse, Window
            }
        }
    
    SetTimer, Ever_�Ƴ��˵�,1
    gosub Ever_�ر��ȼ�
    return

;�Ż��뷨����Щ���ڵ�һ�����е�ʱ��ѭ��һ�α����������Ƴ�ֻ�����ز������١�Ȼ��ڶ����Ժ�Ҫ��ʾ��ʱ��ֱ����ʾ���ɡ�������ʾ�˵����ʱ��Ҫһ����ʾ��Ҫ������һ����һ���ĸо���
Ever_���ɲ˵�:
    ;~ MsgBox % IndexArray.Length()
    For index, value in IndexArray
        if (index<=menuIndex){
            xtip:=% XArray[index]
            ytip:=% YArray[index]
            Gui,%index%:-Caption +AlwaysOnTop +ToolWindow  ;ȥ������������alttab�˵������ö�
            Gui,%index%: Color, E91E63 ;���ò˵��鱳����ɫ
            Gui,%index%: Font, s12 w550 cFFFFFF,A Verdana  ;����������ı���С������
            Gui,%index%: Margin, x3, y3 ;��������ؼ������������¾���
            Gui,%index%: Add, Text, w18 h18 Center , % IndexArray[index]  ;�����ı����ı���ɫ
            Gui,%index%: Show, X%xtip% Y%ytip%
        }
    return

Ever_�����ȼ�:  
    Hotkey, Esc, Ever_ִ���ȼ�, on
    Loop
    {
        if A_Index > %menuIndex%
        {
            break  ; ��ֹѭ��
        }
        if A_Index < 1
        {
            continue ; �������沢��ʼ��һ���ظ�
        }
        Hotkey,% IndexArray[A_Index] ,Ever_ִ���ȼ�,on  ;�����ȼ�ֻ�������ǩ��Ч
        ;~ Hotkey,% IndexArray[A_Index] ,Ever_ִ���ȼ�2,on
    }
    return

Ever_�ر��ȼ�:
    Hotkey, Esc, ,off
    Loop
    {
        if A_Index > %menuIndex%
            break  ; ��ֹѭ��
        if A_Index < 1
        continue ; �������沢��ʼ��һ���ظ�
        Hotkey,% IndexArray[A_Index] ,,,off
    }
    return

Ever_�Ƴ��˵�:
    SetTimer, Ever_�Ƴ��˵�, off
    ;~ For index, value in array
    Loop
    {
        if A_Index > %menuIndex%
            break  ; ��ֹѭ��
        if A_Index < 1
            continue ; �������沢��ʼ��һ���ظ�
        ;~ Gui, %A_Index%:-Parent
        Gui, %A_Index%:Destroy
    }
    return
;-------------------------------------------------------------------------------------------- acejump��ת����˵��� end  --------------------------------------------------------------
    
Appskey & '::
    return
;Control The Mouse
Appskey & k::
    Loop
    {
        cState  := GetKeyState("K", "P")
        spState := GetKeyState("Appskey", "P")
        if !cState || !spState
        {
            break
        }
        if GetKeyState("Ctrl", "P")
        {
            if GetKeyState("Shift", "P")
            {
                WinGetPos,,,var_width,var_height,A
                var_x:= var_width / 2
                var_y:= 40
                MouseMove %var_x%,%var_y%
                break
            }
            else
            {
                var_v := 1
            }
        }
        else
        {
            var_v := 10
        }
        MouseMove, 0, -%var_v%, 0, R
    }
    return
Appskey & j::
    Loop
    {
        cState  := GetKeyState("J", "P")
        spState := GetKeyState("Appskey", "P")
        if !cState || !spState
        {
            break
        }
        if GetKeyState("Ctrl", "P")
        {
            if GetKeyState("Shift", "P")
            {
                WinGetPos,,,var_width,var_height,A
                var_x:= var_width / 2
                var_y:= var_height - 40
                MouseMove %var_x%,%var_y%
                break
            }
            else
            {
                var_v := 1
            }
        }
        else
        {
            var_v := 10
        }
        MouseMove, 0, %var_v%, 0, R
    }
    return
Appskey & h::
    Loop
    {
        cState  := GetKeyState("H", "P")
        spState := GetKeyState("Appskey", "P")
        if !cState || !spState
        {
            break
        }
        if GetKeyState("Ctrl", "P")
        {
            if GetKeyState("Shift", "P")
            {
                WinGetPos,,,var_width,var_height,A
                var_x:= 40
                var_y:= var_height / 2
                MouseMove %var_x%,%var_y%
                break
            }
            else
            {
                var_v := 1
            }
        }
        else
        {
            var_v := 10
        }
        MouseMove, -%var_v%, 0, 0, R
    }
    return
Appskey & l::
    Loop
    {
        cState  := GetKeyState("L", "P")
        spState := GetKeyState("Appskey", "P")
        if !cState || !spState
        {
            break
        }
        if GetKeyState("Ctrl", "P")
        {
            if GetKeyState("Shift", "P")
            {
                WinGetPos,,,var_width,var_height,A
                var_x:= var_width - 40
                var_y:= var_height / 2
                MouseMove %var_x%,%var_y%
                break
            }
            else
            {
                var_v := 1
            }
        }
        else
        {
            var_v := 10
        }
        MouseMove, %var_v%, 0, 0, R
    }
    return

; ���������Ҽ����
Appskey & n::
    SendEvent {Blind}{LButton down}
    ;KeyWait n; Prevents keyboard auto-repeat from repeating the mouse click.
    SendEvent {Blind}{LButton up}
    return
Appskey & m::
    SendEvent {Blind}{RButton down}
    ;KeyWait n; Prevents keyboard auto-repeat from repeating the mouse click.
    SendEvent {Blind}{RButton up}
    return
; -----------------------------------------------------------------------------------  ������ end -----------------------------------------------------------
;CapsLock ӳ���Esc
$CapsLock::
    SetCapsLockState, AlwaysOff
    SendInput {ESC}

    ;�ٶ����뷨�г�Ӣ������״̬
    IME_SET(0)  

    return
; �ı�Capslock ״̬
Space & 1::
    if GetKeyState("Capslock", "T")
        SetCapsLockState,off
    else
        SetCapsLockState,on
    return
;��������
#F11::Send {Volume_Up 1}
; Raise the master volume by 1 interval (typically 5%).
#F12::Send {Volume_Down 3}
; Lower the master volume by 3 intervals.����������Ӳ����Ļ�����Ĭ��5
#F10::Send {Volume_Mute}
Appskey & [::
    if GetKeyState("Ctrl", "P")
        send !{up}
    else
        send !{left}
    return
Appskey & ]::
    if GetKeyState("Ctrl", "P")
        send !{up}
    else
        send !{right}
    return

Appskey & 6::send !{6}
Appskey & 7::send !{7}
Appskey & 8::send !{8}
Appskey & 9::send !{9}


; ------------------   ���뷨 start  -------------------
IME_SET(setSts, WinTitle="")
{
;    DllCall("SendMessage", UInt, WinActive("A"), UInt, 80, UInt, 1, UInt, DllCall("LoadKeyboardLayout", Str,"E0210804", UInt, 1))
    send ^``
    ifEqual WinTitle,,  SetEnv,WinTitle,A
    WinGet,hWnd,ID,%WinTitle%
    DefaultIMEWnd := DllCall("imm32\ImmGetDefaultIMEWnd", Uint, hWnd, Uint)
    ;Message : WM_IME_CONTROL  wParam:IMC_SETOPENSTATUS
    DetectSave := A_DetectHiddenWindows
    DetectHiddenWindows,ON
    SendMessage 0x283, 0x006, %setSts%,,ahk_id %DefaultIMEWnd%
    DetectHiddenWindows,%DetectSave%
    Return ErrorLevel
}


IME_GET(WinTitle="")
{
    ifEqual WinTitle,,  SetEnv,WinTitle,A
    WinGet,hWnd,ID,%WinTitle%
    DefaultIMEWnd := DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hWnd, Uint)
    ;Message : WM_IME_CONTROL  wParam:IMC_GETOPENSTATUS
    DetectSave := A_DetectHiddenWindows
    DetectHiddenWindows,ON
    SendMessage 0x283, 0x005,0,,ahk_id %DefaultIMEWnd%
    DetectHiddenWindows,%DetectSave%
    Return ErrorLevel
}

; ��Ctrl������Ϊ����״̬
Space & ,::
    Keywait, `,, , t0.1
    if errorlevel = 1
    {
        if GetKeyState("Shift")
        {
            Send {Shift up}
            RestoreCursors()
        }
        else
        {
            Send {Shift down}
            SetSystemCursor("busy_l.cur")
        }
    }
    else
    {
        Keywait, `,, d, t0.2
        if errorlevel = 0
        {
            if GetKeyState("Shift")
            {
                Send {Shift up}
            }
            if GetKeyState("Ctrl")
            {
                Send {Ctrl up}
                RestoreCursors()
            }
            else
            {
                Send {Ctrl down}
                SetSystemCursor("aero_link_xl.cur")
            }
        }
    }
    return

; ------------------   ���뷨 end    -------------------
Appskey & Space::
    IME_SET(0)  
    return
^Space::
    a := IME_SET(1)  
    return
; Ӧ��
Activate(t,p)
{
    WinGet, count, Count, ahk_class %t%
    if count > 1
    {
        global winProcess, currentWin := t
        if (winProcess > 0)
        {
            winProcess += 1
            return
        }
        winProcess := 1
        SetTimer, changeWin, -400
    }
    else
    {
        IfWinActive ahk_class %t%
        {
          return
        }
        SetTitleMatchMode 2   
        IfWinExist ahk_class %t%
        {
          WinShow
          WinActivate           
          return
        }
        Run %p%
    }
    return
}
changeWin:
;WinGet, active_id, ID, ahk_exe TIM.exe
    WinGet, id, List, ahk_class %currentWin%
;    Loop, %id%
;    {
        this_id := id%winProcess%
        WinActivate, ahk_id %this_id%
        winProcess := 0
;        WinGetClass, this_class, ahk_id %this_id%
;        WinGetTitle, this_title, ahk_id %this_id%
;        MsgBox, 4, , Visiting All Windows`n%A_Index% of %id%`nahk_id %this_id%`nahk_class %this_class%`n%this_title%`n`nContinue?
;        IfMsgBox, NO, break
;    }
    return

CapsLock & h::Activate("Chrome_WidgetWin_1","chrome")
CapsLock & j::Activate("SunAwtFrame","D:\PhpStorm 2019.1\bin\phpstorm64.exe")
CapsLock & k::Activate("TNavicatMainForm","D:\Navicat Premium\navicat.exe")
;CapsLock & !k::Activate("TMainForm","D:\heidisql\heidisql.exe")
CapsLock & l::Activate("YXMainFrame","D:\Yinxiang Biji\Evernote.exe")
CapsLock & p::Activate("Microsoft-Windows-Tablet-SnipperEditor","c:\Windows\System32\SnippingTool.exe")
CapsLock & `;::Activate("CabinetWClass", "C:\Windows\explorer.exe")
CapsLock & n::Activate("EVERYTHING", "everything")
CapsLock & m::Activate("Vim","gvim")
;CapsLock & u::Activate("WindowsForms10.Window.8.app.0.141b42a_r10_ad1","d:\Fiddler\Fiddler.exe")
CapsLock & u::Activate("XLMAIN","excel")
CapsLock & o::Activate("OpusApp", "word")
;CapsLock & p::Activate("WeChatMainWndForPC", "D:\Tencent\WeChat\WeChatWeb.exe")
;#e::Activate("CabinetWClass", "C:\Windows\explorer.exe")
;CapsLock & o::Activate("TFoxMainFrm.UnicodeClass", "C:\Foxmail 7.2\Foxmail.exe")
CapsLock & y::Activate("Qt5QWindowIcon", "D:\VirtualBox\VirtualBox.exe")


