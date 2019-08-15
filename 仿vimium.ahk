/*
说明：
1.指定应用窗口、指定热键弹出指定菜单块，点击热键，点击当前坐标处的菜单块(后续可以设置为其他操作)，
2.规则排布的菜单块，设定初始xy坐标与间距即可，不规则排布的菜单块，需要设定固定的xy坐标
3.适用于微信、TIM、浏览器书签等
4.目标是想像Word与vimium那样做到菜单块颜色自定义，菜单块数量不限。随机或者按设置规律生成组合热键，如sa，se，sr。感觉就平常用的话也没这个必要了
5.如有需求与兴趣的朋友可以升级一下，还有很多想法没有实现。
作者：Ever
联系：794781196
使用：在tim窗口或者微信窗口，按下左alt键放开。自定义配置可参照下面tim与微信的。
*/


;这些配置最好是能弄个配置文件配置，直接在ini里面配置。
;在tim下		
F10::   ;热键设置
    ;设置规则菜单块
    IndexArray :=["S","A","D","F","Q","W","E","R","Z","X","C","V","1","2","3","4","T","G","B","J","K","L","H","U","N","M",",",".","5","6","7","8","9","0"]   ;设置菜单热键及显示文本
    ;WinGet, controls, ControlList, ahk_class TNavicatMainForm
    WinGet, ActiveControlList, ControlList, A
    XArray:=[]   ;设置x坐标
    YArray:=[]  ;设置y坐标
    Loop, Parse, ActiveControlList, `n
    {
;        msgBox %A_LoopField%
        ControlGetPos , X, Y, Width, Height, %A_LoopField%, A
        if Y < 0 
            continue
        MsgBox %X%  %Y%  %Width%  %Height%  %A_LoopField%
        XArray.Push(X)
        YArray.Push(Y)

    }
;   loop %controls%
;   {
;       ControlGetPos , X, Y, Width, Height, controls%a_index%
;       msgBox %X%  %Y%
;   }
    
    ;~ MsgBox, %active_id%
    ;设置不规则菜单块
;   ;XArray.InsertAt(4,QQFile)  ;往xarray插入数据
;   ;XArray.InsertAt(5,QQChat)
    menuIndex:= % XArray.Length()   ;设置不规则菜单块数量，根据坐标数量设定，没有可设置为0
    gosub Ever_生成菜单
    gosub Ever_开启热键
    return


;-------------------------------点击对应热键后的菜单----------------------------

Ever_TIM不常用群聊:
IndexArray :=["S","A","D","F","Q","W","E","R","Z","X","C","V","1","2","3","4","T","G","B","J","K","L","H","U","N","M",",",".","5","6","7","8","9","0"]  
IndexArray.RemoveAt(1)  
;~ IndexArray.RemoveAt(11) 
WinGet, active_id, ID, ahk_exe TIM.exe
WinGetPos,X, Y, Width, Height, ahk_id %active_id%
xtip0:= % Width-300  ;设置起始x坐标
ytip0:=85  ;设置起始y坐标
xspacing:=0  ;设置x间距
yspacing:=78  ;设置y间距
menuIndex:= % Height/yspacing-1  
menuIndex2:= 0
menuIndex3:= % menuIndex
gosub Ever_生成菜单
gosub Ever_开启热键
return

Ever_TIM文件下载:
IndexArray :=["S","A","D","F","Q","W","E","R","Z","X","C","V","1","2","3","4","T","G","B","J","K","L","H","U","N","M",",",".","5","6","7","8","9","0"]  
IndexArray.RemoveAt(11)  
WinGet, active_id, ID, ahk_exe TIM.exe
WinGetPos,X, Y, Width, Height, ahk_id %active_id%
xtip0:= % Width-80  ;设置起始x坐标
ytip0:=193  ;设置起始y坐标
xspacing:=0  ;设置x间距
yspacing:=50  ;设置y间距
;设置不规则菜单块
XArray:=[]
YArray:=["157"]
QQFileSearch:=% Width-270
XArray.InsertAt(1,QQFileSearch)
menuIndex2:= % YArray.Length() 
menuIndex:= % Round((Height-100)/yspacing) -3 
menuIndex3:= % menuIndex+menuIndex2
gosub Ever_生成菜单
gosub Ever_开启热键
return
;-------------------------------规则菜单块--------------------------------


;升级想法：应该要实现设置某个数值，然后这里执行相应的操作。而不仅仅是单击左键。
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
        }else if(A_ThisHotkey = "S"){
            SetTimer, Ever_移除菜单,1
            gosub Ever_关闭热键
            Hotkey,S ,,off  
            Sleep,100
            return
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
            msgBox %xtip% %ytip%
            Gui,%index%:-Caption +AlwaysOnTop +ToolWindow  ;去标题栏任务栏alttab菜单项与置顶
            Gui,%index%: Color, 525252  ;设置菜单块背景颜色
            Gui,%index%: Font, s12 w550 cFFFFFF,A Verdana  ;设置下面的文本大小，字体
            Gui,%index%: Margin, x3, y3 ;设置字体控件距离左右上下距离
            Gui,%index%: Add, Text, w18 h18 Center , % IndexArray[index]  ;设置文本，文本颜色
            ;~ Gui,%index%:+Parent%active_id%
            Gui,%index%: Show, X%xtip% Y%ytip%
        }
    return

Ever_开启热键:  
    Hotkey,Esc ,Ever_执行热键,on
    Hotkey,LCtrl ,Ever_执行热键,on
    Loop
    {
        if A_Index > %menuIndex%
        {
            break  ; 终止循环
        }
        if A_Index < 1
        {
            msgBox cccc
            continue ; 跳过后面并开始下一次重复
        }
        Hotkey,% IndexArray[A_Index] ,Ever_执行热键,on  ;设置热键只对这个标签生效
        ;~ Hotkey,% IndexArray[A_Index] ,Ever_执行热键2,on
    }
    return

Ever_关闭热键:
    Hotkey,Esc ,,off
    Hotkey,LCtrl ,,off
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
