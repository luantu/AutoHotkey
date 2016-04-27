;需要注册为默认英文输入法的分组
GroupAdd,en,ahk_exe Xshell.exe

;需要注册为默认中文输入法的分组
GroupAdd,cn,ahk_exe Notepad++.exe
GroupAdd,cn,ahk_exe RTX.exe
GroupAdd,cn,ahk_exe Wechat.exe

setChineseLayout(){
	;发送中文输入法切换快捷键，请根据实际情况设置。
	send {Ctrl Down}{Shift Down}{2}
	send {Ctrl Up}{Shift Up}
}
setEnglishLayout(){
	;发送英文输入法切换快捷键，请根据实际情况设置。
	send {Ctrl Down}{Shift Down}{3}
	send {Ctrl Up}{Shift Up}
}

sendbyclip(var_string)
{
	ClipboardOld = %ClipboardAll%
	Clipboard =%var_string%
	sleep 100
	send ^v
	sleep 100
	Clipboard = %ClipboardOld%	; Restore previous contents of clipboard.
}

;监控消息回调ShellMessage，并自动设置输入法
Gui +LastFound
hWnd := WinExist()
DllCall( "RegisterShellHookWindow", UInt,hWnd )
MsgNum := DllCall( "RegisterWindowMessage", Str,"SHELLHOOK" )
OnMessage( MsgNum, "ShellMessage")

ShellMessage( wParam,lParam ) {
	WinGetclass, WinClass, ahk_id %lParam%
	;Sleep, 500
	;MsgBox,%Winclass%
	WinActivate,ahk_class %Winclass%
	;WinGetActiveTitle, Title
	;MsgBox, The active window is "%Title%".
	IfWinActive,ahk_group en
	{
		setEnglishLayout()
		;TrayTip,AHK, 已自动切换到英文输入法
		return
	}
	
	IfWinActive,ahk_group cn
	{
		setChineseLayout()
		;TrayTip,AHK, 已自动切换到英文输入法
		return
	}
}

#h::FileRecycleEmpty

#x::
send,#xa
return

; 开启tc，如果已经开启，激活窗口
#t::
IfWinNotExist  ahk_class TTOTAL_CMD, 
	Run "D:\Program Files\TotalCMD64\Totalcmd64.exe", , Max
Else 
IfWinNotActive ahk_class TTOTAL_CMD, 
	WinActivate 
Else 
	WinMinimize 
Return 

; 开启为知笔记，如果已经开启，激活窗口
#w::
IfWinNotExist  ahk_class WizNoteMainFrame
	Run "D:\Program Files (x86)\WizNote\Wiz.exe", , Max
Else 
IfWinNotActive ahk_class WizNoteMainFrame
	WinActivate 
Else 
	WinMinimize 
Return 

; 开启浏览器，如果已经开启，激活窗口
#b::
IfWinNotExist  ahk_class Chrome_WidgetWin_1
	Run "D:\Chrome\MyChrome.exe", , Max
Else 
IfWinNotActive ahk_class Chrome_WidgetWin_1
	WinActivate 
Else 
	WinMinimize 
Return 

; 开启source insight，如果已经开启，激活窗口
#s::
IfWinNotExist ahk_class si_Frame 
	Run "D:\Program Files (x86)\Source Insight 3\Insight3.Exe"
Else 
IfWinNotActive ahk_class si_Frame 
	WinActivate 
Else 
	WinMinimize 
Return 

; 开启outlook，如果已经开启，激活窗口
#o::
IfWinNotExist ahk_exe OUTLOOK.EXE
	Run "D:\Program Files\Microsoft Office\root\Office16\OUTLOOK.EXE", , Max
Else 
IfWinNotActive ahk_exe OUTLOOK.EXE
	WinActivate 
Else 
	WinMinimize 
Return

#n::Run Notepad++
return 

:://g:: 
Run http://www.google.com 
return 

:://b:: 
Run http://www.baidu.com 
return 


; SVN提交
#c::
if WinActive("Total Commander")
{
	try {
		Send {F12}
		Run "D:\Program Files\TortoiseSVN\bin\TortoiseProc.exe" /command:commit /path:"%clipboard%" /closeonend:3
	} catch {
		return
	}
	
	WinWait ,,Commit, 
	WinActivate 
}
Else
IfWinActive ahk_class CabinetWClass
{
   WinGetActiveTitle, pth
   cmd = D:\Program Files\TortoiseSVN\bin\TortoiseProc.exe /command:commit /path:"%pth%" /logmsg:"Autoversioning commit" /notempfile /closeonend:3
   run, %cmd%, %pth%
}
Return

;ahk_class #32770
;ahk_exe TortoiseProc.exe
; SVN更新
#u::
if WinActive("Total Commander")
{
	try {
		Send {F12}
		Run "D:\Program Files\TortoiseSVN\bin\TortoiseProc.exe" /command:update /path:"%clipboard%" /closeonend:3
	} catch {
		return
	}
	;WinWaitActive	,,Update, 5
	;WinActivate 
}
Else
IfWinActive ahk_class CabinetWClass
{
   WinGetActiveTitle, pth
   cmd = D:\Program Files\TortoiseSVN\bin\TortoiseProc.exe /command:update /path:"%pth%" /closeonend:3
   run, %cmd%, %pth%
}
Return

Shift::
return

+Space::
return

#m::
IfWinNotExist  ahk_class WinMergeWindowClassW
	Run "D:\Program Files (x86)\WinMerge\WinMergeU.exe"
Else 
IfWinNotActive ahk_class WinMergeWindowClassW
	WinActivate 
Else 
	WinMinimize 
Return 
