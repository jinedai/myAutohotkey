; 开启键盘钩子
#UseHook
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, force
#WinActivateForce
;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode 2
; DetectHiddenWindows,on
; 禁掉CapsLock键
SetCapsLockState, AlwaysOff
; 禁用左Win键
$Space::SendInput {Space}
<LWin::return
;functions
SetSystemCursor(str)
{
    ;替换默认图标
    IDC_ARROW:=32512
    hCursor  := DllCall("LoadCursorFromFile", "Str", "C:\Windows\Cursors\" . str)
    DllCall("SetSystemCursor", "UInt", hCursor, "Int", IDC_ARROW)
    ;替换"I"型编辑光标
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
; 控制滚轮上下左右滚动
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
; 粘贴    
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
;关闭和添加标签页
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

$Appskey::SendInput {Appskey}
<#Space::Send #+{t}

; 窗口布局
Space & q::Send #{left}
Space & o::Send #{right}
Space & g::Send #{up}
Space & b::Send #{down}
; 窗口移动
; 上
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
; 左
^+!h::
    WinGetActiveStats,title_ActiveWindow,var_width,var_height,var_x,var_y
    var_x:=var_x-60
    ifWinActive ahk_class CabinetWClass
    {
        var_y:=var_y-74
    }
    winmove,%title_ActiveWindow%,,%var_x%,%var_y%
    return
; 右
^+!l::
    WinGetActiveStats,title_ActiveWindow,var_width,var_height,var_x,var_y
    var_x:=var_x+60
    ifWinActive ahk_class CabinetWClass
    {
        var_y:=var_y - 74
    }
    winmove,%title_ActiveWindow%,,%var_x%,%var_y%
    return
; 下
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
; -----------------------------------------------------------------------------------  鼠标控制 start  -----------------------------------------------------------
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
    ;获取鼠标相对于窗口的位置
    WinGetPos,var_x_1,var_y_1,,,A
    if GetKeyState("Ctrl", "P")
    {
        if GetKeyState("Shift", "P")
        {
            ;设置菜单热键及显示文本, 目前共42个
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
            gosub Ever_生成菜单
            gosub Ever_开启热键
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
;-------------------------------------------------------------------------------------------- acejump跳转规则菜单块 start  --------------------------------------------------------------
Ever_执行热键:
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
    
    SetTimer, Ever_移除菜单,1
    gosub Ever_关闭热键
    return

;优化想法：这些窗口第一次运行的时候循环一次保存起来，移除只是隐藏不真销毁。然后第二次以后要显示的时候直接显示即可。而且显示菜单块的时候要一起显示不要有那种一个接一个的感觉。
Ever_生成菜单:
    ;~ MsgBox % IndexArray.Length()
    For index, value in IndexArray
        if (index<=menuIndex){
            xtip:=% XArray[index]
            ytip:=% YArray[index]
            Gui,%index%:-Caption +AlwaysOnTop +ToolWindow  ;去标题栏任务栏alttab菜单项与置顶
            Gui,%index%: Color, E91E63 ;设置菜单块背景颜色
            Gui,%index%: Font, s12 w550 cFFFFFF,A Verdana  ;设置下面的文本大小，字体
            Gui,%index%: Margin, x3, y3 ;设置字体控件距离左右上下距离
            Gui,%index%: Add, Text, w18 h18 Center , % IndexArray[index]  ;设置文本，文本颜色
            Gui,%index%: Show, X%xtip% Y%ytip%
        }
    return

Ever_开启热键:  
    Hotkey, Esc, Ever_执行热键, on
    Loop
    {
        if A_Index > %menuIndex%
        {
            break  ; 终止循环
        }
        if A_Index < 1
        {
            continue ; 跳过后面并开始下一次重复
        }
        Hotkey,% IndexArray[A_Index] ,Ever_执行热键,on  ;设置热键只对这个标签生效
        ;~ Hotkey,% IndexArray[A_Index] ,Ever_执行热键2,on
    }
    return

Ever_关闭热键:
    Hotkey, Esc, ,off
    Loop
    {
        if A_Index > %menuIndex%
            break  ; 终止循环
        if A_Index < 1
        continue ; 跳过后面并开始下一次重复
        Hotkey,% IndexArray[A_Index] ,,,off
    }
    return

Ever_移除菜单:
    SetTimer, Ever_移除菜单, off
    ;~ For index, value in array
    Loop
    {
        if A_Index > %menuIndex%
            break  ; 终止循环
        if A_Index < 1
            continue ; 跳过后面并开始下一次重复
        ;~ Gui, %A_Index%:-Parent
        Gui, %A_Index%:Destroy
    }
    return
;-------------------------------------------------------------------------------------------- acejump跳转规则菜单块 end  --------------------------------------------------------------
    
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

; 鼠标左键、右键点击
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
; -----------------------------------------------------------------------------------  鼠标控制 end -----------------------------------------------------------
;CapsLock 映射成Esc
$CapsLock::
    SetCapsLockState, AlwaysOff
    SendInput {ESC}

    ;百度输入法切成英文输入状态
    IME_SET(0)  

    return
; 改变Capslock 状态
Space & 1::
    if GetKeyState("Capslock", "T")
        SetCapsLockState,off
    else
        SetCapsLockState,on
    return
;音量控制
#F11::Send {Volume_Up 1}
; Raise the master volume by 1 interval (typically 5%).
#F12::Send {Volume_Down 3}
; Lower the master volume by 3 intervals.这里如果不加参数的话就是默认5
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


; ------------------   输入法 start  -------------------
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

; 将Ctrl键设置为按下状态
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

; ------------------   输入法 end    -------------------
Appskey & Space::
    IME_SET(0)  
    return
^Space::
    a := IME_SET(1)  
    return
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


