Loop, %0%  ; For each parameter:
{
    param := %A_Index%  ; Fetch the contents of the variable whose name is contained in A_Index.
    params .= A_Space . param
}
ShellExecute := A_IsUnicode ? "shell32\ShellExecute":"shell32\ShellExecuteA"
if not A_IsAdmin
{
    If A_IsCompiled
       DllCall(ShellExecute, uint, 0, str, "RunAs", str, A_ScriptFullPath, str, params , str, A_WorkingDir, int, 3)
    Else
       DllCall(ShellExecute, uint, 0, str, "RunAs", str, A_AhkPath, str, """" . A_ScriptFullPath . """" . A_Space . params, str, A_WorkingDir, int, 1)
    ExitApp
}
;init
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode 2
; DetectHiddenWindows,on
; ����CapsLock��
SetCapsLockState, AlwaysOff
; ������Win��
LWin::return
<+Space::return
;functions
Activate(t,p)
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
  return
}
SetSystemCursor(str)
{
    ;�滻��׼�ļ�ͷ
    IDC_ARROW:=32512
    hCursor  := DllCall("LoadCursorFromFile", "Str", "C:\Windows\Cursors\" . str)
    DllCall("SetSystemCursor", "UInt", hCursor, "Int", IDC_ARROW)
    ;�滻"I"�͹��
    IDC_IBEAM:=32513
    hCursor  := DllCall("LoadCursorFromFile", "Str", "C:\Windows\Cursors\" . str)
    DllCall("SetSystemCursor", "UInt", hCursor, "Int", IDC_IBEAM)
}
RestoreCursors()
{
    SPI_SETCURSORS := 0x57
    DllCall("SystemParametersInfo", "UInt", SPI_SETCURSORS, "UInt", 0, "UInt", 0, "UInt", 0)
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
    ControlGetFocus, mw_control, A
    SendMessage, 0x114, 0, 0, %mw_control%, A
;    if !GetKeyState("Shift")
;        Send {Shift down}
;    Loop
;    {
;        Sleep, 20
;        cState  := GetKeyState("C", "P")
;        spState := GetKeyState("Space", "P")
;        if !cState || !spState
;        {
;            Send {Shift up}
;            break
;        }
;        MouseClick,WheelUp,,,1
;    }
;    Sleep, 300
    return
Space & v::
    ControlGetFocus, mw_control, A
    SendMessage, 0x114, 1, 0, %mw_control%, A
;    if !GetKeyState("Shift")
;        Send {Shift down}
;    Loop
;    {
;        Sleep, 50
;        cState  := GetKeyState("V", "P")
;        spState := GetKeyState("Space", "P")
;        if !cState || !spState
;        {
;            Send {Shift up}
;            break
;        }
;        MouseClick,WheelDown,,,1
;    }
;    Sleep, 300
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
Space & z::Send ^{w}
Space & x::
    if shiftFlag = 1
    {
        SendInput {RShift up}
        shiftFlag:=0
    }
    Send ^{x}
    RestoreCursors()
    return
Space & t::Send ^{t}
Space & n::Send {Backspace}
Space & m::
    if GetKeyState("Ctrl", "P")
        Send +{Delete}
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

$Space::SendInput {Space}
$Appskey::SendInput {Appskey}
x_posFlag := 0
y_posFlag := 0
Appskey & `;::
    ;��ȡ�������ڴ��ڵ�λ��
    WinGetPos,var_x_1,var_y_1,,,A
    if GetKeyState("Ctrl", "P")
    {
        if GetKeyState("Shift", "P")
        {
            MouseGetPos,var_x,var_y
            MouseMove 2*(a_screenwidth/2-var_x_1)-var_x, var_y
        }else{
            if y_posFlag
            {
                MouseMove a_screenwidth/2 - var_x_1, a_screenheight/4 - var_y_1
                y_posflag := 0
            }else{
                MouseMove a_screenwidth/2 -var_x_1, a_screenheight*3/4 - var_y_1
                y_posflag := 1
            }
        }
    }else{
        if x_posFlag
        {
            MouseMove a_screenwidth*3/4 - var_x_1, a_screenheight/2 - var_y_1
            x_posflag := 0
        }else{
            MouseMove a_screenwidth/4 -var_x_1, a_screenheight/2 - var_y_1
            x_posflag := 1
        }
    }
    return
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
<#Space::Send <#+{t}
Appskey & Space::
    Send ^``
    sleep 10
    Send {LShift}
    sleep 300
    return
; ���뷨
<^Space::
    Send ^``
    sleep 300
    return
; ���ڲ���
Space & q::
    WinGetActiveStats,title_ActiveWindow,var_width,var_height,var_x,var_y
    winmove,%title_ActiveWindow%,, 0, 0, A_ScreenWidth/2, A_ScreenHeight
    return
Space & o::
    WinGetActiveStats,title_ActiveWindow,var_width,var_height,var_x,var_y
    winmove,%title_ActiveWindow%,, A_ScreenWidth/2, 0, A_ScreenWidth/2, A_ScreenHeight
    return
Space & g::
    WinGetActiveStats,title_ActiveWindow,var_width,var_height,var_x,var_y
    winmove,%title_ActiveWindow%,, 0, 0, A_ScreenWidth, A_ScreenHeight
    return
Space & b::Send #{down}
; �����ƶ�
; ��
<^+!k::
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
<^+!h::
    WinGetActiveStats,title_ActiveWindow,var_width,var_height,var_x,var_y
    var_x:=var_x-60
    ifWinActive ahk_class CabinetWClass
    {
        var_y:=var_y-74
    }
    winmove,%title_ActiveWindow%,,%var_x%,%var_y%
    return
; ��
<^+!l::
    WinGetActiveStats,title_ActiveWindow,var_width,var_height,var_x,var_y
    var_x:=var_x+60
    ifWinActive ahk_class CabinetWClass
    {
        var_y:=var_y - 74
    }
    winmove,%title_ActiveWindow%,,%var_x%,%var_y%
    return
; ��
<^+!j::
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
;���
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
Space & i::
    if GetKeyState("Alt", "P")
    {
        sendInput {Raw}=>
    }
    else
    {
        sendInput {Blind}{Raw}`$
    }

    sleep 300
    return
Appskey & b::
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
    sleep 300
    return
; ��Ctrl������Ϊ����״̬
Appskey & g::
    if GetKeyState("Ctrl")
    {
        Send {Ctrl up}
        RestoreCursors()
    }
    else{
        Send {Ctrl down}
        SetSystemCursor("aero_link_xl.cur")
    }
    sleep 300
    return
;    GetKeyState û������P��T, ��Ϊ�߼�״̬������Ϊ����״̬
;    GetKeyState, state, Lshift, P
;    ������Ϣ
;    msgBox %state%
;���
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
    WinGetPos,var_x_1,var_y_1,var_width,var_height,A
    if GetKeyState("Ctrl", "P")
    {
        MouseMove a_screenwidth/2-var_x_1,a_screenheight/2-var_y_1
    }
    else
    {
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
            var_x:=-var_rx+40
            var_y:=-var_ry+40
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
            var_y:=a_screenheight-var_ry
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
            var_x:=-var_rx+40
            var_y:=a_screenheight-var_ry-40
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
;CapsLock ӳ���Esc
$CapsLock::
    SetCapsLockState, AlwaysOff
    Send, {ESC}
    
    ;�ٶ����뷨�г�Ӣ��
    Send ^``
    sleep 10
    Send {LShift}

    sleep 300
    return
; �ı�Capslock ״̬
Space & 1::
    if GetKeyState("Capslock", "T")
        SetCapsLockState,off
    else
        SetCapsLockState,on
    return
;��������
<#F11::Send {Volume_Up 1}
; Raise the master volume by 1 interval (typically 5%).
<#F12::Send {Volume_Down 3}
; Lower the master volume by 3 intervals.����������Ӳ����Ļ�����Ĭ��5
<#F10::Send {Volume_Mute}
Appskey & [::
    if GetKeyState("Ctrl", "P")
        send <!{up}
    else
        send <!{left}
    return
Appskey & ]::
    if GetKeyState("Ctrl", "P")
        send <!{up}
    else
        send <!{right}
    return
Appskey & 6::send <!{6}
Appskey & 7::send <!{7}
Appskey & 8::send <!{8}
Appskey & 9::send <!{9}


; Ӧ��
CapsLock & h::Activate("Chrome_WidgetWin_1","chrome")
CapsLock & j::Activate("SunAwtFrame","D:\PhpStorm 2019.1\bin\phpstorm64.exe")
CapsLock & k::Activate("TNavicatMainForm","D:\Navicat Premium\navicat.exe")
;CapsLock & !k::Activate("TMainForm","D:\heidisql\heidisql.exe")
CapsLock & l::Activate("YXMainFrame","C:\Program Files (x86)\Yinxiang Biji\ӡ��ʼ�\Evernote.exe")
CapsLock & `;::Activate("CabinetWClass", "C:\Windows\explorer.exe")
CapsLock & n::Activate("EVERYTHING", "C:\Program Files\Everything\Everything.exe")
CapsLock & m::Activate("Vim","gvim")
CapsLock & y::Activate("Qt5QWindowIcon","d:\VirtualBox\VirtualBox.exe")
CapsLock & u::Activate("WindowsForms10.Window.8.app.0.141b42a_r10_ad1","d:\Fiddler\Fiddler.exe")
;CapsLock & o::Activate("HwndWrapper[AxureRP.exe;;a346c183-6bcd-4041-9886-11ded0117eb9]", "D:\Axure\AxureRPProPortable\AxureRP.exe")
;CapsLock & p::Activate("WeChatMainWndForPC", "D:\Tencent\WeChat\WeChatWeb.exe")
#e::Activate("CabinetWClass", "C:\Windows\explorer.exe")
;CapsLock & i::Activate("AcrobatSDIWindow","C:\Program Files (x86)\Adobe\Reader 11.0\Reader\AcroRd32.exe")
;CapsLock & u::Activate("OpusApp","C:\Program Files (x86)\Microsoft Office\Office14\WINWORD.EXE")
;CapsLock & o::Activate("HwndWrapper[AxureRP.exe;;a346c183-6bcd-4041-9886-11ded0117eb9]", "D:\Axure\AxureRPProPortable\AxureRP.exe")
;CapsLock & p::Activate("WeChatMainWndForPC", "D:\Tencent\WeChat\WeChatWeb.exe")
