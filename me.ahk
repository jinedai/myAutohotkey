#SingleInstance, force
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
; 禁掉CapsLock键;
SetCapsLockState, AlwaysOff
; 禁用左Win键
LWin::return
<+Space::return
;functions

SetSystemCursor(str)
{
    ;替换标准的箭头
    IDC_ARROW:=32512
    hCursor  := DllCall("LoadCursorFromFile", "Str", "C:\Windows\Cursors\" . str)
    DllCall("SetSystemCursor", "UInt", hCursor, "Int", IDC_ARROW)
    ;替换"I"型光标
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
; 控制滚轮上下左右滚动
Space & f::MouseClick,WheelUp,,,1
Space & d::MouseClick,WheelDown,,,1
Space & c::
    ControlGetFocus, mw_control, A
    if ErrorLevel
    {
        if !GetKeyState("Shift")
            Send {Shift down}
        Loop
        {
            Sleep, 20
            cState  := GetKeyState("C", "P")
            spState := GetKeyState("Space", "P")
            if !cState || !spState
            {
                Send {Shift up}
                break
            }
            MouseClick,WheelUp,,,1
        }
        Sleep, 300
    }
    else
    {
        Loop 2
            SendMessage, 0x114, 0, 0, %mw_control%, A
    }
    return
Space & v::
    ControlGetFocus, mw_control, A
    if ErrorLevel
    {
        if !GetKeyState("Shift")
            Send {Shift down}
        Loop
        {
            Sleep, 50
            cState  := GetKeyState("V", "P")
            spState := GetKeyState("Space", "P")
            if !cState || !spState
            {
                Send {Shift up}
                break
            }
            MouseClick,WheelDown,,,1
        }
        Sleep, 300
    }
    else
    {
        Loop 2
            SendMessage, 0x114, 1, 0, %mw_control%, A
    }
    return
; 使当前窗口处于最前
Space & 3::WinSet, AlwaysOnTop, Toggle, A
; 回退键
Space & u::Send ^{z}
; 复制
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
; 粘贴    
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
;关闭和添加标签页
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
;方向键
Space & j:: Send {down}
Space & l:: Send {right}
Space & h:: Send {left}
Space & k:: Send {up}
;映射Ctrl + R
Space & r::
    Send {Ctrl down}
    sleep 10
    Send {r down}
    Send {r up}
    sleep 10
    Send {Ctrl up}
    return
; 映射 F5
Space & 5:: Send {F5}
;关闭窗口
Space & 4:: Send !{F4}
; 切换简繁体
Space & 2:: Send +{Space}
; 控制窗口的透明度
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
    ;获取鼠标相对于窗口的位置
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

; ------------------   输入法 start  -------------------
Appskey & Space::PostMessage, 0x50, 0, 0x4090409,, A
<^Space::PostMessage, 0x50, 0, 0xe0200804,, A
; ------------------   输入法 end    -------------------

; 窗口布局
Space & q::
    Send #{left}
    MouseMove a_screenwidth/4, a_screenheight/2
    SendInput {click}
    return
Space & o::
    Send #{right}
    MouseMove a_screenwidth*3/4, a_screenheight/2
    SendInput {click}
    return
Space & g::Send #{up}
Space & b::Send #{down}
; 窗口移动
; 上
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
; 左
<^+!h::
    WinGetActiveStats,title_ActiveWindow,var_width,var_height,var_x,var_y
    var_x:=var_x-60
    ifWinActive ahk_class CabinetWClass
    {
        var_y:=var_y-74
    }
    winmove,%title_ActiveWindow%,,%var_x%,%var_y%
    return
; 右
<^+!l::
    WinGetActiveStats,title_ActiveWindow,var_width,var_height,var_x,var_y
    var_x:=var_x+60
    ifWinActive ahk_class CabinetWClass
    {
        var_y:=var_y - 74
    }
    winmove,%title_ActiveWindow%,,%var_x%,%var_y%
    return
; 下
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
; 窗口调大
CapsLock & =::
    WinGetActiveStats,title_ActiveWindow,var_width,var_height,var_x,var_y
    var_width:=var_width+10
    var_height:=var_height+10
    winmove,%title_ActiveWindow%,,%var_x%,%var_y%, %var_width%, %var_height%
    return
; 窗口调小
CapsLock & -::
    WinGetActiveStats,title_ActiveWindow,var_width,var_height,var_x,var_y
    var_width:=var_width-10
    var_height:=var_height-10
    winmove,%title_ActiveWindow%,,%var_x%,%var_y%, %var_width%, %var_height%
    return
;鼠标
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
    if  pressesCount>0
    {
        pressesCount+=1
        return
    }
    else
    {
        sendInput {Blind}{Raw}`$
        pressesCount=1
    }
    SetTimer,WaitKeys,300
    return
WaitKeys:
    SetTimer,WaitKeys,off
    if pressesCount=2
    {
        SendInput {Backspace}
        sendInput {Raw}=>
    }
    pressesCount=0
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
; 将Ctrl键设置为按下状态
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
;    GetKeyState 没带参数P或T, 则为逻辑状态，否则为物理状态
;    GetKeyState, state, Lshift, P
;    弹出消息
;    msgBox %state%
;鼠标
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
;CapsLock 映射成Esc
$CapsLock::
    SetCapsLockState, AlwaysOff
    SendInput {blind}{ESC}
    ;百度输入法切成英文
    PostMessage, 0x50, 0, 0x4090409,, A
    return
; 改变Capslock 状态
Space & 1::
    if GetKeyState("Capslock", "T")
        SetCapsLockState,off
    else
        SetCapsLockState,on
    return
;音量控制
<#F11::Send {Volume_Up 1}
; Raise the master volume by 1 interval (typically 5%).
<#F12::Send {Volume_Down 3}
; Lower the master volume by 3 intervals.这里如果不加参数的话就是默认5
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


; 应用
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
CapsLock & l::Activate("YXMainFrame","C:\Program Files (x86)\Yinxiang Biji\印象笔记\Evernote.exe")
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
