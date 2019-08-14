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
#IfWinActive ahk_exe TIM.exe	
~LAlt Up::   ;热键设置
;设置规则菜单块
IndexArray :=["S","A","D","F","Q","W","E","R","Z","X","C","V","1","2","3","4","T","G","B","J","K","L","H","U","N","M",",",".","5","6","7","8","9","0"]   ;设置菜单热键及显示文本
WinGet, active_id, ID, ahk_exe TIM.exe  ;获取当前窗口id
WinGetPos,X, Y, Width, Height, ahk_id %active_id%
;~ MsgBox, %active_id%
xtip0:=251  ;设置起始x坐标  
ytip0:=105-80  ;设置起始y坐标
xspacing:=0  ;设置x间距
yspacing:=80  ;设置y间距
menuIndex:= 8  ;设置规则菜单块数量，可直接设定
;% Round(Height/yspacing)  也可根据当前高度设置
;设置不规则菜单块
XArray:=["145","712","555"]   ;设置x坐标
YArray:=["45","38","38","105","105"]  ;设置y坐标
QQFile:=% Width-145
QQChat:=% Width-250
XArray.InsertAt(4,QQFile)  ;往xarray插入数据
XArray.InsertAt(5,QQChat)
menuIndex2:= % XArray.Length()   ;设置不规则菜单块数量，根据坐标数量设定，没有可设置为0
menuIndex3:= % menuIndex+menuIndex2  ;设置所有菜单块数量
gosub Ever_生成菜单
gosub Ever_开启热键
return
;在微信下
#IfWinActive ahk_class WeChatMainWndForPC
~LAlt Up::
IndexArray :=["S","A","D","F","Q","W","E","R","Z","X","C","V","1","2","3","4","T","G","B","J","K","L","H","U","N","M",",",".","5","6","7","8","9","0"] 
WinGet, active_id, ID, ahk_class WeChatMainWndForPC
WinGetPos, X, Y, Width, Height, ahk_id %active_id%
xtip0:=280  ;设置起始x坐标  
ytip0:=105-80  ;设置起始y坐标
xspacing:=0  ;设置x间距
yspacing:=80  ;设置y间距
menuIndex:= % Round(Height/yspacing)
;设置不规则菜单块
Emotion:= % Height-120
XArray:=["145"]
YArray:=["45"] 
menuIndex2:= % XArray.Length()
menuIndex3:= % menuIndex+menuIndex2
;~ MsgBox % "1有:" menuIndex "个,2有" menuIndex2 "个,3有" menuIndex3 
gosub Ever_生成菜单
gosub Ever_开启热键
return
#IfWinActive



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
if (A_ThisHotkey= value){
	if (index<menuIndex){
	xtip:=% xtip0+xspacing* index ;而点击的是窗口坐标所以
	ytip:=% ytip0+yspacing* index
	;~ MsgBox % "点击了第" index " 个, 对应的值是:" value ",坐标xy为:"xtip   ytip ",id是:"active_id
	;~ SetTimer, Ever_移除菜单,1
	;~ Sleep,100
	ControlClick, x%xtip% y%ytip%, ahk_id %active_id%,,,1, Pos	
	}else if(index<menuIndex3){  ;如果是不规则菜单
	aIndex:= % index-menuIndex+1  ;把值置为从1开始
	xtip:=% XArray[aIndex]
	ytip:=% YArray[aIndex]
	;~ MsgBox % aIndex "点击了第" index " 个, 对应的值是:" value ",坐标xy为:"xtip   ytip ",id是:"active_id
	WinActivate, ahk_id %active_id% ;可能会失去窗口焦点，要拉回来
	ControlClick, x%xtip% y%ytip%, ahk_id %active_id%,,,1, Pos	  ;这里应该还要根据情况设置左点击还是mouse鼠标还是其他
	if (A_ThisHotkey= "C") and WinActive("ahk_exe TIM.exe") {  ;因为这个坐标是在这个index范围所以要写在这里。所以不常用群聊里面c也就正常执行了。
	SetTimer, Ever_移除菜单,1
	gosub Ever_关闭热键
	Hotkey,C ,,off  
	Sleep,200
	gosub Ever_TIM文件下载   
	return
	}
	
	}
	
	}else if (A_ThisHotkey= "S") and WinActive("ahk_exe TIM.exe") {
	SetTimer, Ever_移除菜单,1
	gosub Ever_关闭热键
	Hotkey,S ,,off  
	Sleep,100
	gosub Ever_TIM不常用群聊  ;应该要做到如果点击的是第一个就直接运行不常用群聊的，完后就停止。
	return
	}
	
	SetTimer, Ever_移除菜单,1
	gosub Ever_关闭热键
	return

;优化想法：这些窗口第一次运行的时候循环一次保存起来，移除只是隐藏不真销毁。然后第二次以后要显示的时候直接显示即可。而且显示菜单块的时候要一起显示不要有那种一个接一个的感觉。
Ever_生成菜单:
;~ MsgBox % IndexArray.Length()
For index, value in IndexArray
	if (index<menuIndex){
	xtip:=% X+xtip0+xspacing* index  ;因为gui是显示屏幕坐标所以用当前窗口坐标+当前窗口内的指定坐标
	ytip:=% Y+ytip0+yspacing* index 
Gui,%index%:-Caption +AlwaysOnTop +ToolWindow  ;去标题栏任务栏alttab菜单项与置顶
Gui,%index%: Color, 525252  ;设置菜单块背景颜色
Gui,%index%: Font, s12 w550 cFFFFFF,A Verdana  ;设置下面的文本大小，字体
Gui,%index%: Margin, x3, y3 ;设置字体控件距离左右上下距离
Gui,%index%: Add, Text, w18 h18 Center , % IndexArray[index]  ;设置文本，文本颜色
;~ Gui,%index%:+Parent%active_id%
Gui,%index%: Show, x%xtip% y%ytip%
	}else if( index<menuIndex3){  ;如果是不规则菜单
	aIndex:= % index-menuIndex+1
	xtip:=% X+XArray[aIndex]
	ytip:=% Y+YArray[aIndex]
	 ;~ MsgBox % aIndex "生成了第" index " 个, 对应的值是:" value ",坐标xy为:"xtip   ytip ",id是:"active_id 
	
Gui,%index%:-Caption +AlwaysOnTop +ToolWindow  
Gui,%index%: Color, 525252  ;设置菜单块背景颜色
Gui,%index%: Font, s12 w550 cFFFFFF,A Verdana  ;设置下面的文本大小，字体
Gui,%index%: Margin, x3, y3 ;设置字体控件距离左右上下距离
Gui,%index%: Add, Text, w18 h18 Center , % IndexArray[index]  ;设置文本，文本颜色
;~ Gui,%index%:+Parent%active_id%
Gui,%index%: Show, x%xtip% y%ytip%
}
WinActivate, ahk_id %active_id%  ;生成完菜单后激活一次窗口，让焦点回到窗口来而不是菜单块
return




Ever_开启热键:  
Hotkey,Esc ,Ever_执行热键,on
Hotkey,LCtrl ,Ever_执行热键,on
Loop
{
    if A_Index > %menuIndex3%
        break  ; 终止循环
    if A_Index < 1
	continue ; 跳过后面并开始下一次重复
	Hotkey,% IndexArray[A_Index] ,Ever_执行热键,on  ;设置热键只对这个标签生效
	;~ Hotkey,% IndexArray[A_Index] ,Ever_执行热键2,on
}
return

Ever_关闭热键:
Hotkey,Esc ,,off
Hotkey,LCtrl ,,off
Loop
{
    if A_Index > %menuIndex3%
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
    if A_Index > %menuIndex3%
        break  ; 终止循环
    if A_Index < 1
	continue ; 跳过后面并开始下一次重复
	;~ Gui, %A_Index%:-Parent
	Gui, %A_Index%:Destroy
}
return




