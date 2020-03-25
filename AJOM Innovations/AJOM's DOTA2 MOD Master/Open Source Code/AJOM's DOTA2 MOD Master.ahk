; force run as admin
if not (A_IsAdmin or RegExMatch(DllCall("GetCommandLine", "str"), " /restart(?!\S)"))
{
    ; if a file is opened/dragged using this dota2 mod master, this code will able to detect them all and restart dota2 mod master while still dragging this files to dota2 mod master
	
	VarSetCapacity(draggedfiles,0)
	for n, GivenPath in A_Args  ; For each parameter (or file dropped onto a script):
	{
		Loop Files, %GivenPath%, F  ; Include files and directories.
		{
			; LongPath := A_LoopFileLongPath
			; InStr(A_LoopFileLongPath,".",,0)+1 searches for the offset position of the extension(dot ".") and after finding it, moves one step to the right excluding the dot(.) on the right side
			; StrLen(A_LoopFileLongPath) is the number of characters in the whole path
			; StrLen(A_LoopFileLongPath)-InStr(A_LoopFileLongPath,".",,0) counts the number of characters of the extension, excluding "."
			; SubStr(A_LoopFileLongPath,InStr(A_LoopFileLongPath,".",,0)+1,StrLen(A_LoopFileLongPath)-InStr(A_LoopFileLongPath,".",,0)) ; extracts the whole extension excluding the dot(.)
			if (A_LoopFileExt = "aldrin_dota2hidb") or (A_LoopFileExt = "aldrin_dota2db")
			{
				draggedfiles="%A_LoopFileLongPath%" %draggedfiles%
			}
		}
	}
	;
    try
    {
        if A_IsCompiled
            Run *RunAs "%A_ScriptFullPath%" /restart %draggedfiles% ; restart dota2 mod master with admin priviledges, also redragg all dragged files to admined dota2 mod master
        else
            Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%" %draggedfiles%  ; restart dota2 mod master with admin priviledges, also redragg all dragged files to admined dota2 mod master
    }
    ExitApp
}
;

;;optimize speed of script
#NoEnv
;#MaxHotkeysPerInterval 99000000
;#HotkeyInterval 99000000
#KeyHistory 0
#Persistent
#SingleInstance ignore
;#MaxThreads 1
#MaxThreadsPerHotkey 1
SetBatchLines -1
SetControlDelay,-1
;SetWinDelay, -1
;SetWinDelay,0
ListLines Off
Process, Priority, , A
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SendMode Input
AutoTrim,Off
#MaxThreadsBuffer On
CoordMode,ToolTip,Screen
;if A_Is64bitOS
;	SetRegView 64
;SetFormat,IntegerFast,%A_FormatInteger%
;SetFormat,FloatFast,%A_FormatFloat%
;;

version=2.5.4

if disableautoupdate<>1
	versionchecker(version)

ToolTip,DOTA2 MOD Master:`nVerifying DotNet Functionality,0,0
shellcmdrunning:=!FileExist(substr(A_ProgramFiles,1,InStr(A_ProgramFiles,"\",0)) "Program Files\dotnet\dotnet.exe") and !FileExist(A_ProgramFiles "\dotnet\dotnet.exe") ; initial detection that we are going to run a shell cmd
if shellcmdrunning
{
	DetectHiddenWindows, On
	Run,%A_ComSpec%,,Hide UseErrorLevel,cPID
	WinWait,ahk_pid %cPID% ahk_exe cmd.exe ahk_class ConsoleWindowClass
	;WinHide,ahk_pid %cPID% ahk_exe cmd.exe ahk_class ConsoleWindowClass
	DllCall("kernel32\AttachConsole", "UInt",cPID)
	cshell:=comobjcreate("wscript.shell")
}
dotnetdetection:
global globaldotnetdir
dotnetfullpath=%A_ProgramFiles%\dotnet\dotnet.exe
if !FileExist(dotnetfullpath) ; stage 1 - if programfiles dotnet is missing
{
	dotnetfullpath:=substr(A_ProgramFiles,1,InStr(A_ProgramFiles,"\",0)) "Program Files\dotnet\dotnet.exe"
	if !FileExist(dotnetfullpath) ; stage 2 - if programfile substring dotnet is missing
	{
		RegExMatch(cshell.exec("where dotnet").stdout.readall(),"m)^.*",dotnetfullpath)
		if !FileExist(dotnetfullpath) ; stage 3 - if "where dotnet" cmd command cannot really detect dotnet
		{
			msgbox,16,DotNet Core Required!,Material File Extraction and Detection feature of this tool requires Dotnet Core installed on your computer. Please install the corresponding installers after pressing "OK" to maximize the full potential of DOTA2 MOD Master.
			IfNotExist,%A_ScriptDir%\Plugins\Installers\
			{
				FileCreateDir,%A_ScriptDir%\Plugins\Installers
			}
			IfNotExist,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\
			{
				FileCreateDir,%A_Temp%\AJOM Innovations\DOTA2 MOD Master
			}
			DLarray:=[]
			if A_Is64bitOS
			{
				if !FileExist(A_ScriptDir "\Plugins\Installers\DotnetCoreRuntimex64.exe")
				{
					DownloadFileURL([["https://download.visualstudio.microsoft.com/download/pr/a803822b-178b-4d21-bb7c-aaa1d209c341/e77c5ca1d0ea9963346655e2ec2733f2/dotnet-runtime-2.2.7-win-x64.exe",A_Temp "\AJOM Innovations\DOTA2 MOD Master\DotnetCoreRuntimex64.exe","DotNet Core Runtime"]],3)
					ifexist,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\DotnetCoreRuntimex64.exe
						FileMove,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\DotnetCoreRuntimex64.exe,%A_ScriptDir%\Plugins\Installers\DotnetCoreRuntimex64.exe,1
				}
				runwait,%A_ScriptDir%\Plugins\Installers\DotnetCoreRuntimex64.exe,,UseErrorLevel
				if (ErrorLevel="ERROR") or FileExist(substr(A_ProgramFiles,1,InStr(A_ProgramFiles,"\",0)) "Program Files\dotnet\dotnet.exe") or FileExist(A_ProgramFiles "\dotnet\dotnet.exe")
					goto,dotnetdetection
			}
			else
			{
				if !FileExist(A_ScriptDir "\Plugins\Installers\DotnetCoreRuntimex86.exe")
				{
					DownloadFileURL([["https://download.visualstudio.microsoft.com/download/pr/2b9e6f98-53ba-412d-8a4e-cb4092d8a293/602c597f378f5c5d527e91e1fa1ebb55/dotnet-runtime-2.2.7-win-x86.exe",A_Temp "\AJOM Innovations\DOTA2 MOD Master\DotnetCoreRuntimex86.exe","DotNet Core Runtime"]],3)
					ifexist,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\DotnetCoreRuntimex86.exe
						FileMove,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\DotnetCoreRuntimex86.exe,%A_ScriptDir%\Plugins\Installers\DotnetCoreRuntimex86.exe,1
				}
				runwait,%A_ScriptDir%\Plugins\Installers\DotnetCoreRuntimex86.exe,,UseErrorLevel
				if (ErrorLevel="ERROR") or FileExist(substr(A_ProgramFiles,1,InStr(A_ProgramFiles,"\",0)) "Program Files\dotnet\dotnet.exe") or FileExist(A_ProgramFiles "\dotnet\dotnet.exe")
					goto,dotnetdetection
			}
			VarSetCapacity(DLarray,0)
			MsgBox,Installation Complete,Please Re-Run DOTA2 MOD Master.,3
			exitapp
		}
	}
}
if !FileExist(dotnetfullpath) ; if dotnet really cannot be found
	dotnetfullpath=dotnet
if shellcmdrunning ; if a shell cmd is running
{
	VarSetCapacity(cshell,0)
	DllCall("kernel32\FreeConsole")
	Process, Close, % cPID
	DetectHiddenWindows, Off
}

Menu, Tray, Add, &Exit, k_MenuExit
Menu, Tray, NoStandard

global databasemessage="~ ~ ~ ~ MAIN DATABASE Version 2 : Don't Edit anything here to avoid DATABASE CORRUPTION!!! ~ ~ ~ ~`n`n"
global defaultshoutout="(Always Relaunch this Tool and Reinject all item sets everytime DOTA2 has an Update with Newly Arrived Items!)"

if A_Is64bitOS=1
{
	variablehllib=%A_ScriptDir%\Plugins\hllib246\bin\x64\HLExtract.exe
}
else
{
	variablehllib=%A_ScriptDir%\Plugins\hllib246\bin\x86\HLExtract.exe
}

RegRead,SteamPath,HKEY_CURRENT_USER,Software\Valve\Steam,SteamPath
StringReplace,SteamPath,SteamPath,/,\,1
IfExist,%A_ScriptDir%\Settings.aldrin_dota2mod
{
	IniRead,mapdota2dir,%A_ScriptDir%\Settings.aldrin_dota2mod,Edits,mapdota2dir
	ifnotexist,%mapdota2dir%\game\dota\
	{
		VarSetCapacity(mapdota2dir,0)
		gosub,d2dirdetection
	}
	else
	{
		dota2dir=%mapdota2dir%
	}
}
else ifnotexist,%SteamPath%\steamapps\common\dota 2 beta\game\dota\pak01_dir.vpk
{
	gosub,d2dirdetection
}
else
{
	mapdota2dir=%SteamPath%\steamapps\common\dota 2 beta
	dota2dir=%SteamPath%\steamapps\common\dota 2 beta
}
dota2dir:=StrReplace(dota2dir,"/","\")
mapdota2dir:=dota2dir
GoSub,default_settings
param=%A_ScriptDir%\Library\,%A_ScriptDir%\Generated MOD\,%A_ScriptDir%\External Files\
loop,parse,param,`,
{
	IfNotExist,%A_LoopField%
	{
		FileCreateDir,%A_LoopField%
	}
}
FileCopyDir,%A_ScriptDir%\Plugins\Sound,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\Sound,1

;generate library files
generatelibraryfiles:
ToolTip,DOTA2 MOD Master:`nExtracting Library Files,0,0
param=root\scripts\items\items_game.txt,root\scripts\npc\activelist.txt,root\scripts\npc\portraits.txt
pidlist:=[]
global GlobalArray:=[]
loop,parse,param,`,
{
	loop
	{
		run,"%variablehllib%" -p "%dota2dir%\game\dota\pak01_dir.vpk" -d "%A_ScriptDir%\Library" -e "%A_LoopField%",,Hide UseErrorLevel,tmpr
		if ErrorLevel!=ERROR
			break
	}
	pidlist[A_Index]:=tmpr
}
DetectHiddenWindows,On
SetTitleMatchMode,3
SetTitleMatchMode,Slow
WinWait,% "ahk_pid " pidlist[pidlist.Count()] " ahk_exe HLExtract.exe ahk_class ConsoleWindowClass" ;,,3 ;wait for max of 3 seconds
for index,cPID in pidlist
{
	;if WinExist("ahk_pid " cPID " ahk_exe HLExtract.exe ahk_class ConsoleWindowClass")
	;	WinWaitClose,ahk_pid %cPID% ahk_exe HLExtract.exe ahk_class ConsoleWindowClass ;,,60 ;wait for max of 1 minute
	Process,Exist,%cPID%
	if ErrorLevel
		Process,WaitClose,%cPID%
}
DetectHiddenWindows,Off
SetTitleMatchMode,Fast
VarSetCapacity(pidlist,0)
loop,parse,param,`,
{
	tmpr:=SubStr(A_LoopField,InStr(A_LoopField,"\",,0)+1)
	timeout:=A_TickCount
	loop
	{
		if FileExist(A_ScriptDir "\Library\" tmpr)
		{
			ToolTip,DOTA2 MOD Master:`nReading %A_LoopField%,0,0
			FileRead,tempo,%A_ScriptDir%\Library\%tmpr%
			GlobalArray[tmpr]:=tempo
			if (GlobalArray[tmpr]="")
				continue
			else break
		}
		else if (A_TickCount-timeout=10000) ; wait for max of 10 seconds
			goto,generatelibraryfiles
		else sleep 500
	}
}
fileread,tempo,%dota2dir%\game\dota\scripts\npc\npc_heroes.txt
GlobalArray["npc_heroes.txt"]:=tempo
fileread,tempo,%dota2dir%\game\dota\scripts\npc\npc_units.txt
GlobalArray["npc_units.txt"]:=tempo
;

If !FileExist(A_ScriptDir "\Library\items_game.txt")
{
	msgbox,16,ERROR!!! "items_game.txt" is MISSING!,It looks like:`n`n"%A_ScriptDir%\Library\items_game.txt"`n`nIs missing. But since this tool already supports auto-extraction of "items_game.txt"`, please restart this application. Before using the "inject" feature of this tool`, make sure to add the original "items_game.txt" inside "%A_ScriptDir%\Library" Folder OR ELSE THE ID INJECTION WILL NOT WORK!`n`nIf you dont have an Idea where to find the "items_game.txt"`,here is a few steps:`n1)Download "GCFScape" application. Alternatively if GCFScape produces "ERROR" when opening "Pak01_dir.vpk"`, Download "Valve's Resource Viewer" application instead.`n2)Use "GCFScape" or "Valve's Resource Viewer" to open "Pak01_dir.vpk"(commonly it is located at "Steam\steamapps\common\dota 2 beta\game\dota\").`n3)Hit "CTRL+F"(or press "find" elsewhere) and search for "items_game.txt" without punctuation marks.`n4)If successfully found`,Right-Click the file(items_game.txt) and extract it to "%A_ScriptDir%\Library" folder.
}
else if (GlobalArray["items_game.txt"]="")
{
	FileRead,tempo,%A_ScriptDir%\Library\items_game.txt
	GlobalArray["items_game.txt"]:=tempo
}

If !FileExist(A_ScriptDir "\Library\activelist.txt")
{
	msgbox,16,ERROR!!! "activelist.txt" is MISSING!,It looks like:`n`n"%A_ScriptDir%\Library\activelist.txt"`n`nIs missing. But since this tool already supports auto-extraction of "activelist.txt"`, please restart this application. Before using the "inject" feature of this tool`, make sure to add the original "activelist.txt" inside "%A_ScriptDir%\Library" Folder OR ELSE THE HERO Recognition for Handy Injection Section WILL NOT WORK!`n`nIf you dont have an Idea where to find the "activelist.txt"`,here is a few steps:`n1)Download "GCFScape" application. Alternatively if GCFScape produces "ERROR" when opening "Pak01_dir.vpk"`, Download "Valve's Resource Viewer" application instead.`n2)Use "GCFScape" or "Valve's Resource Viewer" to open "Pak01_dir.vpk"(commonly it is located at "Steam\steamapps\common\dota 2 beta\game\dota\").`n3)Hit "CTRL+F"(or press "find" elsewhere) and search for "activelist.txt" without punctuation marks.`n4)If successfully found`,Right-Click the file(activelist.txt) and extract it to "%A_ScriptDir%\Library" folder.
}
else if (GlobalArray["activelist.txt"]="")
{
	FileRead,tempo,%A_ScriptDir%\Library\activelist.txt
	GlobalArray["activelist.txt"]:=tempo
}

param=ucr,mapinvdirview,mapdatadirview,maphdatadirview,mapmdirview,autovpk,pet,usemisc,mapgiloc,mappetstyle,maplowprocessor,usedversion,mapdota2dir,soundon,useextportraitfile,useextfile,useextitemgamefile,fastmisc,showtooltips,singlesourcechoice,multiplestyleschoice,disableautoupdate,cmdmaxinstances
Loop,parse,param,`,
{
	IniRead,%A_LoopField%,%A_ScriptDir%\Settings.aldrin_dota2mod,Edits,%A_LoopField%
}

if version>%usedversion%
{
	FileSetAttrib,-R,%A_ScriptDir%\Library\Reference.aldrin_dota2mod
	FileDelete,%A_ScriptDir%\Library\Reference.aldrin_dota2mod
}
; if a file is opened/dragged using this dota2 mod master, this code will able to detect them all
VarSetCapacity(draggedfilesg,0),VarSetCapacity(draggedfilesh,0)
for tmp1, GivenPath in A_Args  ; For each parameter (or file dropped onto a script):
{
	Loop Files, %GivenPath%, F  ; Include files only not folders for faster tabulation.
	{
		if A_LoopFileExt = aldrin_dota2hidb
		{
			draggedfilesh=%A_LoopFileLongPath%|%draggedfilesh%
		}
		else if A_LoopFileExt = aldrin_dota2db
		{
			draggedfilesg=%A_LoopFileLongPath%|%draggedfilesg%
		}
	}
}
tmp1 := StrReplace(draggedfilesg,"|","|",tmp2),tmp1 := StrReplace(draggedfilesh,"|","|",tmp3),tmp2+=tmp3
if (draggedfilesg<>"") or (draggedfilesh<>"")
{
	if tmp2>=2 ;; if two or more files are dragged into the script, it will ask the user to selectonly one file for each section: general and handy injection
	{
		Gui, draggedfilesgui:+Resize +MinSize
		Gui, draggedfilesgui:Add, Text,w400 vtext47,You have selected Multiple Files for DOTA2 MOD Master to Handle`, but unfortunately DOTA2 MOD Master can only Browse one Database File. Select the most preffered Database File.
		Gui, draggedfilesgui:Add, Text,,General Database
		Gui, draggedfilesgui:Add, Text, x205 y60 vtext49,Handy-Injection Database
		Gui, draggedfilesgui:Add,ComboBox,x1 w200 vselectedfileg Choose1 Simple,%draggedfilesg%
		Gui, draggedfilesgui:Add,ComboBox,x205 y79 w200 vselectedfileh Choose1 Simple,%draggedfilesh%
		Gui, draggedfilesgui:Add, Button, default xm galldraggedfiles vtext48, Select
		Gui, draggedfilesgui:Show,,Choose One File to Open
		return
	}
	else if tmp2=1
	{
		draggedfilesh:=StrReplace(draggedfilesh,"|",""),draggedfilesg:=StrReplace(draggedfilesg,"|","")
		Loop Files,%draggedfilesh%, F
		{
			if A_LoopFileExt=aldrin_dota2hidb
			{
				maphdatadirview:=A_LoopFileLongPath
			}
		}
		Loop Files,%draggedfilesg%, F
		{
			if A_LoopFileExt=aldrin_dota2db
			{
				mapdatadirview:=A_LoopFileLongPath
			}
		}
	}
}
draggedfilesguiguiclose:
continueexecution:
Gui,draggedfilesgui:Destroy
GivenPath= ; forget the dragged file location to avoid rerunning the window gui for dragged files
;;;;

; generate hero list
ToolTip,DOTA2 MOD Master:`nDetecting all Heroes,0,0
VarSetCapacity(mapherochoice,0)
Loop
{
	ipos:=instr(GlobalArray["activelist.txt"],"npc_dota_hero_",,,A_Index)
	if ipos<=0
	{
		Break
	}
	ipos1:=instr(GlobalArray["activelist.txt"],"""",,ipos+1)
	tmp2:=SubStr(GlobalArray["activelist.txt"],ipos,ipos1-ipos)
	if tmp2<>
	{
		mapherochoice.="|" tmp2
	}
}
mapherochoice:=StrReplace(mapherochoice,"npc_dota_hero_")
ifexist,%A_ScriptDir%\CustomHeroes.aldrin_dota2mod
{
	customherocount=0
	FileRead,tmp,%A_ScriptDir%\CustomHeroes.aldrin_dota2mod
	Loop
	{
		tmp1=CustomHero%A_Index%
		if InStr(tmp,tmp1)
		{
			IniRead,tmp2,%A_ScriptDir%\CustomHeroes.aldrin_dota2mod,CustomHeroes,CustomHero%A_Index%
			StringTrimLeft, tmp2, tmp2, 14
			mapherochoice=%mapherochoice%|%tmp2%
			customherocount+=1
		}
		else
		{
			Break
		}
	}
}
Sort mapherochoice, A D|
GlobalArray["herolist"]:=mapherochoice
mapherochoice=None%mapherochoice%
;

ToolTip,DOTA2 MOD Master:`nBuilding GUI Window,0,0
IniRead,RegisteredDirectory,%mapdatadirview%,Edits,RegisteredDirectory
IniRead,hRegisteredDirectory,%maphdatadirview%,Edits,hRegisteredDirectory
checkparam=mapinvdirview,mapdatadirview,maphdatadirview,mapmdirview,mapgiloc,mapdota2dir
loop,parse,checkparam,`,
{
	if %A_LoopField%=ERROR
	{
		VarSetCapacity(%A_LoopField%,0)
	}
}
DllCall("QueryPerformanceFrequency", "Int64P", freq)
Gui, MainGUI:+Resize +MinSize
IniRead,choosetab,%A_ScriptDir%\Settings.aldrin_dota2mod,Edits,choosetab,3
tablist=General|Search|Handy Injection|Migration|Miscellaneous|Advanced
Gui, MainGUI:Add, Tab2,x0 y0 h500 w550 -Wrap vOuterTab gSelectOuterTab choose%choosetab%, %tablist%
Gui, MainGUI:Tab,2
Gui, MainGUI:Add, Button,gbuttonsearch vtext9 x1 y30 h20 Default,Search for(keyword):
Gui, MainGUI:Add, Text, x66 y70 vtext10,ID:
Gui, MainGUI:Add, Text, x48 y90 vtext11,Name:
Gui, MainGUI:Add, Text, x45 y110 vtext12,Prefab:
Gui, MainGUI:Add, Text, x35 y130 vtext13,Item Slot:
Gui, MainGUI:Add, Text, x22 y150 vtext14,Model Path:
Gui, MainGUI:Add, Text, x1 y170 vtext15,Used by Heroes:
Gui, MainGUI:Add, Edit,vsearchbar x125 y30 w409 -WantReturn,
Gui, MainGUI:Add, Edit, vidbar x90 y70 w454 +ReadOnly,
Gui, MainGUI:Add, Edit, vnamebar x90 y90 w454 +ReadOnly,
Gui, MainGUI:Add, Edit, vprefabbar x90 y110 w454 +ReadOnly,
Gui, MainGUI:Add, Edit, vitemslotbar x90 y130 w454 +ReadOnly,
Gui, MainGUI:Add, Edit, vmodelpathbar x90 y150 w454 +ReadOnly,
Gui, MainGUI:Add, Edit, vheroesbar x90 y170 w454 +ReadOnly,
Gui, MainGUI:Add, Edit, vsearchshow x4 y190 w540 h260 +ReadOnly,
Gui, MainGUI:Tab,3
Gui, MainGUI:Tab,4
Gui, MainGUI:Add, text, vtext21,Select your "items_game.txt" you wish to be migrated on the latest "items_game.txt"
Gui, MainGUI:Add, DropDownList,choose1 x70 y50 w445 h21 gdirremover vmdirview,%mapmdirview%
WM_MOUSEMOVE("mdirview","To remove a list on this dropdownlist, simply left-click this dropdownlist and then left-click the list you want to remove.")
Gui, MainGUI:Font,Bold
Gui, MainGUI:Add, Button, x1 y50 w60 h21 gmdirbrowse vtext22, Browse
Gui, MainGUI:Add, Button, x205  y475 gmselectinject vtext23 hwndHBTN, Inject and Migrate
SetBtnTxtColor(HBTN, "Blue")
Gui, MainGUI:Font
Gui, MainGUI:Add, Text,x6 y80 w540 vtext24,"Migration System" is a Technique specially supported by this tool which allows the user to easily migrate all "default_item" assets of his/her old "items_game.txt" into the new "items_game.txt"(commonly targeted on newer patches of DOTA2). what this system do is:`n`n1)It copies every single item that has "prefab=default_item"`n2)Analyze every single item's "Unique ID" and remembers it`n3)Scans for "default_item" occurence on the "new items_game.txt" and compares both "old items_game.txt VS. new items_game.txt" using "ID assets comparement method"`n4)If the assets of both "old ID"(from old items_game.txt) assets does not pair the "new ID"(from new items_game.txt) assets`, that is where the migration will start. It will inject the "old ID assets" inside the "new ID assets"`,in other words "Copy the old assets then replace all new assets by paste ".
Gui, MainGUI:Tab,5
Gui, MainGUI:Tab,6
Gui, MainGUI:Add, CheckBox, checked%autovpk% x9 y70 gautovpkon vautovpkon,Auto-Shutnik Method(Requires "VPKCreator" present on same Directory)(SELF-ACTIVE)
tmpr=
(
If this Option is ~ 

CHECKED : Everytime you Inject items at "General" and "Handy Injection", DOTA2 MOD Master will automatically generate a pak01_dir.vpk at "%dota2dir%\game\Aldrin_Mods\" Folder when the whole process is finished.

*Prosequences
-The whole MODDING Operation will be standalone, meaning there is no need to do anything and DOTA2 will automatically be MODDED including all injected item sets since the user commands a straight forward operation on DOTA2 MOD Master.
-Advisable for Beginners who dont know anything about "Manual Modding"

Consequences
-Since the straightforward operation auto-creates a .vpk file, the user cannot manually edit the MOD anymore. But its OK if you dont know anything about manual modding.


UNCHECKED : Everytime you Inject items at "General" and "Handy Injection", DOTA2 MOD Master will NOT generate a pak01_dir.vpk but instead will generate a "pak01_dir" folder found at "%A_ScriptDir%\Generated MOD\" Folder when the whole process is finished.

*Prosequences
-The user can browse all generated files by the injector and is free to modify its files for "Manual Modding". This is commonly used by MODDERS if they want to reupdate all cosmetic items by letting the injector extract cosmetic items from the real "%dota2dir%\game\dota\pak01_dir.vpk" folder.

Consequences
-DOTA2 MOD Master will not be responsible about the files found inside the "Generated MOD" Folder.
-You have to Manually MOD DOTA2 by yourself.
)
WM_MOUSEMOVE("autovpkon",tmpr)

GUI, MainGUI:Add, Text,x80 y90,Maximum Threads
GUI, MainGUI:Add, edit,number Center -WantReturn x1 y90 w75 h15
GUI, MainGUI:Add, updown,0x80 vcmdmaxinstances x1 y90 w75 h15 range2-4294967297,%cmdmaxinstances%
tmpr=
(
*Specify how many threads can be actived at a time. High number of threads will make items such models and particles-effects extraction faster but will consume lots of memory and processing power.
*Input a value of "0" to specify "Unlimited" number of threads. This might cause "HANG" on PC with low processing power.
*A Value of "1" is synonymous to "Low-Processor Mode" since only one thread can open at a time. This is like checking low processor mode.
*This option is only applicable when "LOW-PROCESSOR MODE" is UNCHECKED.
)
WM_MOUSEMOVE("cmdmaxinstances",tmpr)

Gui, MainGUI:Add, CheckBox, checked%maplowprocessor% x170 y90 vlowprocessor,Low-Processor Mode(Check this If you Experience your Computer HANG during Injection in  exchange for slow injection)
tmpr=
(
If this Option is ~ 

UNCHECKED : Enables "Multi-Threading" capability. Everytime you inject multiple command consoles will be launched when extracting model files.

*Prosequences
-the Operation will be a lot faster because the extraction is done simultaneously by multiple command consoles.

*Consequences:
-This will consume a lot of memory, make sure that you have atleast 4gb RAM if you leave this option unchecked


CHECKED : Disables "Multi-Threading" capability. Everytime you inject only a single command console will be launched when extracting model files.

*Prosequences
-It will not consume RAM when extracting models since only one command console is done one at a time. Leaving this option checked is advisable for Low-End PC's

*Consequences
-The operation will consume a lot of TIME since the since every command console finishes its extraction process for an approximate 3-5 seconds. If you have included almost 300+ items on the operation, expect a 300 x 5 = 1500 seconds(25 minutes) plus additional time on the operation.
)
WM_MOUSEMOVE("lowprocessor",tmpr)

if (mapdota2dir="") or (!FileExist(mapdota2dir))
{
	ifexist,%SteamPath%\steamapps\common\dota 2 beta\game\dota\pak01_dir.vpk
	{
		mapdota2dir=%SteamPath%\steamapps\common\dota 2 beta
		FileSetAttrib,-R,%A_ScriptDir%\Settings.aldrin_dota2mod
		IniWrite,%mapdota2dir%,%A_ScriptDir%\Settings.aldrin_dota2mod,Edits,mapdota2dir
		FileSetAttrib,+R,%A_ScriptDir%\Settings.aldrin_dota2mod
	}
	else
	{
		msgbox,16,ERROR!!!,DOTA2 Directory cannot be detected`, Please Locate the Directory of your DOTA2 Game with this specific location exist inside that folder "game\dota\pak01_dir.vpk" found at "%SteamPath%/steamapps/common/"
		d2find=1
	}
}
Gui, MainGUI:Add, DropDownList,choose1 x65 y125 w430 h21 vdota2dir,%mapdota2dir%
Gui, MainGUI:Font,Bold
Gui, MainGUI:Add, Button, x1 y125 w60 h21 gd2locbrowse vd2locbrowse, Browse
WM_MOUSEMOVE("d2locbrowse","Browse where the DOTA2 Game Folder is located")
if d2find=1
{
	gosub,d2locbrowse
}
if (mapgiloc="") or (FileExist(mapgiloc)="")
{
	ifexist,%dota2dir%\game\dota\gameinfo.gi
	{
		mapgiloc=%dota2dir%\game\dota\gameinfo.gi
		FileSetAttrib,-R,%A_ScriptDir%\Settings.aldrin_dota2mod
		IniWrite,%mapgiloc%,%A_ScriptDir%\Settings.aldrin_dota2mod,Edits,mapgiloc
		FileSetAttrib,+R,%A_ScriptDir%\Settings.aldrin_dota2mod
	}
}
Gui, MainGUI:Add, Button, x1 y45 w60 h21 ggilocbrowse vgilocbrowse, Browse
WM_MOUSEMOVE("gilocbrowse","Browse the location of DOTA2's gameinfo.gi")
Gui, MainGUI:Add, Button,gpatchgi h15 x1 y30 hwndHBTN vpatchgi,Patch "gameinfo.gi" Location
SetBtnTxtColor(HBTN, "Blue")
tmpr=
(
Press this button to manually patch gameinfo.gi.

This button requires gameinfo.gi to be defined below this button. If not defined yet, press browse button and located gameinfo.gi(found at steam\steamapps\common\dota\gameinfo.gi)

What is the importance of gameinfo.gi?
The registration of the MOD's main location will be registered on this file. If this file is not defined or is missing, Auto-Shutnik Method will not work.
)
WM_MOUSEMOVE("patchgi",tmpr)

Gui, MainGUI:Add, Button, x165 y475 gselectreset vtext26 hwndHBTN,Remove MOD on DOTA2
SetBtnTxtColor(HBTN, "Red")
Gui, MainGUI:Font
Gui, MainGUI:Add, Text,x1 y110,"DOTA2" Location(found at "steam\steamapps\common\")
Gui, MainGUI:Add, DropDownList,choose1 x65 y45 w430 h21 gdirremover vgiloc,%mapgiloc%
WM_MOUSEMOVE("giloc","
(
To remove a list on this dropdownlist, simply left-click this dropdownlist and then left-click the list you want to remove.

Note: Game Info(GI) is important for Auto-Shutnik Method. So keep in mind emptying the list on this dropdownlist will lose functionality to auto-shutnik method.
)")

Gui, MainGUI:Add, Text,x180 y30,(commonly exist at "dota 2 beta\game\dota\")
Gui, MainGUI:Add, CheckBox, checked%soundon% x9 y150 vsoundon,Enable Voice-Actived Narrator
WM_MOUSEMOVE("soundon","Checking this Option will use Artificial Narration that announces current operation status.")
Gui, MainGUI:Font,Bold
Gui, MainGUI:Add, Button, x1 y166 h21 vtext52 grescanresources hwndHBTN,Rescan Resources
SetBtnTxtColor(HBTN, "Green")
Gui, MainGUI:Font
WM_MOUSEMOVE("text52","
(
Click this Button to Rescan all items_game.txt Related resources.

*WARNING!!! THIS WILL RESTART DOTA2 MOD MASTER, MAKE SURE TO SAVE YOUR WORK FIRST BEFORE CLICKING THIS BUTTON
*Updates the contents of the Miscellaneous Resources Reference File. This avoids inaccurate reloading of Miscellaneous Resources.
*Commonly applicable when there is a bug on Miscellaneous Resources like a specific item does not exist on the list.
)")
Gui, MainGUI:Add, CheckBox, checked%fastmisc% x125 y170 vfastmisc,Remember Miscellaneous Resources for fast Preload(Not advisable to be checked. if you want to accurately preload all Miscellaneous resources`, leave this option unchecked)
tmpr=
(
If this Option is ~ 

CHECKED : Everytime DOTA2 MOD Master preloads Miscellaneous resources, it automatically remembers all Miscellaneous resources upon the next start by creating a reference file. So that if the real items_game.txt is not changed by updates/patches, Fast Preloading will be done.

*Prosequences
-Ultra Fast Preloading every start of DOTA2 MOD Master.
-Does not need to Redefine all Miscellaneous Resources every start.

*Consequences
-Since I still have not proved if this option will produce innacurate results, the most expected consequence that I predicted is "Innacurate" Resources. It might have some "MISSING Miscellaneous Resources" that should be present or might produce an "Extra BLANK Row" that is irritating.


UNCHECKED : It always scan Miscellaneous Resources at items_game.txt file every start.

*Prosequences
-Preloading Miscellaneous resources is FULLY Accurate since it always scans items_game.txt every start. Making sure that every single Miscellaneous resource will be present on every lists.

*Consequences
-Slower Startup since DOTA2 MOD Master needs to Preload "Miscellaneous" Resources first before it is allowed to be used.
)
WM_MOUSEMOVE("fastmisc",tmpr)

Gui, MainGUI:Add, CheckBox, checked%showtooltips% x9 y190 vshowtooltips gshowtooltips,Show Tooltip Guides on every Controls.
Gui, MainGUI:Add, CheckBox, checked%disableautoupdate% x9 y210 vdisableautoupdate,Disable Automatic Updates.
Gui, MainGUI:Add, text,x4 y230,ERROR Log
Gui, MainGUI:Add, Edit, verrorshow x4 y245 w266 h206 +ReadOnly,
Gui, MainGUI:Add, text,x276 y230 vtext32,Report Log
Gui, MainGUI:Add, Edit, vreportshow x276 y245 w266 h206 +ReadOnly,
Gui, MainGUI:Tab
Gui, MainGUI:Add, Progress, x4 y452 w540 -smooth vMyProgress Range0-1000,
GuiControl,MainGUI:Hide,MyProgress
Gui, MainGUI:Add, Button, x2 y475 gselectsave vtext30,Save Settings
WM_MOUSEMOVE("text30","All Settings found at ""Advanced"" Section will be Saved`n`n`nSaves the current priority ranking of External Folders found at ""External Files"" Sub-Section since it is not autosaved.")
Gui, MainGUI:Font,Bold
Gui, MainGUI:Add, Button, x430 y475 h23 ginvccabout vtext31 hwndHBTN, About MOD Master
SetBtnTxtColor(HBTN, "Gold")
Gui, MainGUI:Add, Text,x450 y5 hwndHBTN vtext45,v%version%
SetBtnTxtColor(HBTN, "Bronze")
Gui, MainGUI:Font
Gui, MainGUI:Add, Text,vsearchnofound x4 y455 w540,%defaultshoutout%
Gui, MainGUI:Font,Bold cred
Gui, MainGUI:Add, CheckBox,checked%usemisc% x145 y475 gusemiscon vusemiscon,Use Miscellaneous on Future Injection
tmpr=
(
Miscellaneous is used by "Handy Injection" and "General" Section which injects extra functionalities


If this Option is ~ 

CHECKED : Miscellaneous Resources will be preloaded On Startup, allowing the use of Miscellaneous.

*Prosequences
-Allows "Handy Injection" and "General" Section to inject selected miscellaneous resources.
-Allows "Handy Injection" and "General" Section's Saved List Database to preload their present Miscellaneous Data's
-Allows "Handy Injection" and "General" Section to Add Miscellaneous Data's when saving a Database List.

*Consequences
-Requires to Preload all Miscellaneous first on startup which will take time ti finish.


UNCHECKED : Miscellaneous Resources will not be loaded on startup.

*Prosequences
-Instant Startup since Miscellaneous will not be Preloaded.

*Consequences
-"Handy Injection" and "General" Section will not include Miscellaneous Section on its Operations.
-"Handy Injection" and "General" Section's WILL NOT include Miscellaneous Data's when preloading a database list
-"Handy Injection" and "General" Section will not include Miscellaneous Data's when creating a Database List.
)
WM_MOUSEMOVE("usemiscon",tmpr)
Gui, MainGUI:Font

Gui, MainGUI:Font,Bold
Gui, MainGUI:Add, CheckBox,checked%useextportraitfile% x1 y145 w300 vuseextportraitfile,Use the External File's "portraits.txt" instead of the Operation's "portraits.txt"
Gui, MainGUI:Add, Button, x180 y60 h23 gextlistrefresh vextlistrefresh hwndHBTN, Refresh Lists
tmpr=
(
Rescans all present folders found at Folder:
%A_ScriptDir%\External Files\

Also defines some informations about the folder.
)
WM_MOUSEMOVE("extlistrefresh",tmpr)

SetBtnTxtColor(HBTN, "Green")
Gui, MainGUI:Add, Button, x50 y50 h23 gextlistup vextlistup hwndHBTN, Move Up
WM_MOUSEMOVE("extlistup","Any selected rows on the listview below will move upwards, increasing its priority rank.")
SetBtnTxtColor(HBTN, "PURPLE")
Gui, MainGUI:Add, Button, x43 y75 h23 gextlistdown vextlistdown hwndHBTN, Move Down
WM_MOUSEMOVE("extlistdown","Any selected rows on the listview below will move downwards, decreasing its priority rank.")
SetBtnTxtColor(HBTN, "GRAY")
Gui, MainGUI:Font,Bold cblue
Gui, MainGUI:Add, CheckBox,checked%useextfile% x112 y475 vuseextfile,Include the External Files on Future Operations
Gui, MainGUI:Font,Bold cred
Gui, MainGUI:Add, CheckBox,checked%useextitemgamefile% x1 y100 h45 w300 vuseextitemgamefile,Use the External File's "items_game.txt" instead of the Operation's "items_game.txt"
WM_MOUSEMOVE("useextitemgamefile","This is not advisable to be checked since the operations's generated items_game.txt is accurate and stable. ANY PRESENCE OF AN UNUPDATED/CORRUPTED ITEMS_GAME.TXT while this option is checked might lead to UNEXPECTED GAME CRASH,IMMEDIATE TERMINATION OF THE GAME. Check this at your own risk and make sure that you know what you are doing")
Gui, MainGUI:Font
Gui, MainGUI:Add, Text,vtext46 x305 y45 w225 h400,
(
This Section is all about adding custom files. If you wish to include custom model(.vmdl_c),particle effects(.vpcf_c), or even your own items_game.txt,You can include external files that will be added on the operations files.

External Files is commonly used if you have your own "pak01_dir" folder which have custom item sets(including arcanas) and "you want to use this files that instead of using the operational files(.vmdl_c,.vpcf_c,items_game.txt,ect)".

External Files is the "workaround" for "malfunctioning cosmetic items in online games"(eg. arcana items,no default prefab cosmetic items), to Do this, Put your custom "pak01_dir" folder at:

%A_ScriptDir%\External Files\

Any folder found at the "External Files" Folder will be included on the listview(make sure to click "Refresh Lists").

The Priority Ranking indicates the Majority ranking of the external files,any rows that are above other rows will not be overwritten by the rows beneath them, but rows that are below other rows will be overwritten by files with the same match which a row above it has.
)

Gui, MainGUI:Add, ListView,x1 y170 w280 h250 vextfilelist AltSubmit checked -LV0x10 NoSortHdr NoSort ,Priority Rank|Folder Name|Model Files Present|Particle Files Present|Has items_game.txt|Has portraits.txt|Folder Location


;;;controls the external file's controls and also all hidden controls
hiddencontrols=InnerTab,InnerTab1,InnerTab2,usemiscon
hiddencontrolscontroller=Miscellaneous,Handy Injection,General,Miscellaneous

exthiddencontrols=extlistrefresh,extlistup,extlistdown,extfilelist,text46,useextitemgamefile,useextfile,useextportraitfile
exthiddencontrolscontroller=Handy Injection,General
exthiddencontrolstab=InnerTab1,InnerTab2
;;;;

IniRead,inchoosetab2,%A_ScriptDir%\Settings.aldrin_dota2mod,Edits,inchoosetab2,1
intablist2=Main|External Files
Gui, MainGUI:Add, Tab2,x0 y20 h480 w550 -Wrap gSelectOuterTab vInnerTab2 hwndInnerTab2 choose%inchoosetab2%,%intablist2%
Gui, MainGUI:Tab,1
Gui, MainGUI:Add, Edit,Number x185 y110 w140 h23 vinjectto,
Gui, MainGUI:Font,Bold
Gui, MainGUI:Add, Button, x460 y112 w84 h23 ginvupdate vtext1 hwndHBTN, Update
tmpr=
(
Add's the properties in the listview, defining that "Code to Inject(ID)" will inject "Inject to(ID)".


If "Code to Inject(ID)" is already present on the listview's "Resource ID" Column, it will just update the "Injected ID" of the same row into the defined "Inject to(ID)"


If "Inject to(ID)" is already present on the listview's "Injected ID" Column, it will just update the "Resource ID" of the same row into the defined "Code to Inject(ID)"
)
WM_MOUSEMOVE("text1",tmpr)

SetBtnTxtColor(HBTN, "Green")
Gui, MainGUI:Add, Button, x460 y80 w84 h23 ginvdelete vtext2 hwndHBTN, Delete
WM_MOUSEMOVE("text2","Deletes all selected rows on the listview, you can select multiple rows to delete them at the same time.")
SetBtnTxtColor(HBTN, "Red")
Gui, MainGUI:Add, Button, x1 y420 h21 gdatabrowse vtext6, Browse Database
tmpr=
(
Browse a General Database that has an extension of ( .aldrin_dota2db ).

Preloading a database will define all your collections of items.


Take Note : General Database( .aldrin_dota2db ) is different from Handy Injection Database( .aldrin_dota2hidb )
)
WM_MOUSEMOVE("text6",tmpr)

Gui, MainGUI:Add, Button, x116 y475 gdatasave vtext7 hwndHBTN,Save List Database
tmpr=
(
Saves all items found on the listview including all selected miscellaneous resources, creating a General Database with Extension ( .aldrin_dota2db ).


Creating a General Database will allow you to define all your collections and redefine all of them in the future. So that you can continue your previous work and just update the database.
)
WM_MOUSEMOVE("text7",tmpr)

SetBtnTxtColor(HBTN, "Green")
Gui, MainGUI:Add, Button, x273 y475 gselectinject vtext8 hwndHBTN, Inject all Actived ID's
SetBtnTxtColor(HBTN, "Blue")
Gui, MainGUI:Add, Button, x1 y45 w60 h21 ginvbrowse vtext5, Browse
WM_MOUSEMOVE("text5","Browse your custom ""items_game.txt"" if you want to use it instead of the current items_game.txt")
Gui, MainGUI:Font
Gui, MainGUI:Add, ListView, vinvlv ginvlv x1 y138 w545 h280 -LV0x10 checked AltSubmit, Resource ID|Injected ID|Resource Name|Injected Name|Item Styles Count|Current Item Style
WM_MOUSEMOVE("invlv","Right-Click an item to change its Item Style")

Gui, MainGUI:Add, Text, x10 y95 vtext3,Code to Inject(ID)
Gui, MainGUI:Add, Text, x185 y95 vtext4,Inject to(ID)
Gui, MainGUI:Add, Edit,Number x10 y110 w140 h23 vinjectfrom,
Gui, MainGUI:Add, DropDownList,choose1 x61 y45 w485 h21 gdirremover vinvdirview,%mapinvdirview% ; 30+15
WM_MOUSEMOVE("invdirview","To remove a list on this dropdownlist, simply left-click this dropdownlist and then left-click the list you want to remove.")

Gui, MainGUI:Add, CheckBox, checked%ucr% x6 y70 vucron gucron,Use the custom "items_game.text"(chosen above) as Resource ID?
tmpr=
(
If you have your own "items_game.txt" and you want to use this custom items_game.txt on the General's Operations instead of the real items_game.txt, Check this Option. This Option is commonly used by MODDERS who know what they're doing.


If this Option is ~ 

CHECKED : Uses the custom "items_game.txt" on the future Operations here at "General" Section. This option can only be checked if you already defined the custom items_game.txt above.

*Prosequences
-If you have a modified items_game.txt(with latest references) for example, have a modified dire/radiant towers which DOTA2 MOD Master still does not support yet. The injector will use this MODIFIED items_game.txt for future use

*Consequences
-If the "custom items_game.txt" is OLD/corrupted/unstable, it will lead to EVIL CRASH when playing the game. That is why it is unadvisable checking this option if you dont know what you're doing


UNCHECKED : Uses the real "items_game.txt" provided by DOTA2 MOD Master on the future Operations here at "General" Section.

*Prosequences
-Stable and Successful Operation.
)
WM_MOUSEMOVE("ucron",tmpr)

Gui, MainGUI:Add, DropDownList,choose1 x112 y420 w435 h21 gdirremover vdatadirview,%mapdatadirview%
WM_MOUSEMOVE("datadirview","To remove a list on this dropdownlist, simply left-click this dropdownlist and then left-click the list you want to remove.")

IniRead,inchoosetab1,%A_ScriptDir%\Settings.aldrin_dota2mod,Edits,inchoosetab1,1
intablist1=Hero Items Selection|Used Items Database|Statistics|Custom Heroes|External Files
Gui, MainGUI:Add, Tab2,x0 y20 h480 w550 -Wrap gSelectOuterTab vInnerTab1 hwndInnerTab1 choose%inchoosetab1%,%intablist1%
Gui, MainGUI:Tab,1
Gui, MainGUI:Add, ComboBox,x1 y45 w155 h405 gherochoice vherochoice Choose1 Simple,%mapherochoice%
Gui, MainGUI:Add, ListView,-LV0x10 NoSort NoSortHdr vshowitems gdoitems x173 y45 w375 h405 checked AltSubmit,Item Name|Item Slot|Rarity|Item ID|Used by|Styles Count|Active Style
WM_MOUSEMOVE("showitems","
(
*Right-Click an item to change its Item Style

*Only one item per item slot can be selected
)")

Gui, MainGUI:Font,Bold
Gui, MainGUI:Add, Button, x283 y475 ghdatasave vtext16 hwndHBTN,Save List Database
tmpr=
(
Saves all items found on "Used Items Database" Sub-Section's Listview including all selected miscellaneous resources, creating a Handy Injection Database with Extension ( .aldrin_dota2hidb ).


Creating a Handy Injection Database will allow you to define all your collections and redefine all of them in the future. So that you can continue your previous work and just update the database.
)
WM_MOUSEMOVE("text16",tmpr)

SetBtnTxtColor(HBTN, "Green")
Gui, MainGUI:Add, Button, x116  y475 ghselectinject vtext17 hwndHBTN, Inject all Actived ID's
SetBtnTxtColor(HBTN, "Blue")
Gui, MainGUI:Font
Gui, MainGUI:Tab,2
Gui, MainGUI:Add, ListView,gitemview vitemview x1 y45 w545 h371 -LV0x10 AltSubmit,Item Name|Item Slot|Rarity|Item ID|Used by|Styles Count|Active Style
tmpr=
(
Right-Click an item to:

*Change its Item Style

*Delete Selected Rows
)
WM_MOUSEMOVE("itemview",tmpr)

Gui, MainGUI:Add, DropDownList,choose1 x112 y420 w280 h21 gdirremover vhdatadirview,%maphdatadirview%
WM_MOUSEMOVE("hdatadirview","To remove a list on this dropdownlist`, simply left-click this dropdownlist and then left-click the list you want to remove.")
Gui, MainGUI:Font,Bold
Gui, MainGUI:Add, Button,x395 y420 w150 h21 gVerifyListviewIntegrity vtext51 hwndHBTN,Verify ListView Integrity
WM_MOUSEMOVE("text51","
(
Examine all informations found at the ListView. Detecting Errors,Corruption affecting the database.
This Also Refreshes all informations that have errors, See ErrorLog at Advanced Section for further Details about the Operation Afterwards.
)")
SetBtnTxtColor(HBTN, "Purple")
Gui, MainGUI:Add, Button, x1 y420 h21 ghdatabrowse vtext18, Browse Database
tmpr=
(
Browse a Handy Injection Database that has an extension of ( .aldrin_dota2hidb ).

Preloading a database will define all your collections of items.


Take Note : Handy Injection Database( .aldrin_dota2hidb ) is different from General Database( .aldrin_dota2db )
)
WM_MOUSEMOVE("text18",tmpr)

Gui, MainGUI:Add, Button, x283 y475 ghdatasave vtext19 hwndHBTN,Save List Database
tmpr=
(
Saves all items found on the Listview above including all selected miscellaneous resources, creating a Handy Injection Database with Extension ( .aldrin_dota2hidb ).


Creating a Handy Injection Database will allow you to define all your collections and redefine all of them in the future. So that you can continue your previous work and just update the database.
)
WM_MOUSEMOVE("text19",tmpr)

SetBtnTxtColor(HBTN, "Green")
Gui, MainGUI:Add, Button, x116  y475 ghselectinject vtext20 hwndHBTN, Inject all Actived ID's
SetBtnTxtColor(HBTN, "Blue")
Gui, MainGUI:Font
Menu, MyContextMenu, Add, Delete, hbuttondelete
Menu, MyContextMenu, Add, Change Style, hbuttonstyle
Menu, MyContextMenu, Add, Increase Priority, hincprio
Menu, MyContextMenu, Add, Decrease Priority, hdecprio
Gui, MainGUI:Tab,3
Gui, MainGUI:Add, Text, x1 y45,Calibrator Settings
Gui, MainGUI:Add, ListView,NoSort vstatscalibrator gstatscalibrator x1 y60 w150 h390 checked AltSubmit,Item Slot
WM_MOUSEMOVE("statscalibrator","
(
You can manually calibrate what the statistics will recognize as a valid item slot.

If the Item Slot is checked, the statistics will include this item slot when counting hero number of item slots.

If the Item Slot is unchecked, the statistics will reject this item slot when counting hero number of item slots.
)")
Gui, MainGUI:Add, ListView,vslotstats x155 y45 w391 h405 -LV0x10 AltSubmit,Hero Name|Item Slots Count|Item Slots Occupied|Item Slots Unoccupied
Gui, MainGUI:Tab,4
Gui, MainGUI:Add, ListView,gchview vchview x1 y45 w300 h405 -LV0x10 AltSubmit,Custom Hero|Existence
Gui, MainGUI:Font,Bold
Gui, MainGUI:Add, Button, x310 y75 gchadd vtext25 hwndHBTN,Add Hero
SetBtnTxtColor(HBTN, "Blue")
Gui, MainGUI:Add, Button, x425 y75 gchsave vtext27 hwndHBTN,Save and Reload
WM_MOUSEMOVE("text27","You need to Save all the list you just added and reload the script so that on the next start it will be included on the combobox found at ""Hero Items Selection"" Sub-Section.")
SetBtnTxtColor(HBTN, "Green")
Gui, MainGUI:Font
Gui, MainGUI:Add, Edit, vchbar x310 y45 w225,
Gui, MainGUI:Add, Text, x310 y105 w225 vtext28,This section is all about adding custom heroes and be used on future count of heroes present at "Handy Injection" Section`n`nCommon reasons of adding "Custom Heroes":`n-You are testing a custom added hero of yours on DOTA2 and added "item slots" on it.`n`nwhat is inside this section where:`n*Edit Box-type the FULL HERO NAME(npc_dota_hero_***) here. Example:npc_dota_hero_rubick and NOT rubick(without npc_dota_hero_)`n*List(left-side)-this is where the list of custom heroes are listed`n*Add-adds the current typed hero on the list`n*Save and Reload-if you are already finished adding custom heroes and ready to use it.This tool needs to preload its resources first by reloading the script and saving the names of the custom heroes.
Menu, chContextMenu, Add, Delete, chbuttondelete
IniRead,inchoosetab,%A_ScriptDir%\Settings.aldrin_dota2mod,Edits,inchoosetab
intablist=Single Source|Multiple Styles|Multiple Source|Optional Features
Gui, MainGUI:Add, Tab2,x0 y20 h480 w550 -Wrap vInnerTab hwndInnerTab choose%inchoosetab%,%intablist%
Gui, MainGUI:Tab,1
singlesourcefamily=Weather-Effect|Multikill-Banner|Emblem|Music Pack|Cursor Pack|Loading Screen|Versus Screen|Emoticons
Gui, MainGUI:Add, ComboBox,x1 y45 w155 h405 gmiscchoose vsinglesourcechoicegui Choose%singlesourcechoice% Simple AltSubmit,%singlesourcefamily%
Gui, MainGUI:Add, ListView,-LV0x10 x173 y45 w375 h405 gbasicmisc Hidden vweatherchoice AltSubmit checked,Weather-Effect Name|Rarity|ID
Gui, MainGUI:Add, ListView,-LV0x10 x173 y45 w375 h405 gbasicmisc Hidden vmultikillchoice AltSubmit checked,Multikill-Banner Name|Rarity|ID
Gui, MainGUI:Add, ListView,-LV0x10 x173 y45 w375 h405 gbasicmisc Hidden vemblemchoice AltSubmit checked,Emblem Name|Rarity|ID
Gui, MainGUI:Add, ListView,-LV0x10 x173 y45 w375 h405 gbasicmisc Hidden vmusicchoice AltSubmit checked,Music Pack Name|Rarity|ID
Gui, MainGUI:Add, ListView,-LV0x10 x173 y45 w375 h405 gbasicmisc Hidden vcursorchoice AltSubmit checked,Cursor Pack Name|Rarity|ID
Gui, MainGUI:Add, ListView,-LV0x10 x173 y45 w375 h405 gbasicmisc Hidden vloadingscreenchoice AltSubmit checked,Loading Screen Name|Rarity|ID
Gui, MainGUI:Add, ListView,-LV0x10 x173 y45 w375 h405 gbasicmisc Hidden vversuscreenchoice AltSubmit checked,Versus Screen Name|Rarity|ID
Gui, MainGUI:Add, ListView,-LV0x10 x173 y45 w375 h405 gbasicmisc Hidden vemoticonchoice AltSubmit checked,Emoticons Name|Rarity|ID
WM_MOUSEMOVE(["weatherchoice","multikillchoice","emblemchoice","musicchoice","cursorchoice","loadingscreenchoice","versuscreenchoice","emoticonchoice"],"Only one item can be selected.")

Gui, MainGUI:Tab,2
multiplestylesfamily=Courier|Ward|HUD-Skin|Radiant Creeps|Dire Creeps|Radiant Towers|Dire Towers|Terrain
Gui, MainGUI:Add, ComboBox,x1 y45 w155 h405 gmiscchoose vmultiplestyleschoicegui Choose%multiplestyleschoice% Simple AltSubmit,%multiplestylesfamily%
Gui, MainGUI:Add, ListView,-LV0x10 x173 y45 w375 h405 gmiscstyle Hidden vterrainchoice AltSubmit checked,Terrain Name|Rarity|ID|Styles Count|Active Style
Gui, MainGUI:Add, ListView,-LV0x10 x173 y45 w375 h405 gmiscstyle Hidden vhudchoice AltSubmit checked,HUD-Skin Name|Rarity|ID|Styles Count|Active Style
Gui, MainGUI:Add, ListView,-LV0x10 x173 y45 w375 h405 gmiscstyle Hidden vradcreepchoice AltSubmit checked,Radiant Creeps Name|Rarity|ID|Styles Count|Active Style
Gui, MainGUI:Add, ListView,-LV0x10 x173 y45 w375 h405 gmiscstyle Hidden vdirecreepchoice AltSubmit checked,Dire Creeps Name|Rarity|ID|Styles Count|Active Style
Gui, MainGUI:Add, ListView,-LV0x10 x173 y45 w375 h405 gmiscstyle Hidden vradtowerchoice AltSubmit checked,Radiant Towers Name|Rarity|ID|Styles Count|Active Style
Gui, MainGUI:Add, ListView,-LV0x10 x173 y45 w375 h405 gmiscstyle Hidden vdiretowerchoice AltSubmit checked,Dire Towers Name|Rarity|ID|Styles Count|Active Style
Gui, MainGUI:Add, ListView,-LV0x10 x173 y45 w375 h405 gmiscstyle Hidden vcourierchoice AltSubmit checked,Courier Name|Rarity|ID|Styles Count|Active Style
Gui, MainGUI:Add, ListView,-LV0x10 x173 y45 w375 h405 gmiscstyle Hidden vwardchoice AltSubmit checked,Ward Name|Rarity|ID|Styles Count|Active Style
WM_MOUSEMOVE(["terrainchoice","hudchoice","radcreepchoice","direcreepchoice","radtowerchoice","diretowerchoice","courierchoice","wardchoice"],"Only one item can be selected.`n`nRight-Click an item to change its Item Style.")

Gui, MainGUI:Tab,3
Gui, MainGUI:Add, ListView,-LV0x10 x275 y45 w272 h404 gannouncerview vannouncerview AltSubmit NoSort checked,Announcer Name|Item Slot|Rarity|ID
WM_MOUSEMOVE("announcerview","Only one Announcer can be selected.`n`nOnly one Mega-Kill Announcer can be selected.")
Gui, MainGUI:Add, ListView,-LV0x10 x1 y45 w272 h404 gtauntview vtauntview AltSubmit NoSort checked,Taunt Name|Rarity|ID|Used by
WM_MOUSEMOVE("tauntview","Only one Taunt per Hero can be selected.")
Gui, MainGUI:Tab,4
Gui, MainGUI:Add, CheckBox, checked%pet% x9 y60 vpeton,Active "Almond the Frondillo" Pet with Style:
if (mappetstyle="") or (mappetstyle="ERROR")
{
	mappetstyle=3
}
else if mappetstyle=0
{
	mappetstyle=1
}
Gui, MainGUI:Add, DropDownList,R3 x240 y60 w40 h20 vpetstyle choose%mappetstyle%,0|1|2
WM_MOUSEMOVE("petstyle","
(
Select the current style of Almond the Frondillo:


Style 0 - Natural Color

Style 1 - Red Shelled Almond the Frondillo

Style 2 - Golden Shelled Almond the Frondillo
)")

innertabparam=InnerTab,InnerTab1,InnerTab2 ;;;used always at anchor
loop,parse,innertabparam,`,
{
	tempo:=%A_LoopField%
	WinSet Top,, ahk_id %tempo%
}

Gui, MainGUI:Default

listviewparam=showitems,weatherchoice,multikillchoice,emblemchoice,musicchoice,cursorchoice,loadingscreenchoice,versuscreenchoice,emoticonchoice,terrainchoice,hudchoice,radcreepchoice,direcreepchoice,radtowerchoice,diretowerchoice,courierchoice,wardchoice,announcerview,tauntview ; register this listviews as colored listviews
loop,parse,listviewparam,`,
{
	LVA_ListViewAdd(A_LoopField)
}
VarSetCapacity(listviewparam,0)
OnMessage("0x4E", "LVA_OnNotify")

Gui, MainGUI:Submit, NoHide
gosub, SelectOuterTab
Tooltip
Gui,MainGUI:Show, h500 w550,AJOM's Dota 2 MOD Master
Gui, MainGUI: +hwndMainGUIHWND
gosub,activatemiscgui

gosub,MainGUIGuiSize ; Anchor Function requires this command so that it will get all the offsets of each controls
if usemiscon=1
{
	GoSub,miscreload
}
if A_DefaultListView<>itemview
{
	Gui, MainGUI:ListView,itemview
}
LV_ClearAll()
GoSub,chreload
if datadirview<>
{
	if usemiscon=1
	{
		if (hdatadirview<>"") and (datadirview<>"")
		{
			Gui MainGUI:+OwnDialogs
			SetTimer,ChangeButtonNames,1
			msgbox,292,Miscellaneous Resources Conflict,The tool currently preloads two database files`, a General Database and a Handy-Injection Database. Miscellaneous can only be used by one database file. Choose which database will use the Miscellaneous Resources.`n`n`nNote: The other unselected one will not preload its Miscellaneous Resources.
			IfMsgBox, Yes 
			{
				tempo=1
			}
		}
		else tempo=1
	}
	GoSub,datareload
	if (usemiscon=1) and (tempo=1)
	{
		reloadmisc(datadirview) ; ;Scans the database then put a checkmark on each miscellaneous it uses
	}
	if soundon=1
	{
		SoundPlay,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\Sound\loaddatacomplete.wav
	}
}
else tempo=0
if hdatadirview<>
{
	hdatareload(hdatadirview)
	checkdetector() ; check any field that exist on the listview "itemview"
	if (usemiscon=1) and (tempo<>1)
	{
		reloadmisc(hdatadirview) ; ;Scans the database then put a checkmark on each miscellaneous it uses
	}
	if soundon=1
	{
		SoundPlay,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\Sound\loaddatacomplete.wav
	}
}
gosub,extlistrefresh

;;
GuiControl,-g,statscalibrator
gosub,slotstats ; construct the handy-injection statistics
GuiControl,+gstatscalibrator,statscalibrator
;;

if newuser=1
{
	msgbox,36,Welcome New User!,It Looks like this is the first time you have used this Tool. Would you like to know the facts about using this Tool?(This will be helpful if you dont have an idea using this tool)
	IfMsgBox Yes
	{
		gosub,invccabout
		guicontrol,aboutgui:ChooseString,tababout,Fact
	}
}
else if version>%usedversion%
{
	msgbox,36,Hey There!,It Looks like this Version is Newer. Would you like to know What's New on this Version?
	IfMsgBox Yes
	{
		gosub,invccabout
		guicontrol,aboutgui:ChooseString,tababout,What's New
	}
}
if version<>%usedversion%
{
	FileSetAttrib,-R,%A_ScriptDir%\Settings.aldrin_dota2mod
	IniWrite,%version%,%A_ScriptDir%\Settings.aldrin_dota2mod,Edits,usedversion
	FileSetAttrib,+R,%A_ScriptDir%\Settings.aldrin_dota2mod
}
gosub,leakdestroyer
gosub,showtooltips
Gui, MainGUI:Default
return

rescanresources:
ifexist,%A_ScriptDir%\Library\Reference.aldrin_dota2mod
{
	FileSetAttrib,-R,%A_ScriptDir%\Library\Reference.aldrin_dota2mod
	FileDelete,%A_ScriptDir%\Library\Reference.aldrin_dota2mod
}
Reload
Sleep 1000 ; detects when reload fails
msgbox,16,Error,Cannont Reload`,Please reload the Script Manually!
return

miscchoose:
Gui, MainGUI:Submit, NoHide
if ((A_GuiControl="singlesourcechoicegui") and (singlesourcechoicegui=singlesourcechoice)) or ((A_GuiControl="multiplestyleschoicegui") and (multiplestyleschoicegui=multiplestyleschoice))
{
	return
}
else if A_GuiEvent=DoubleClick
{
	gosub,activatemiscgui
	if (A_GuiControl="singlesourcechoicegui")
		singlesourcechoice:=singlesourcechoicegui
	else if (A_GuiControl="multiplestyleschoicegui")
		multiplestyleschoice:=multiplestyleschoicegui
}
return

activatemiscgui:
Gui, MainGUI:Submit, NoHide
param=weatherchoice,multikillchoice,emblemchoice,musicchoice,cursorchoice,loadingscreenchoice,versuscreenchoice,emoticonchoice
loop,parse,param,`,
{
	if (A_Index=singlesourcechoicegui)
		GuiControl, Show, %A_LoopField%
	else if (A_Index=singlesourcechoice)
		GuiControl, Hide, %A_LoopField%
	else if (A_Index>singlesourcechoice) and (A_Index>singlesourcechoicegui)
		break
	
}

param=courierchoice,wardchoice,hudchoice,radcreepchoice,direcreepchoice,radtowerchoice,diretowerchoice,terrainchoice
loop,parse,param,`,
{
	if (A_Index=multiplestyleschoicegui)
		GuiControl, Show, %A_LoopField%
	else if (A_Index=multiplestyleschoice)
		GuiControl, Hide, %A_LoopField%
	else if (A_Index>multiplestyleschoice) and (A_Index>multiplestyleschoicegui)
		break
}
return

ChangeButtonNames:
IfWinNotExist,Miscellaneous Resources Conflict
    return  ; Keep waiting.
SetTimer, ChangeButtonNames, Off
ControlSetText, Button1,General
ControlSetText, Button2,HandyInjection
return

patchgi:
Gui, MainGUI:Submit, NoHide
ifnotExist,%giloc%
{
	Gui, MainGUI:+Disabled 
	guicontrol,,autovpkon,0
	msgbox,20,ERROR!,The located "gameinfo.gi" path Does not EXIST! Would you Like to browse the "gameinfo.gi" location? exist at "steam\steamapps\common\dota 2 beta\game\dota\gameinfo.gi"
	if IfMsgBox Yes
	{
		gosub,gilocbrowse
		if invfile<>
		{
			guicontrol,,autovpkon,1
		}
		else
		{
			return
		}
	}
	else
	{
		return
	}
	Gui, MainGUI:-Disabled 
}
else if giloc=
{
	Gui, MainGUI:+Disabled 
	guicontrol,,autovpkon,0
	msgbox,20,ERROR!,Please locate "gameinfo.gi" first before activating this feature. Would you Like to browse the "gameinfo.gi" location? exist at "steam\steamapps\common\dota 2 beta\game\dota\gameinfo.gi"
	if IfMsgBox Yes
	{
		gosub,gilocbrowse
		if invfile<>
		{
			guicontrol,,autovpkon,1
		}
		else
		{
			return
		}
	}
	else
	{
		return
	}
	Gui, MainGUI:-Disabled 
}
Gui, MainGUI:+Disabled 
GuiControl,Text,searchnofound,Patching gameinfo.gi
Gui, MainGUI:Submit, NoHide
gosub,gipatcher
GuiControl,MainGUI:Text,searchnofound,%defaultshoutout%
GuiControl,MainGUI:Show,searchnofound
Gui, MainGUI:-Disabled 
return

percentsound:
if (progress>=250) and (soundswitch1=0) and (sound25=1)
{
	soundswitch1=1
	SoundPlay,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\Sound\25.wav
}
else if (progress>=350) and (soundswitch2=0) and (sound25=1)
{
	soundswitch2=1
	SoundPlay,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\Sound\35.wav
}
else if (progress>=500) and (soundswitch3=0) and (sound25=1)
{
	soundswitch3=1
	SoundPlay,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\Sound\50.wav
}
else if (progress>=650) and (soundswitch4=0) and (sound25=1)
{
	soundswitch4=1
	SoundPlay,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\Sound\65.wav
}
else if (progress>=750) and (soundswitch5=0) and (sound25=1)
{
	soundswitch5=1
	SoundPlay,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\Sound\75.wav
}
return

initsound:
sound25:=sound35:=sound50:=sound65:=sound75:=soundswitch1:=soundswitch2:=soundswitch3:=soundswitch4:=soundswitch5:=0
soundratio2:=soundint*0.75
soundratio:=soundratio2/30
if (soundratio<5) and (soundratio>1)
{
	soundratio1:=soundratio2/soundratio
	loop %soundratio%
	{
		if A_Index=1
		{
			tmp4:=soundratio1
		}
		else if A_Index=%soundratio%
		{
			tmp4:=soundratio2
		}
		else
		{
			tmp4:=soundratio2/A_Index
		}
		if tmp4<29.99
		{
			sound25=1
		}
		else if (tmp4>=30) and (tmp4<50)
		{
			sound35=1
		}
		else if (tmp4>=42.5) and (tmp4<57.49)
		{
			sound50=1
		}
		else if (tmp4>=57.5) and (tmp4<69.99)
		{
			sound65=1
		}
		else if tmp4>=70
		{
			sound75=1
		}
	}
}
else if soundratio>1
{
	sound25:=sound35:=sound50:=sound65:=sound75:=1
}
return

ucron:
Gui, MainGUI:Submit, NoHide
if ucron=1
{
	if invdirview=
	{
		Gui, MainGUI:+Disabled 
		guicontrol,,ucron,0
		msgbox,16,ERROR!,Please locate the custom "items_game.txt" first before activating this feature.
		Gui, MainGUI:-Disabled 
	}
	else ifnotExist,%invdirview%
	{
		Gui, MainGUI:+Disabled 
		guicontrol,,ucron,0
		msgbox,16,ERROR!,The located custom "items_game.txt" path Does not EXIST!
		Gui, MainGUI:-Disabled 
	}
}
return

SelectOuterTab:
Gui, MainGUI:Submit, NoHide
;uses hiddencontrols and hiddencontrolscontroller
loop,parse,hiddencontrolscontroller,`,
{
	tabintparam=%A_Index%
	tabfieldsaver=%A_LoopField%
	loop,parse,hiddencontrols,`,
	{
		if tabintparam=%A_Index%
		{
			if OuterTab=%tabfieldsaver%
			{
				GuiControl, MainGUI:Show,%A_LoopField%
			}
			else
			{
				GuiControl, MainGUI:Hide,%A_LoopField%
			}
		}
	}
}
;uses exthiddencontrols and exthiddencontrolscontroller
tabswitch=0
loop,parse,exthiddencontrolscontroller,`,
{
	tabfieldsaver=%A_LoopField%
	tabintparam=%A_Index%
	loop,parse,exthiddencontrolstab,`,
	{
		tempo:=%A_LoopField%
		if tabintparam=%A_Index%
		{
			loop,parse,exthiddencontrols,`,
			{
				if (OuterTab=tabfieldsaver) and (tempo="External Files")
				{
					GuiControl, MainGUI:Show,%A_LoopField%
					tabswitch=1
				}
				else
				{
					GuiControl, MainGUI:Hide,%A_LoopField%
				}
			}
		}
	}
	if tabswitch=1
	{
		break
	}
}
if (OuterTab="Handy Injection") and (InnerTab1="Statistics")
{
	refreshstatistics() ; construct the statistics sub section
}
WinSet, Redraw, , A
return

selectreset:
Gui MainGUI:+OwnDialogs
msgbox,68,Confirm Removal,You are about to REMOVE the MOD from your DOTA2. Are you sure you want to to Continue?
IfMsgBox Yes
{
	Gui, MainGUI:+Disabled 
	GuiControl,MainGUI:Text,searchnofound,Deleting "%dota2dir%\game\Aldrin_Mods" Folder
	FileRemoveDir,%dota2dir%\game\Aldrin_Mods,1
	if soundon=1
	{
		SoundPlay,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\Sound\Removed.wav
	}
	GuiControl,MainGUI:Text,searchnofound,%defaultshoutout%
	GuiControl,MainGUI:Show,searchnofound
	
	Gui, MainGUI:-Disabled 
}
return

showprogress:
GuiControl,MainGUI:, MyProgress,
GuiControl,MainGUI:Show,MyProgress
return

hideprogress:
GuiControl,MainGUI:Hide,MyProgress
GuiControl,MainGUI:, MyProgress,
return

createvpk:
ifnotexist,%A_ScriptDir%\Plugins\VPKCreator\vpk.exe
{
	IfNotExist,%A_ScriptDir%\Generated MOD\
	{
		FileCreateDir, %A_ScriptDir%\Generated MOD
	}
	ifexist,%A_ScriptDir%\Generated MOD\items_game.txt
	{
		FileDelete,%A_ScriptDir%\Generated MOD\items_game.txt
	}
	FileAppend,%masterfilecontent%,%A_ScriptDir%\Generated MOD\items_game.txt
	Run,%A_ScriptDir%\Generated MOD\,,UseErrorLevel
	msgbox,16,ERROR!,"vpk.exe" is missing at:`n`n%A_ScriptDir%\Plugins\VPKCreator\`n`nMake sure to download "VPKCreator" and put all its files inside the required directory(%A_ScriptDir%\Plugins\VPKCreator\)`n`nAlternatively`,manually creating items_game.txt
	return
}
else ifnotexist,%giloc%
{
	IfNotExist,%A_ScriptDir%\Generated MOD\
	{
		FileCreateDir, %A_ScriptDir%\Generated MOD
	}
	ifexist,%A_ScriptDir%\Generated MOD\items_game.txt
	{
		FileDelete,%A_ScriptDir%\Generated MOD\items_game.txt
	}
	FileAppend,%masterfilecontent%,%A_ScriptDir%\Generated MOD\items_game.txt
	Run, %A_ScriptDir%\Generated MOD\,,UseErrorLevel
	msgbox,16,ERROR!,%giloc%`n`ndoes not exist! Cancelling vpk creation and manually creating items_game.txt
	return
}
gosub,hideprogress
GuiControl,Text,searchnofound,Shutnik Method: patching gameinfo.gi
IfNotExist,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\scripts\items\
{
	FileCreateDir,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\scripts\items
}
else ifexist,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\scripts\items\items_game.txt
{
	FileDelete,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\scripts\items\items_game.txt
}
FileAppend,%masterfilecontent%,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\scripts\items\items_game.txt
IfNotExist,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\scripts\npc\
{
	FileCreateDir,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\scripts\npc\
}
else ifexist,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\scripts\npc\portraits.txt
{
	FileDelete,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\scripts\npc\portraits.txt
}
FileAppend,%portstring%,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\scripts\npc\portraits.txt
gosub,externalfiles
gosub,gipatcher
GuiControl,Text,searchnofound,Shutnik Method: Creating pak01_dir.vpk
if InStr(giloc,"/dota/")>0
{
	stringgetpos,length,giloc,/dota/
}
else
{
	stringgetpos,length,giloc,\dota\
}
stringmid,modloc,giloc,1,%length%

tempo:=A_DetectHiddenWindows 
DetectHiddenWindows,On
;finish all extractions first
;for index,cPID in extractpid
;{
;	WinWaitClose,% "ahk_pid " cPID " ahk_exe cmd.exe ahk_class ConsoleWindowClass" ;wait indefinitely until it closes
;}
loop,parse,extractpid,`,
{
	WinWaitClose,% "ahk_pid " A_LoopField " ahk_exe cmd.exe ahk_class ConsoleWindowClass" ;wait indefinitely until it closes
}
VarSetCapacity(extractpid,0)
;
; tell the skinextract thread to terminate itself after finishing all its queue
IniWrite,1,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\extractlist.aldrin_dota2list,Status,terminateprogram
tempo:=A_DetectHiddenWindows 
WinWaitClose,ahk_pid %skinextract%
DetectHiddenWindows,%tempo%
;

GuiControl,Text,searchnofound,Shutnik Method: Executing Batch File... It will take more time if there are many cosmetic items injected!
loop
{
	if FileExist(A_ScriptDir "\Generated MOD\")
		FileCreateDir,%A_ScriptDir%\Generated MOD
	
	if FileExist(modloc "\Aldrin_Mods\")
		FileCreateDir,%modloc%\Aldrin_Mods
	
	runwait,vpk.exe pak01_dir,%A_ScriptDir%\Plugins\VPKCreator,Hide UseErrorLevel
	if (ErrorLevel<>"ERROR") and (A_LastError=0) and FileExist(A_ScriptDir "\Plugins\VPKCreator\pak01_dir.vpk") ;;  if the run is successful
	{
		FileMove,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir.vpk,%modloc%\Aldrin_Mods\,1
		if ErrorLevel ;; if the condition fails, the vpk file will be found at the generated mods folder
		{
			if soundon=1
			{
				SoundPlay,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\Sound\vpkdeletefailed.wav
			}
			FileMove,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir.vpk,%A_ScriptDir%\Generated MOD\,1
			Run, %A_ScriptDir%\Generated MOD\,,UseErrorLevel
			msgbox,16,ERROR!,Task:`nFile Move`n`nFilePath:`n%modloc%\Aldrin_Mods\pak01_dir.vpk`n`nStatus:`nFAILED`n`nResult:`n-pak01_dir.vpk was moved at"%A_ScriptDir%\Generated MOD\" Folder.`n`nPossible Inconvenience:`n- DOTA2 might be Running`n- pak01_dir.vpk is currently in used(opened) by other applications.`n`nFix:`n1) Manually delete the pak01_dir.vpk found at the "FilePath".`n2) Move the generated pak01_dir.vpk found at "%A_ScriptDir%\Generated MOD\" Folder directly to "FilePath".
		}
		break ;; terminate the loop
	}
	;; if the there was an error, rerun the batch file
}

GuiControl,+cDefault,searchnofound
GuiControl,MainGUI:Text,searchnofound,%defaultshoutout%
GuiControl,MainGUI:Show,searchnofound
return

miscstyle:
if A_GuiEvent = RightClick
{
	Gui, MainGUI:Default
	if A_DefaultListView<>%A_GuiControl%
	{
		Gui, MainGUI:ListView,%A_GuiControl%
	}
	LV_GetText(stylescount,A_EventInfo,4)
	LV_GetText(countcheck,A_EventInfo,5)
	if stylescount>%countcheck%
	{
		countcheck+=1
	}
	else
	{
		countcheck=0
	}
	LV_Modify(A_EventInfo,"Col5",countcheck)
}
if InStr(ErrorLevel, "C", true)
{
	if A_DefaultListView<>%A_GuiControl%
	{
		Gui, MainGUI:ListView, %A_GuiControl%
	}
	Loop % LV_GetCount()
	{
		if A_EventInfo<>%A_Index%
		{
			LV_Modify(A_Index,"-Check")
		}
	}
}
gosub,detectsorting
return

execmisc:
extrafilter=`r`n%A_Tab%%A_Tab%%A_Tab%"baseitem"%A_Tab%%A_Tab%"1"`r`n
replacefrom=`r`n%A_Tab%%A_Tab%%A_Tab%"name"
replaceto=`r`n%A_Tab%%A_Tab%%A_Tab%"baseitem"%A_Tab%%A_Tab%"1"`r`n%A_Tab%%A_Tab%%A_Tab%"name"
replaceto4=`r`n%A_Tab%%A_Tab%%A_Tab%"baseitem"%A_Tab%%A_Tab%"1"`r`n%A_Tab%%A_Tab%%A_Tab%"item_slot"%A_Tab%%A_Tab%"courier"`r`n%A_Tab%%A_Tab%%A_Tab%"name"
replaceto5=`r`n%A_Tab%%A_Tab%%A_Tab%"baseitem"%A_Tab%%A_Tab%"1"`r`n%A_Tab%%A_Tab%%A_Tab%"item_slot"%A_Tab%%A_Tab%"ward"`r`n%A_Tab%%A_Tab%%A_Tab%"name"
sfinder=`r`n%A_Tab%%A_Tab%}`r`n%A_Tab%%A_Tab%" ;"
;param=terrain,hud_skin,loading_screen,courier,ward,music,cursor_pack,radiantcreeps,direcreeps,radianttowers,diretowers,versus_screen,emoticon_tool
;param2=terrainchoice,hudchoice,loadingscreenchoice,courierchoice,wardchoice,musicchoice,cursorchoice,radcreepchoice,direcreepchoice,radtowerchoice,diretowerchoice,versuscreenchoice,emoticonchoice
multiplestyleparam=courierchoice,wardchoice,hudchoice,radcreepchoice,direcreepchoice,radtowerchoice,diretowerchoice,terrainchoice
;multiplesourceparam=tauntview,announcerview
param:=[["terrainchoice","terrain"]
,["hudchoice","hud_skin"]
,["loadingscreenchoice","loading_screen"]
,["courierchoice","courier"]
,["wardchoice","ward"]
,["musicchoice","music"]
,["cursorchoice","cursor_pack"]
,["radcreepchoice","radiantcreeps"]
,["direcreepchoice","direcreeps"]
,["radtowerchoice","radianttowers"]
,["diretowerchoice","diretowers"]
,["versuscreenchoice","versus_screen"]
,["emoticonchoice","emoticon_tool"]]
IPS:=A_TickCount

;declare a 2d array
miscinfo:=[]
loop 4
	miscinfo[A_Index]:=[]

for intsaver, in param
{
	if A_DefaultListView<>% param[intsaver,1]
	{
		Gui, MainGUI:ListView,% param[intsaver,1]
	}
	if LV_GetNext(,"Checked")<1
	{
		continue
	}
	subject:=param[intsaver,2]
	GuiControl,Text,searchnofound,Injecting %subject%
	Loop
	{
		firstloop=%A_Index%
		htarget=`r`n%A_Tab%%A_Tab%%A_Tab%"prefab"%A_Tab%%A_Tab%"%subject%"`r`n
		StringGetPos, ipos, masterfilecontent,%htarget%,L%firstloop%
		if ipos<0
		{
			Break
		}
		StringLen,filelength,masterfilecontent
		rightpos:=filelength-ipos
		StringGetPos, ipos1, masterfilecontent,%sfinder%,,%ipos%
		StringGetPos, ipos2, masterfilecontent,%sfinder%,R1,%rightpos%
		startpos:=ipos2+8
		ipos3:=ipos1-ipos2
		StringMid,misccontent,masterfilecontent,%startpos%,%ipos3%
		if InStr(misccontent,extrafilter)>0
		{
			defid:=iddetector(misccontent) ;filecontent := extracted content from items_game.txt
			LV_GetText(tmpstring,LV_GetNext(,"Checked"),3)
			filecontent:=miscdetector("prefab",subject,tmpstring) ;filecontent:=miscdetector("prefab",tmpfind,tmpstring,filestring) ; detects the contents of a miscellaneous item... In expression "prefab" means item_slot
			StringReplace,filecontent,filecontent,%tmpstring%"`r`n%A_Tab%%A_Tab%{,%defid%"`r`n%A_Tab%%A_Tab%{
			if (subject="courier") or (subject="ward")
			{
				defaultvisualscontent:=visualsdetector(misccontent) ; detects the Visual Section of the default content... this saves time for the engine to search over and over again.
				
				LV_GetText(numcheck,LV_GetNext(,"Checked"),4)
				LV_GetText(stylechecker,LV_GetNext(,"Checked"),5)
				itemname:=visualsdetector(filecontent) ; detects the Visual Section of the content
				StrReplace(itemname,.vmdl",.vmdl",extractcount)
				loop,%extractcount%
				{
					ipos1:=InStr(itemname,".vmdl",,,A_Index)
					ipos1:=InStr(itemname,"`r`n				""asset_modifier",,-strlen(itemname)+1+ipos1)
					ipos2:=InStr(itemname,"`r`n				}",,ipos1)
					modifierstring:=SubStr(itemname,ipos1,ipos2-ipos1)
					
					if ((numcheck=0) or (instr(modifierstring,"""style""		""" stylechecker """") and (numcheck>0)))
					{
						loop
						{
							ipos1:=InStr(defaultvisualscontent,".vmdl",,,A_Index)
							ipos1:=InStr(defaultvisualscontent,"`r`n				""asset_modifier",,-strlen(defaultvisualscontent)+1+ipos1)
							ipos2:=InStr(defaultvisualscontent,"`r`n				}",,ipos1)
							defaultmodifierstring:=SubStr(defaultvisualscontent,ipos1,ipos2-ipos1)
							
							if ((searchstringdetector(modifierstring,"""asset""")=searchstringdetector(defaultmodifierstring,"""asset"""))
							and (searchstringdetector(modifierstring,"""type""")=searchstringdetector(defaultmodifierstring,"""type""")))
							{
								;defaultloc:=StrReplace(searchstringdetector(defaultmodifierstring,"""modifier""") "_c","/","\")
								;defaultname:=SubStr(defaultloc,InStr(defaultloc,"\",,0)+1)
								;defaultloc:=SubStr(defaultloc,1,InStr(defaultloc,"\",,0)-1)
								;
								;extractfile:=StrReplace(searchstringdetector(modifierstring,"""modifier""") "_c","/","\")
								;realname:=SubStr(extractfile,InStr(extractfile,"\",,0)+1)
								
								defaultloc:=StrReplace(searchstringdetector(defaultmodifierstring,"""modifier""") "_c","/","\")
								miscinfo[1].Push(SubStr(defaultloc,InStr(defaultloc,"\",,0)+1))
								miscinfo[2].Push(SubStr(defaultloc,1,InStr(defaultloc,"\",,0)-1))
								
								extractfile:=StrReplace(searchstringdetector(modifierstring,"""modifier""") "_c","/","\")
								miscinfo[3].Push(SubStr(extractfile,InStr(extractfile,"\",,0)+1))
								miscinfo[4].Push(extractfile)
								
								break
							}
							
							if ErrorLevel
								break
						}
					}
				}
			}
			if instr(multiplestyleparam,param[intsaver,1]) ; if it is a multiple style subject identical to its listview control
			{
				if (subject="courier") or (subject="ward")
				{
					StringReplace,filecontent,filecontent,%replacefrom%,% replaceto%intsaver%
					portparam=game,game,game_flying,game_flying,game
					portparam1=donkey,donkey_dire,donkey_wings,donkey_dire_wings,default_ward
					loop,parse,portparam1,`,
					{
						porthero=%A_LoopField%
						portint=%A_Index%
						loop,parse,portparam,`,
						{
							if portint=%A_Index%
							{
								portfind=`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%"%A_LoopField%"`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%{
								if InStr(replaceto,portfind)>0
								{
									contentport=%replaceto%
									porttmp=models/props_gameplay/%porthero%.vmdl
									gosub,execportrait
								}
							}
						}
					}
				}
				else
				{
					;cavernite creeps produces animation bug on creeps thats why disabled
					tmpr:=searchstringdetector(filecontent,"""name""")
					if ((param[intsaver,2]="radiantcreeps") and (tmpr!="Cavernite Radiant Creeps"))
					or ((param[intsaver,2]="direcreeps") and (tmpr!="Cavernite Dire Creeps"))
					or (param[intsaver,2]="radianttowers") or (param[intsaver,2]="diretowers")
					{
						LV_GetText(numcheck,A_Index,4)
						LV_GetText(stylechecker,A_Index,5)
						contentport=%filecontent%
						gosub,extractmodel
					}
					StringReplace,filecontent,filecontent,%replacefrom%,%replaceto%
				}
				
				LV_GetText(stylechecker,LV_GetNext(,"Checked"),5)
				if stylechecker>0
				{
					filecontent:=stylechanger(stylechecker,filecontent) ;stylechanger will change the style of all particle effects and even the model
				}
				else
				{
					StringReplace,filecontent,filecontent,`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%%A_Tab%"style"%A_Tab%%A_Tab%"0",,1
				}
			}
			else
			{
				StringReplace,filecontent,filecontent,%replacefrom%,%replaceto%
			}
			StringReplace,masterfilecontent,masterfilecontent,%misccontent%,%filecontent%,1
			; measures the number of items injected per second
			Gui,MainGUI:Show,NoActivate,% floor(1000/(A_TickCount-IPS)) " Items per Second"
			IPS:=A_TickCount
			;
			Break
		}
		Else
		{
			VarSetCapacity(misccontent,0)
		}
		if ErrorLevel=1 ; hunt this errorlevel
		{
			Break
		}
	}
}
loop % Max(miscinfo[1].Count(),miscinfo[2].Count(),miscinfo[3].Count(),miscinfo[4].Count())
{
	defaultloc:=miscinfo[2,A_Index],extractfile:=miscinfo[4,A_Index]
	if (defaultloc<>"") and (extractfile<>"")
	{
		extractname:=miscinfo[3,A_Index]
		defaultname:=miscinfo[1,A_Index]
		repmocount:=repmocount+1
		IniWrite,%defaultloc%,%A_ScriptDir%\Plugins\ReportLog.aldrin_report,Present Models,ModelLocationPath_%repmocount%
		IniWrite,%defaultname%,%A_ScriptDir%\Plugins\ReportLog.aldrin_report,Present Models,ModelDefaultName_%repmocount%
		IniWrite,%extractname%,%A_ScriptDir%\Plugins\ReportLog.aldrin_report,Present Models,ModelRealName_%repmocount%
		
		gosub,extractfileruncmd
	}
}
if A_DefaultListView<>announcerview
{
	Gui, MainGUI:ListView,announcerview
}
loop % LV_GetCount()
{
	if (A_Index=LV_GetNext(A_Index-1,"Checked"))
	{
		LV_GetText(matcher,LV_GetNext(A_Index-1,"Checked"),2)
		LV_GetText(tmpstring,LV_GetNext(A_Index-1,"Checked"),4)
		GuiControl,Text,searchnofound,Injecting %matcher%
		htarget=`r`n%A_Tab%%A_Tab%%A_Tab%"item_slot"%A_Tab%%A_Tab%"%matcher%"`r`n
		Loop
		{
			StringGetPos, ipos, masterfilecontent,%htarget%,L%A_Index%
			if ipos<0
				break
			
			StringLen,filelength,masterfilecontent
			rightpos:=filelength-ipos
			StringGetPos, ipos1, masterfilecontent,%sfinder%,,%ipos%
			StringGetPos, ipos2, masterfilecontent,%sfinder%,R1,%rightpos%
			startpos:=ipos2+8
			ipos3:=ipos1-ipos2
			StringMid,misccontent,masterfilecontent,%startpos%,%ipos3%
			if InStr(misccontent,extrafilter)>0
			{
				filecontent=%misccontent%
				tmpbar:=iddetector(filecontent) ;filecontent := extracted content from items_game.txt
				defid=%tmpbar%
				tmpfind=%matcher%
				filecontent:=miscdetector("item_slot",tmpfind,tmpstring) ;filecontent:=miscdetector("item_slot",tmpfind,tmpstring,filestring) ; detects the contents of a miscellaneous item... In expression "item_slot" means item_slot
				StringReplace,filecontent,filecontent,%tmpstring%"`r`n%A_Tab%%A_Tab%{,%defid%"`r`n%A_Tab%%A_Tab%{
				StringReplace,filecontent,filecontent,%replacefrom%,%replaceto%
				StringReplace,masterfilecontent,masterfilecontent,%misccontent%,%filecontent%,1
				; measures the number of items injected per second
				Gui,MainGUI:Show,NoActivate,% floor(1000/(A_TickCount-IPS)) " Items per Second"
				IPS:=A_TickCount
				;
				Break
			}
			Else
			{
				VarSetCapacity(misccontent,0)
			}
			if ErrorLevel=1 ; hunt this errorlevel
			{
				Break
			}
		}
		
	}
}
if A_DefaultListView<>tauntview
{
	Gui, MainGUI:ListView,tauntview
}
GuiControl,Text,searchnofound,Injecting Taunt/s
if LV_GetNext(,"Checked")>0
{
	htarget=`r`n%A_Tab%%A_Tab%%A_Tab%"item_slot"%A_Tab%%A_Tab%"taunt"`r`n
	filter=`r`n%A_Tab%%A_Tab%%A_Tab%"used_by_heroes"`r`n%A_Tab%%A_Tab%%A_Tab%{`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%"all"%A_Tab%%A_Tab%"1"`r`n%A_Tab%%A_Tab%%A_Tab%}
	Loop
	{
		StringGetPos, ipos, masterfilecontent,%htarget%,L%A_Index%
		if ipos<0
			break
		
		StringLen,filelength,masterfilecontent
		rightpos:=filelength-ipos
		StringGetPos, ipos1, masterfilecontent,%sfinder%,,%ipos%
		StringGetPos, ipos2, masterfilecontent,%sfinder%,R1,%rightpos%
		startpos:=ipos2+8
		ipos3:=ipos1-ipos2
		StringMid,misccontent,masterfilecontent,%startpos%,%ipos3%
		if InStr(misccontent,filter)>0
		{
			StringReplace,tmp,misccontent,`r`n%A_Tab%%A_Tab%%A_Tab%"prefab"%A_Tab%%A_Tab%"default_item"`r`n,`r`n%A_Tab%%A_Tab%%A_Tab%"prefab"%A_Tab%%A_Tab%"wearable"`r`n,1
			StringReplace,masterfilecontent,masterfilecontent,%misccontent%,%tmp%,1
			; measures the number of items injected per second
			Gui,MainGUI:Show,NoActivate,% floor(1000/(A_TickCount-IPS)) " Items per Second"
			IPS:=A_TickCount
			;
			Break
		}
		Else
		{
			VarSetCapacity(misccontent,0)
		}
		if ErrorLevel=1 ; hunt this errorlevel
		{
			Break
		}
	}
}
loop % LV_GetCount()
{
	if (A_Index=LV_GetNext(A_Index-1,"Checked"))
	{
		LV_GetText(tmpstring,LV_GetNext(A_Index-1,"Checked"),3)
		tmpfind=taunt
		filecontent:=miscdetector("prefab",tmpfind,tmpstring) ;filecontent:=miscdetector("prefab",tmpfind,tmpstring,filestring) ; detects the contents of a miscellaneous item... In expression "prefab" means item_slot
		StringReplace,tmp,filecontent,%replacefrom%,%replaceto%
		StringReplace,tmp,tmp,`r`n%A_Tab%%A_Tab%%A_Tab%"prefab"%A_Tab%%A_Tab%"taunt"`r`n,`r`n%A_Tab%%A_Tab%%A_Tab%"baseitem"%A_Tab%%A_Tab%"1"`r`n%A_Tab%%A_Tab%%A_Tab%"prefab"%A_Tab%%A_Tab%"taunt"`r`n
		StringReplace,masterfilecontent,masterfilecontent,%filecontent%,%tmp%,1
		; measures the number of items injected per second
		Gui,MainGUI:Show,NoActivate,% floor(1000/(A_TickCount-IPS)) " Items per Second"
		IPS:=A_TickCount
		;
	}
}
if A_DefaultListView<>weatherchoice
{
	Gui, MainGUI:ListView,weatherchoice
}
GuiControl,Text,searchnofound,Injecting Weather Effect
if LV_GetNext(,"Checked")>0
{
	filter=`r`n%A_Tab%%A_Tab%%A_Tab%"prefab"%A_Tab%%A_Tab%"misc"`r`n
	htarget=`r`n%A_Tab%%A_Tab%%A_Tab%"prefab"%A_Tab%%A_Tab%"weather"`r`n
	Loop
	{
		StringGetPos, ipos, masterfilecontent,%htarget%,L%A_Index%
		if ipos<0
			break
		StringLen,filelength,masterfilecontent
		rightpos:=filelength-ipos
		StringGetPos, ipos1, masterfilecontent,%sfinder%,,%ipos%
		StringGetPos, ipos2, masterfilecontent,%sfinder%,R1,%rightpos%
		startpos:=ipos2+8
		ipos3:=ipos1-ipos2
		StringMid,misccontent,masterfilecontent,%startpos%,%ipos3%
		if InStr(misccontent,extrafilter)>0
		{
			filecontent=%misccontent%
			tmpbar:=iddetector(filecontent) ;filecontent := extracted content from items_game.txt
			defid=%tmpbar%
			LV_GetText(tmpstring,LV_GetNext(,"Checked"),3)
			tmpfind=misc
			filecontent:=miscdetector("prefab",tmpfind,tmpstring) ;filecontent:=miscdetector("prefab",tmpfind,tmpstring,filestring) ; detects the contents of a miscellaneous item... In expression "prefab" means item_slot
			if InStr(filecontent,filter)>0
			{
				StringReplace,filecontent,filecontent,%tmpstring%"`r`n%A_Tab%%A_Tab%{,%defid%"`r`n%A_Tab%%A_Tab%{
				StringReplace,filecontent,filecontent,%replacefrom%,%replaceto%
				StringReplace,masterfilecontent,masterfilecontent,%misccontent%,%filecontent%,1
				; measures the number of items injected per second
				Gui,MainGUI:Show,NoActivate,% floor(1000/(A_TickCount-IPS)) " Items per Second"
				IPS:=A_TickCount
				;
				Break
			}
		}
		Else
		{
			VarSetCapacity(misccontent,0)
		}
		if ErrorLevel=1 ; hunt this errorlevel
		{
			Break
		}
	}
}
if A_DefaultListView<>multikillchoice
{
	Gui, MainGUI:ListView,multikillchoice
}
GuiControl,Text,searchnofound,Injecting MultiKill-Banner
if LV_GetNext(,"Checked")>0
{
			LV_GetText(tmpstring,LV_GetNext(,"Checked"),3)
			tmpfind=misc
			filecontent:=miscdetector("prefab",tmpfind,tmpstring) ;filecontent:=miscdetector("prefab",tmpfind,tmpstring,filestring) ; detects the contents of a miscellaneous item... In expression "prefab" means item_slot
			StringReplace,misccontent,filecontent,`r`n%A_Tab%%A_Tab%%A_Tab%"item_slot"%A_Tab%%A_Tab%"multikill_banner"`r`n,`r`n%A_Tab%%A_Tab%%A_Tab%"baseitem"%A_Tab%%A_Tab%"1"`r`n%A_Tab%%A_Tab%%A_Tab%"item_slot"%A_Tab%%A_Tab%"multikill_banner"`r`n
			StringReplace,masterfilecontent,masterfilecontent,%filecontent%,%misccontent%,1
			; measures the number of items injected per second
			Gui,MainGUI:Show,NoActivate,% floor(1000/(A_TickCount-IPS)) " Items per Second"
			IPS:=A_TickCount
			;
}
if A_DefaultListView<>emblemchoice
{
	Gui, MainGUI:ListView,emblemchoice
}
GuiControl,Text,searchnofound,Injecting emblem
if LV_GetNext(,"Checked")>0
{
			LV_GetText(tmpstring,LV_GetNext(,"Checked"),3)
			tmpfind=emblem
			filecontent:=miscdetector("prefab",tmpfind,tmpstring) ;filecontent:=miscdetector("prefab",tmpfind,tmpstring,filestring) ; detects the contents of a miscellaneous item... In expression "prefab" means item_slot
			StringReplace,misccontent,filecontent,`r`n%A_Tab%%A_Tab%%A_Tab%"prefab"%A_Tab%%A_Tab%"emblem",`r`n%A_Tab%%A_Tab%%A_Tab%"baseitem"%A_Tab%%A_Tab%"1"`r`n%A_Tab%%A_Tab%%A_Tab%"prefab"%A_Tab%%A_Tab%"emblem"
			StringReplace,masterfilecontent,masterfilecontent,%filecontent%,%misccontent%,1
			; measures the number of items injected per second
			Gui,MainGUI:Show,NoActivate,% floor(1000/(A_TickCount-IPS)) " Items per Second"
			IPS:=A_TickCount
			;
}
if peton=1
{
	GuiControl,Text,searchnofound,Activating Almond the Frondillo`, current status: Searching for default_item pet for heroes
	filter=`r`n%A_Tab%%A_Tab%%A_Tab%"item_slot"%A_Tab%%A_Tab%"summon"`r`n
	filter1=npc_dota_hero_
	htarget=`r`n%A_Tab%%A_Tab%%A_Tab%"prefab"%A_Tab%%A_Tab%"default_item"`r`n
	Loop
	{
		StringGetPos, ipos, masterfilecontent,%htarget%,L%A_Index%
		if ipos<0
			break
		StringLen,filelength,masterfilecontent
		rightpos:=filelength-ipos
		StringGetPos, ipos1, masterfilecontent,%sfinder%,,%ipos%
		StringGetPos, ipos2, masterfilecontent,%sfinder%,R1,%rightpos%
		startpos:=ipos2+8
		ipos3:=ipos1-ipos2
		StringMid,misccontent,masterfilecontent,%startpos%,%ipos3%
		if InStr(misccontent,filter)>0
		{
			filecontent=%misccontent%
			itemname:=miscusersdetector(filecontent) ; detects the user of the pet from multiple instances
			tmp:= StrReplace(itemname,filter1, filter1, existencecount)
			if existencecount>1
			{
				GuiControl,Text,searchnofound,Activating Almond the Frondillo`, current status: Searching for Almond the Frondillo item
				tmpbar:=iddetector(filecontent) ;filecontent := extracted content from items_game.txt
				defid=%tmpbar%
				1htarget=`r`n%A_Tab%%A_Tab%%A_Tab%"prefab"%A_Tab%%A_Tab%"wearable"`r`n
				Loop
				{
					StringGetPos, ipos, masterfilecontent,%filter%,L%A_Index%
					if ipos<0
						break
					StringLen,filelength,masterfilecontent
					rightpos:=filelength-ipos
					StringGetPos, ipos1, masterfilecontent,%sfinder%,,%ipos%
					StringGetPos, ipos2, masterfilecontent,%sfinder%,R1,%rightpos%
					startpos:=ipos2+8
					ipos3:=ipos1-ipos2
					StringMid,filecontent,masterfilecontent,%startpos%,%ipos3%
					if InStr(filecontent,1htarget)>0
					{
						itemname:=miscusersdetector(filecontent) ; detects the user of the pet from multiple instances
						tmp:= StrReplace(itemname,filter1, filter1, existencecount)
						if existencecount>1
						{
							GuiControl,Text,searchnofound,Activating Almond the Frondillo`, current status: Finalyzing
							tmpbar:=iddetector(filecontent) ;filecontent := extracted content from items_game.txt
							tmp=%tmpbar%
							StringReplace,filecontent,filecontent,%tmp%"`r`n%A_Tab%%A_Tab%{,%defid%"`r`n%A_Tab%%A_Tab%{
							StringReplace,filecontent,filecontent,%1htarget%,%htarget%,1
							if petstyle>0
							{
								stylechecker=%petstyle%
								if stylechecker>0
								{
									filecontent:=stylechanger(stylechecker,filecontent) ;stylechanger will change the style of all particle effects and even the model
								}
								else
								{
									StringReplace,filecontent,filecontent,`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%%A_Tab%"style"%A_Tab%%A_Tab%"0",,1
								}
							}
							StringReplace,masterfilecontent,masterfilecontent,%misccontent%,%filecontent%,1
							; measures the number of items injected per second
							Gui,MainGUI:Show,NoActivate,% floor(1000/(A_TickCount-IPS)) " Items per Second"
							IPS:=A_TickCount
							;
							Break
						}
						else
						{
							VarSetCapacity(filecontent,0)
						}
					}
					else
					{
						VarSetCapacity(filecontent,0)
					}
					if ErrorLevel=1 ; hunt this errorlevel
					{
						Break
					}
				}
				Break
			}
			else
			{
				VarSetCapacity(misccontent,0)
			}
		}
		Else
		{
			VarSetCapacity(misccontent,0)
		}
		if ErrorLevel=1 ; hunt this errorlevel
		{
			Break
		}
	}
}
return

/*
required variables
contentport - - - for the portraits
filecontent - - - for the visualsdetector,ect
numcheck
stylechecker
*/
extractmodel:
npchero:=GlobalArray["npc_heroes.txt"]
npcunit:=GlobalArray["npc_units.txt"]
itemname:=visualsdetector(filecontent) ; detects the Visual Section of the content
StringLen,modeltmplength,itemname
modelcount:=rptpermit:=0
StrReplace(itemname,".vmdl""",".vmdl""",modelcount)

loop,%modelcount%
{
	StringGetPos, ipos1, itemname,.vmdl,L%A_Index%
	StringGetPos, ipos2, itemname,",,%ipos1% ;"
	rightpos:=modeltmplength-ipos1
	StringGetPos, ipos3, itemname,`r`n,R1,%rightpos%
	StringMid,modifierconfirm,itemname,% ipos3+2,% ipos2-ipos3-1
	
	if InStr(modifierconfirm,"asset")>0
	{
		continue
	}
	StringGetPos, ipos3, itemname,",R1,%rightpos% ;"
	StringMid,extractfile,itemname,% ipos3+2,% ipos2-ipos3-1 ; the location and name of the file inside vpk
	
	portfind=`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%"game"`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%{
	if InStr(contentport,portfind)>0
	{
		porttmp=%extractfile%
		gosub,execportrait
	}
	extractfile=%extractfile%_c
	StringReplace,extractfile,extractfile,/,\,1
	StringGetPos, newpos, extractfile,\,R1
	StringTrimLeft,extractname,extractfile,% newpos+1
	StringGetPos, pos, itemname,`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%},,%ipos1%
	StringGetPos, pos1, itemname,`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%{,R1,%rightpos%
	StringMid,modifierstring,itemname,% pos1+1,% pos-pos1
	StringGetPos, newpos, modifierstring,"asset"%A_Tab%%A_Tab%"
	StringGetPos, newpos1, modifierstring,",L3,newpos
	StringGetPos, newpos, modifierstring,",L2,newpos1 ;"
	StringMid,check,modifierstring,% newpos1+2, % newpos-newpos1-1 ; the "check" is the npc_dota that will be searched either npc_heroes.txt or npc_units.txt
	
	IfInString,check,npc_dota_hero
	{
		readdir=%npchero%
	}
	else IfInString,check,dota_
	{
		readdir=%npcunit%
	}
	else
	{
		IfInString,check,.vmdl
		{
			subjectcontent=%check%_c
			StringLen,modelvarlength,subjectcontent
			StringReplace,subjectcontent,subjectcontent,/,\,1
			StringGetPos, newpos, subjectcontent,\,R1
			StringTrimLeft,defaultname,subjectcontent,% newpos+1
			StringTrimRight,defaultloc,subjectcontent,% modelvarlength-newpos
			if (defaultloc<>"") and (extractfile<>"")
			{
				tmp="item_rarity"%A_Tab%%A_Tab%"arcana"
				if (InStr(filecontent,tmp)>0) and (FileExist(A_ScriptDir "\Plugins\VPKCreator\pak01_dir\" defaultloc "\" defaultname))
				{
					FileDelete,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\%defaultloc%\%defaultname%
				}
				IfNotExist,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\%defaultloc%\%defaultname%
				{
					repmocount+=1
					IniWrite,%defaultloc%,%A_ScriptDir%\Plugins\ReportLog.aldrin_report,Present Models,ModelLocationPath_%repmocount%
					IniWrite,%defaultname%,%A_ScriptDir%\Plugins\ReportLog.aldrin_report,Present Models,ModelDefaultName_%repmocount%
					IniWrite,ModelRealName_%repmocount%,%A_ScriptDir%\Plugins\ReportLog.aldrin_report,Present Models,%extractname%
					
					gosub,extractfileruncmd ; extract this files via cmd
				}
			}
		}
		continue
	}
	save=`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%%A_Tab%"style"%A_Tab%%A_Tab%"%stylechecker%"
	save1=`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%%A_Tab%"style"%A_Tab%%A_Tab%
	if ((numcheck>0) and (InStr(modifierstring,save)>0)) or (numcheck=0) or ((numcheck>0) and (InStr(modifierstring,save1)<1))
	{
		StringGetPos, newpos, readdir,`r`n%A_Tab%"%check% ;"
		if (newpos<0)
		{
			herouser:=itemuserdetector(filecontent)
			if (herouser="npc_dota_hero_tiny")
			{
				subjectcontent:=npcherodetector(herouser,dota2dir "\game\dota\scripts\npc\npc_heroes.txt")
				
				growvalue:=substr(check,0)
				if (growvalue<=0) ; if zero or below this should have no value
					growvalue=
				subjectcontent:=strreplace(searchstringdetector(subjectcontent,"""Model" growvalue """") "_c","/","\")
				
				defaultname:=substr(subjectcontent,instr(subjectcontent,"\",,0)+1) ; name of the default file
				defaultloc:=substr(subjectcontent,1,-strlen(defaultname)-1) ; directory of the default file
			}
			else
			{
				msgbox cannot find %check%! Report this to the Developer Immediately!
				continue
			}
		}
		else
		{
			StringGetPos, newpos1, readdir,`r`n%A_Tab%},,%newpos%
			StringMid,subjectcontent,readdir,% newpos+1, % newpos1-newpos-1
			
			StringGetPos, newpos, subjectcontent,`r`n%A_Tab%%A_Tab%"Model"
			StringGetPos, newpos1, subjectcontent,",L3,%newpos% ;"
			StringGetPos, newpos, subjectcontent,",L2,%newpos1% ;"
			StringMid,subjectcontent,subjectcontent,% newpos1+2, % newpos-newpos1-1
			subjectcontent=%subjectcontent%_c
			StringLen,modelvarlength,subjectcontent
			StringReplace,subjectcontent,subjectcontent,/,\,1
			
			StringGetPos, newpos, subjectcontent,\,R1
			StringTrimLeft,defaultname,subjectcontent,% newpos+1
			StringTrimRight,defaultloc,subjectcontent,% modelvarlength-newpos
		}
		
		if (defaultloc<>"") and (extractfile<>"")
		{
			tmp="item_rarity"%A_Tab%%A_Tab%"arcana"
			if (InStr(filecontent,tmp)>0) and (FileExist(A_ScriptDir "\Plugins\VPKCreator\pak01_dir\" defaultloc "\" defaultname))
			{
				FileDelete,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\%defaultloc%\%defaultname%
			}
			IfNotExist,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\%defaultloc%\%defaultname%
			{
				repmocount+=1
				IniWrite,%defaultloc%,%A_ScriptDir%\Plugins\ReportLog.aldrin_report,Present Models,ModelLocationPath_%repmocount%
				IniWrite,%defaultname%,%A_ScriptDir%\Plugins\ReportLog.aldrin_report,Present Models,ModelDefaultName_%repmocount%
				IniWrite,ModelRealName_%repmocount%,%A_ScriptDir%\Plugins\ReportLog.aldrin_report,Present Models,%extractname%
				
				gosub,extractfileruncmd ; extract this files via cmd
			}
		}
	}
}
modelcount=0
tmp=`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%%A_Tab%"asset"
tmp:=StrReplace(itemname,tmp,tmp,modelcount)
loop,%modelcount%
{
	StringGetPos, ipos1, itemname,`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%%A_Tab%"asset",L%A_Index%
	StringGetPos, ipos2, itemname,`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%},,%ipos1%
	rightpos:=modeltmplength-ipos1
	StringGetPos, ipos3, itemname,`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%{,R1,%rightpos%
	StringMid,modifierstring,itemname,% ipos3+2,% ipos2-ipos3-1
	StringGetPos, newpos, modifierstring,`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%%A_Tab%"asset"
	StringGetPos, newpos1, modifierstring,",L3,%newpos%
	StringGetPos, newpos, modifierstring,",L2,%newpos1%
	StringMid,check,modifierstring,% newpos1+2, % newpos-newpos1-1
	if (SubStr(check,-4,5)=".vpcf") and (((numcheck>0) and (InStr(modifierstring,save)>0)) or (numcheck=0) or ((numcheck>0) and (InStr(modifierstring,save1)<1)))
	{
		check=%check%_c
		StringReplace,check,check,/,\,1
		StringGetPos, newpos, check,\,R1
		StringTrimLeft,defaultname,check,% newpos+1
		StringLen,modelvarlength,check
		StringTrimRight,defaultloc,check,% modelvarlength-newpos
		StringGetPos, newpos, modifierstring,`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%%A_Tab%"modifier"
		StringGetPos, newpos1, modifierstring,",L3,%newpos%
		StringGetPos, newpos, modifierstring,",L2,%newpos1%
		StringMid,extractfile,modifierstring,% newpos1+2, % newpos-newpos1-1
		extractfile.="_c"
		StringReplace,extractfile,extractfile,/,\,1
		StringGetPos, newpos, extractfile,\,R1
		StringTrimLeft,extractname,extractfile,% newpos+1
		tmp="type"%A_Tab%%A_Tab%"particle_combined"
		if InStr(modifierstring,tmp)>0
		{
			IniRead,tmp1,%A_ScriptDir%\Plugins\ReportLog.aldrin_report,Present Particle Effects,%defaultname%
			if tmp1<>ERROR
			{
				StringReplace,tmp1,tmp1,ParticleRealName_,,1
				IniRead,defaultloc,%A_ScriptDir%\Plugins\ReportLog.aldrin_report,Present Particle Effects,ParticleLocationPath_%tmp1%
				IniRead,defaultname,%A_ScriptDir%\Plugins\ReportLog.aldrin_report,Present Particle Effects,ParticleDefaultName_%tmp1%
				rptlimit=%rptlimit%%herousercheck%,
				rptpermit=1
			}
			else
			{
				VarSetCapacity(defaultloc,0),VarSetCapacity(extractfile,0)
			}
		}
		if (defaultloc<>"") and (extractfile<>"")
		{
			tmp="item_rarity"%A_Tab%%A_Tab%"arcana"
			if ((InStr(filecontent,tmp)>0) and (FileExist(A_ScriptDir "\Plugins\VPKCreator\pak01_dir\" defaultloc "\" defaultname)) and (InStr(rptlimit,herousercheck)>0)) or (rptpermit=1)
			{
				FileDelete,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\%defaultloc%\%defaultname%
				if rptpermit=1
				{
					rptpermit=0
				}
			}
			IfNotExist,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\%defaultloc%\%defaultname%
			{
				repparcount+=1
				IniWrite,%defaultloc%,%A_ScriptDir%\Plugins\ReportLog.aldrin_report,Present Particle Effects,ParticleLocationPath_%repparcount%
				IniWrite,%defaultname%,%A_ScriptDir%\Plugins\ReportLog.aldrin_report,Present Particle Effects,ParticleDefaultName_%repparcount%
				IniWrite,ParticleRealName_%repparcount%,%A_ScriptDir%\Plugins\ReportLog.aldrin_report,Present Particle Effects,%extractname%
				
				gosub,extractfileruncmd ; extract this files via cmd
			}
		}
	}
}
return

extractfileruncmd:
DetectHiddenWindows,On
if ((SubStr(extractname,-1)!="_c") or (SubStr(defaultname,-1)!="_c"))
	msgbox fatal! a model file has no compiled parameter on it:`nextractfile=%extractfile%`nextractname=%extractname%`ndefaultloc=%defaultloc%`ndefaultname=%defaultname%`n`nYOU ARE OBLIGED TO REPORT THIS TO AJO Manalansan Immediately!
loop ; retry running the cmd until it succeed
{
	if !lowprocessor or (cmdmaxinstances!=1) ; if not lowprocessor or cmdmaxinstances not equal to 1(cmdmaxinstances=1 is synonymous to low processor mode since only one cmd can be actived at a time)
	{
		if !FileExist(A_ScriptDir "\Plugins\VPKCreator\pak01_dir\" defaultloc "\")
			FileCreateDir,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\%defaultloc%
		run,"%A_ComSpec%" /c ""%variablehllib%" -p "%dota2dir%\game\dota\pak01_dir.vpk" -d "%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\%defaultloc%" -e "root\%extractfile%"&move /y "%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\%defaultloc%\%extractname%" "%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\%defaultloc%\%defaultname%"",,Hide UseErrorLevel,tmpr
		
		if (cmdmaxinstances>1)
		{
			cmdcountoverflow:=InStr(extractpid,",",,,cmdmaxinstances-1) ; detects when number of registered cmd pid's in the pid list is above the maximum number of simutaneous running cmd's
			if cmdcountoverflow
			{
				;DetectHiddenWindows,On
				WinWait,ahk_pid %tmpr% ahk_exe cmd.exe ahk_class ConsoleWindowClass
			}
		}
	}
	else runwait,"%A_ComSpec%" /c "md "%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\%defaultloc%"&"%variablehllib%" -p "%dota2dir%\game\dota\pak01_dir.vpk" -d "%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\%defaultloc%" -e "root\%extractfile%"&rename "%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\%defaultloc%\%extractname%" "%defaultname%"",,Hide UseErrorLevel,tmpr
	if ErrorLevel!=ERROR
		break ;; terminate the loop
	;; if the there was an error, rerun
	WinWait,ahk_pid %tmpr% ahk_exe cmd.exe ahk_class ConsoleWindowClass,,0.25 ; this causes a 250 milliseconds delay on the operation on each failure, I do not advise this t be on but it gives help
}

;after successfull run, save pid to extract process list
if !lowprocessor
{
	;if !IsObject(extractpid)
	;	extractpid:=[]
	;extractpid.Push(tmpr)
	if extractpid=
		extractpid:=tmpr
	else extractpid.="," tmpr
	
	if cmdmaxinstances is not Number
		GuiControlGet,cmdmaxinstances,,cmdmaxinstances
	
	if cmdcountoverflow and (cmdmaxinstances!=0) ; number of commas is cmdmax-1 ; check number of running threads exceeds the cmdmaxinstances ; having "0" value means unlimited number of threads
	{
		loop,parse,extractpid,`,
		{
			;WinWait,ahk_pid %A_LoopField% ahk_exe cmd.exe ahk_class ConsoleWindowClass,,0
			if !WinExist("ahk_pid " A_LoopField " ahk_exe cmd.exe ahk_class ConsoleWindowClass") ;wait indefinitely until it closes
				extractpid:=RegExReplace(extractpid,"(\b" A_LoopField "\b,)|(,\b" A_LoopField "\b$)|(^\b" A_LoopField "\b$)|(\b" A_LoopField "\b)") ; regexreplaces "pid," or "pid" if it is found at the end of the string
		}
		if InStr(extractpid,",",,,cmdmaxinstances-1) ; rechecing cmdoverflow ; number of commas is cmdmax-1 ; check number of running threads still exceeds the cmdmaxinstances
		{
			if instr(extractpid,",",1)
				tmpr:=substr(extractpid,1,instr(extractpid,",",1)-1) ; get the first pid at the extractpid list
			else tmpr:=extractpid
			WinWaitClose,% "ahk_pid " tmpr " ahk_exe cmd.exe ahk_class ConsoleWindowClass" ;wait indefinitely until it closes
			;remove the first pid at extractpid list
			extractpid:=RegExReplace(extractpid,"(\b" tmpr "\b,)|(,\b" tmpr "\b$)|(^\b" tmpr "\b$)|(\b" tmpr "\b)") ; regexreplaces "pid," or "pid" if it is found at the end of the string
		}
		;DetectHiddenWindows,Off
	}
}
DetectHiddenWindows,Off
return

gipatcher:
fileread,vpktmp,%giloc%
StringLen,filelength,vpktmp
clone=%vpktmp%
finder=Aldrin_Mods
if InStr(vpktmp,finder)
{
	VarSetCapacity(check1,0),VarSetCapacity(check2,0),VarSetCapacity(check3,0)
	loop
	{
		StringGetPos, ipos, vpktmp,%finder%,L%A_Index%
		if ipos<0
			Break
		
		rightpos:=filelength-ipos
		StringGetPos, ipos1, vpktmp,`r`n,L2,%ipos%
		StringGetPos, ipos2, vpktmp,`r`n,R1,%rightpos%
		startpos:=ipos2
		ipos3:=ipos1-ipos2
		StringMid,tmp,vpktmp,%startpos%,%ipos3%
		param=Game_Language,Game_LowViolence,Mod
		loop,parse,param,`,
		{
			tmp1=%A_Tab%%A_Tab%%A_Tab%%A_LoopField%
			if InStr(tmp,tmp1)
			{
				check%A_Index%=1
			}
		}
		if ErrorLevel=1 ; hunt this errorlevel
		{
			Break
		}
	}
	param=`r`n%A_Tab%%A_Tab%%A_Tab%Game_Language%A_Tab%%A_Tab%dota_*LANGUAGE*`r`n|`r`n%A_Tab%%A_Tab%%A_Tab%Game_LowViolence%A_Tab%dota_lv`r`n|`r`n%A_Tab%%A_Tab%%A_Tab%Mod%A_Tab%%A_Tab%%A_Tab%%A_Tab%%A_Tab%dota`r`n
	param1=`r`n%A_Tab%%A_Tab%%A_Tab%Game%A_Tab%%A_Tab%%A_Tab%%A_Tab%%finder%`r`n%A_Tab%%A_Tab%%A_Tab%Game_Language%A_Tab%%A_Tab%dota_*LANGUAGE*`r`n|`r`n%A_Tab%%A_Tab%%A_Tab%Game%A_Tab%%A_Tab%%A_Tab%%A_Tab%%finder%`r`n%A_Tab%%A_Tab%%A_Tab%Game_LowViolence%A_Tab%dota_lv`r`n|`r`n%A_Tab%%A_Tab%%A_Tab%Mod%A_Tab%%A_Tab%%A_Tab%%A_Tab%%A_Tab%%finder%`r`n%A_Tab%%A_Tab%%A_Tab%Mod%A_Tab%%A_Tab%%A_Tab%%A_Tab%%A_Tab%dota`r`n
	loop,parse,param,|
	{
		saver=%A_LoopField%
		intsaver=%A_Index%
		loop,parse,param1,|
		{
			if intsaver=%A_Index%
			{
				if check%A_Index%<>1
				{
					StringReplace,vpktmp,vpktmp,%saver%,%A_LoopField%,1
					Break
				}
			}
		}
	}
}
else
{
	param=`r`n%A_Tab%%A_Tab%%A_Tab%Game_Language%A_Tab%%A_Tab%dota_*LANGUAGE*`r`n|`r`n%A_Tab%%A_Tab%%A_Tab%Game_LowViolence%A_Tab%dota_lv`r`n|`r`n%A_Tab%%A_Tab%%A_Tab%Mod%A_Tab%%A_Tab%%A_Tab%%A_Tab%%A_Tab%dota`r`n
	param1=`r`n%A_Tab%%A_Tab%%A_Tab%Game%A_Tab%%A_Tab%%A_Tab%%A_Tab%%finder%`r`n%A_Tab%%A_Tab%%A_Tab%Game_Language%A_Tab%%A_Tab%dota_*LANGUAGE*`r`n|`r`n%A_Tab%%A_Tab%%A_Tab%Game%A_Tab%%A_Tab%%A_Tab%%A_Tab%%finder%`r`n%A_Tab%%A_Tab%%A_Tab%Game_LowViolence%A_Tab%dota_lv`r`n|`r`n%A_Tab%%A_Tab%%A_Tab%Mod%A_Tab%%A_Tab%%A_Tab%%A_Tab%%A_Tab%%finder%`r`n%A_Tab%%A_Tab%%A_Tab%Mod%A_Tab%%A_Tab%%A_Tab%%A_Tab%%A_Tab%dota`r`n
	loop,parse,param,|
	{
		saver=%A_LoopField%
		intsaver=%A_Index%
		index=1
		loop
		{
			StringGetPos, ipos, vpktmp,%saver%
			if ipos<1
			{
				Break
			}
			StringLen,filelength,vpktmp
			rightpos:=filelength-ipos
			if intsaver=3
			{
				tmp2=%A_Tab%%A_Tab%%A_Tab%Mod%A_Tab%
				tmp1=%A_Tab%%A_Tab%%A_Tab%Mod%A_Tab%%A_Tab%%A_Tab%%A_Tab%%finder%
			}
			else
			{
				tmp2=%A_Tab%%A_Tab%%A_Tab%Game%A_Tab%
				tmp1=%A_Tab%%A_Tab%%A_Tab%Game%A_Tab%%A_Tab%%A_Tab%%A_Tab%%finder%
			}
			StringGetPos, ipos1, vpktmp,%tmp2%,R%index%,%rightpos%
			if ipos1<1
			{
				Break
			}
			rightpos:=filelength-ipos1
			StringGetPos, ipos2, vpktmp,`r`n,R1,%rightpos%
			startpos:=ipos2+1
			ipos3:=ipos-ipos2
			StringMid,tmp,vpktmp,%startpos%,%ipos3%
			if (InStr(tmp,tmp1)<1) and (InStr(tmp,tmp2)>0)
			{
				StringReplace,vpktmp,vpktmp,%tmp%,,1
			}
			else
			{
				index:=index+1
			}
			if ErrorLevel=1 ; hunt this errorlevel
			{
				Break
			}
		}
		loop,parse,param1,|
		{
			if intsaver=%A_Index%
			{
				StringReplace,vpktmp,vpktmp,%saver%,%A_LoopField%,1
				Break
			}
		}
	}
}
if clone<>%vpktmp%
{
	FileDelete,%giloc%
	FileAppend,%vpktmp%,%giloc%
}
return

usemiscon:
Gui, MainGUI:Submit, NoHide
GoSub,default_settings
FileSetAttrib,-R,%A_ScriptDir%\Settings.aldrin_dota2mod
if usemiscon=1
{
	MsgBox, 36, Reload Required!, Checking Miscellaneous requires this tool to be reloaded in order to preload all miscellaneous resources`, any unsaved data/'s will be lost. Do you want to continue? (Press YES or NO)
	IfMsgBox Yes
	{
		IniWrite,%usemiscon%,%A_ScriptDir%\Settings.aldrin_dota2mod,Edits,usemisc
		gosub,savetab
		Reload
		Sleep 1000
		msgbox,16,Error,Cannont Reload`,Please reload the Script Manually!
	}
	else
	{
		guicontrol,,usemiscon,0
	}
}
else
{
	IniWrite,%usemiscon%,%A_ScriptDir%\Settings.aldrin_dota2mod,Edits,usemisc
}
FileSetAttrib,+R,%A_ScriptDir%\Settings.aldrin_dota2mod
return

miscreload:
Gui, MainGUI:+Disabled
filestring:=GlobalArray["items_game.txt"]
filelength:=StrLen(GlobalArray["items_game.txt"])
sfinder=`r`n%A_Tab%%A_Tab%}`r`n%A_Tab%%A_Tab%" ;"
GuiControl,+cBlue,searchnofound
lvparam=terrainchoice,hudchoice,courierchoice,wardchoice,loadingscreenchoice,announcerview,tauntview,weatherchoice,musicchoice,cursorchoice,multikillchoice,emblemchoice,radcreepchoice,direcreepchoice,radtowerchoice,diretowerchoice,versuscreenchoice,emoticonchoice
loop,parse,lvparam,`,
{
	GuiControl, MainGUI:-Redraw, %A_LoopField%
}
GuiControl,Text,searchnofound,Detecting changes on the latest "items_game.txt" file
;firstmessage=`n;;;;This Section is the indicator if "items_game.txt" is changed`,PLEASE DONT EDIT ANYTHING ON THIS SECTION!!!;;;;`n`n
;lastmessage=`n;;;;End of AJOM Indicator;;;;`n`n
ifexist,%A_ScriptDir%\Library\Reference.aldrin_dota2mod
{
	if fastmisc=1
	{
		FileRead,filestring,%A_ScriptDir%\Library\Reference.aldrin_dota2mod
		if (substr(filestring,1,strlen(GlobalArray["items_game.txt"]))=GlobalArray["items_game.txt"])
		{
			filestring:=StrReplace(filestring,GlobalArray["items_game.txt"])
			; IniRead,tempo,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,Announcers,AnnouncersCount,%A_Space%
			;GuiControl,Text,searchnofound,Preloading Reference File
			
			;VarRead(,StrReplace(tempo,GlobalArray["items_game.txt"])) ; remember the contents of the variable and store to "static Var" that is inspected by varread
			;if A_DefaultListView<>announcerview
			;{
			;	Gui, MainGUI:ListView,announcerview
			;}
			;tempo:=VarRead("AnnouncersCount")
			;loop %tempo%
			;{
			;	; IniRead,hitemname,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,Announcers,AnnouncerName%A_Index%
			;	hitemname:=VarRead("AnnouncerName" A_Index)
			;	GuiControl,Text,searchnofound,Fast Preloading %hitemname%
			;	; IniRead,hitemslot,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,Announcers,AnnouncerSlot%A_Index%
			;	; IniRead,hitemrarity,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,Announcers,AnnouncerRarity%A_Index%
			;	; IniRead,hitemid,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,Announcers,AnnouncerID%A_Index%
			;	hitemslot:=VarRead("AnnouncerSlot" A_Index)
			;	hitemrarity:=VarRead("AnnouncerRarity" A_Index)
			;	hitemid:=VarRead("AnnouncerID" A_Index)
			;	LV_Add(,hitemname,hitemslot,hitemrarity,hitemid)
			;}
			;LV_ModifyCol(2,"Sort")
			;
			;; IniRead,tempo,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,Taunts,TauntsCount
			;if A_DefaultListView<>tauntview
			;{
			;	Gui, MainGUI:ListView,tauntview
			;}
			;tempo:=VarRead("TauntsCount")
			;loop %tempo%
			;{
			;	; IniRead,hitemname,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,Taunts,TauntName%A_Index%
			;	hitemname:=VarRead("TauntName" A_Index)
			;	GuiControl,Text,searchnofound,Fast Preloading %hitemname%
			;	; IniRead,hitemrarity,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,Taunts,TauntRarity%A_Index%
			;	; IniRead,hitemid,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,Taunts,TauntID%A_Index%
			;	; IniRead,hherouser,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,Taunts,TauntUser%A_Index%
			;	hitemrarity:=VarRead("TauntRarity" A_Index)
			;	hitemid:=VarRead("TauntID" A_Index)
			;	hherouser:=VarRead("TauntUser" A_Index)
			;	LV_Add(,hitemname,hitemrarity,hitemid,hherouser)
			;}
			;LV_ModifyCol(4,"Sort")
			;
			;param:=[["loadingscreenchoice","loading_screen"],["musicchoice","music"],["cursorchoice","cursor_pack"],["emblemchoice","emblem"],["weatherchoice","weather"],["multikillchoice","multikill_banner"],["versuscreenchoice","versus_screen"],["emoticonchoice","emoticon_tool"]]
			;for intsaver, in param
			;{
			;	subject:=param[intsaver,2]
			;	if A_DefaultListView<>% param[intsaver,1]
			;	{
			;		Gui, MainGUI:ListView,% param[intsaver,1]
			;	}
			;	; IniRead,tempo,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,%subject%,%subject%Count
			;	tempo:=VarRead(subject "Count")
			;	loop %tempo%
			;	{
			;		; IniRead,hitemname,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,%subject%,%subject%Name%A_Index%
			;		hitemname:=VarRead(subject "Name" A_Index)
			;		GuiControl,Text,searchnofound,Fast Preloading %subject%: %hitemname%
			;		; IniRead,hitemrarity,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,%subject%,%subject%Rarity%A_Index%
			;		; IniRead,hitemid,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,%subject%,%subject%ID%A_Index%
			;		hitemrarity:=VarRead(subject "Rarity" A_Index)
			;		hitemid:=VarRead(subject "ID" A_Index)
			;		LV_Add(,hitemname,hitemrarity,hitemid)
			;	}
			;}
			;
			;param:=[["courierchoice","courier"],["wardchoice","ward"],["hudchoice","hud_skin"],["radcreepchoice","radiantcreeps"],["direcreepchoice","direcreeps"],["radtowerchoice","radianttowers"],["diretowerchoice","diretowers"],["terrainchoice","terrain"]]
			;for intsaver, in param
			;{
			;	subject:=param[intsaver,2]
			;	if A_DefaultListView<>% param[intsaver,1]
			;	{
			;		Gui, MainGUI:ListView,% param[intsaver,1]
			;	}
			;	; IniRead,tempo,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,%subject%,%subject%Count
			;	tempo:=VarRead(subject "Count")
			;	loop %tempo%
			;	{
			;		; IniRead,hitemname,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,%subject%,%subject%Name%A_Index%
			;		hitemname:=VarRead(subject "Name" A_Index)
			;		GuiControl,Text,searchnofound,Fast Preloading %subject%: %hitemname%
			;		; IniRead,hitemrarity,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,%subject%,%subject%Rarity%A_Index%
			;		; IniRead,hitemid,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,%subject%,%subject%ID%A_Index%
			;		; IniRead,stylescount,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,%subject%,%subject%StyleCount%A_Index%
			;		; IniRead,tempo,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,%subject%,%subject%ActivedStyle%A_Index%
			;		hitemrarity:=VarRead(subject "Rarity" A_Index)
			;		hitemid:=VarRead(subject "ID" A_Index)
			;		stylescount:=VarRead(subject "StyleCount" A_Index)
			;		tempo:=VarRead(subject "ActivedStyle" A_Index)
			;		LV_Add(,hitemname,hitemrarity,hitemid,stylescount,tempo)
			;	}
			;}
			
			
			loop,parse,lvparam,`,
			{
				if A_DefaultListView<>%A_LoopField%
				{
					Gui, MainGUI:ListView,%A_LoopField%
				}
				GuiControl,Text,searchnofound,Preloading Contents of ListView: %A_LoopField%
				pos:=InStr(filestring,"`r`n~~~~~~~~~~" A_LoopField "~~~~~~~~~~`r`n")+strlen("`r`n~~~~~~~~~~" A_LoopField "~~~~~~~~~~`r`n")
				pos1:=InStr(filestring,"`r`n~~~~~~~~~~" A_LoopField "~~~~~~~~~~`r`n",,,2)
				FileData:=SubStr(filestring,pos,pos1-pos)
				ListViewLoad(FileData," ")
				;GoSub,lvautosize
				gosub,detectsorting
			}
			GuiControl,+cDefault,searchnofound
			GuiControl,MainGUI:Text,searchnofound,%defaultshoutout%
			GuiControl,MainGUI:Show,searchnofound
			Gui, MainGUI:-Disabled
			return
		}
	}
	
	FileSetAttrib,-R,%A_ScriptDir%\Library\Reference.aldrin_dota2mod
	FileDelete,%A_ScriptDir%\Library\Reference.aldrin_dota2mod
	; FileAppend,%firstmessage%%compare1%%lastmessage%,%A_ScriptDir%\Library\Reference.aldrin_dota2mod
}

filestringcopy=%filestring%

;speedtesting
;speedmessage=
;loop 5
;{
;loopsbeforetrim:=A_Index ; the fastest tests I conducted was trimming the text after 2 loops
;

loopsbeforetrim:=3 ; the fastest tests I conducted was trimming items_game.txt after 3 loops
if (loopsbeforetrim<=0)
	loopsbeforetrim:=1

;if fastmisc=1
;{
;	VarWrite( )				;blanks Function Static "Var" variable! Always start Writing in a blank variable, avoiding Rewritings (Faster) 
;}

;fnawofjwao:=A_TickCount

htarget=`r`n%A_Tab%%A_Tab%%A_Tab%"prefab"%A_Tab%%A_Tab%"announcer"`r`n
misccounter:=0 ; resets back to zero

;trim leftmost and rightmost sides that has no relevant search targets "htarget"
filestring:=Substr(filestringcopy,InStr(filestringcopy,sfinder,,InStr(filestringcopy,htarget)-filelength),InStr(filestringcopy,sfinder,,InStr(filestringcopy,htarget,,0))+strlen(sfinder)-filelength-1)
;

Loop
{
	if A_DefaultListView<>announcerview
	{
		Gui, MainGUI:ListView,announcerview
	}
	
	trimindex:=mod(A_Index,loopsbeforetrim+1) ; sets the index 1,2,3,...,...,n,0 where 0 at the end is neglected
	if (trimindex<=0)
		continue
	ipos := InStr(filestring,htarget,,,trimindex)
	
	if ipos<=0
	{
		;if fastmisc=1
		;{
			; IniWrite,%misccounter%,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,Announcers,AnnouncersCount
			;VarWrite("AnnouncersCount",misccounter)	;VarWrite(Key := "", Value := "")
		;}
		Break
	}
	
	ipos1:=InStr(filestring,sfinder,,ipos-strlen(filestring))
	ipos:=InStr(filestring,sfinder,,ipos)
	filecontent:=Substr(filestring,ipos1,ipos-ipos1)
	if !InStr(filecontent,"`r`n			""baseitem""		""1""")
	{
		hitemname:=searchstringdetector(filecontent,"""name""") ; detects the name of the item
		hitemid:=iddetector(filecontent) ;filecontent := extracted content from items_game.txt
		hitemrarity:=searchstringdetector(filecontent,"""item_rarity""") ; detects the item's rarity\
		hitemslot:=searchstringdetector(filecontent,"""item_slot""") ; detects the hero body slot of the item
		;if fastmisc=1
		;{
			misccounter+=1 ; used by items count
			; IniWrite,%hitemname%,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,Announcers,AnnouncerName%misccounter%
			; IniWrite,%hitemslot%,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,Announcers,AnnouncerSlot%misccounter%
			; IniWrite,%hitemrarity%,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,Announcers,AnnouncerRarity%misccounter%
			; IniWrite,%hitemid%,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,Announcers,AnnouncerID%misccounter%
			;VarWrite("AnnouncerName" misccounter,hitemname)	;VarWrite(Key := "", Value := "")
			;VarWrite("AnnouncerSlot" misccounter,hitemslot)	;VarWrite(Key := "", Value := "")
			;VarWrite("AnnouncerRarity" misccounter,hitemrarity)	;VarWrite(Key := "", Value := "")
			;VarWrite("AnnouncerID" misccounter,hitemid)	;VarWrite(Key := "", Value := "")
		;}
		LV_Add(,hitemname,hitemslot,hitemrarity,hitemid)
		GuiControl,Text,searchnofound,Preloading %hitemname%
	}
	if ErrorLevel=1 ; hunt this errorlevel
	{
		;if fastmisc=1
		;{
			; IniWrite,%misccounter%,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,Announcers,AnnouncersCount
			;VarWrite("AnnouncersCount",misccounter)	;VarWrite(Key := "", Value := "")
		;}
		Break
	}
	if (trimindex=loopsbeforetrim)
		filestring:=SubStr(filestring,ipos)
}
LV_ModifyCol(2,"Sort")

htarget=`r`n%A_Tab%%A_Tab%%A_Tab%"prefab"%A_Tab%%A_Tab%"taunt"`r`n
misccounter:=0 ; resets back to zero

;trim leftmost and rightmost sides that has no relevant search targets "htarget"
filestring:=Substr(filestringcopy,InStr(filestringcopy,sfinder,,InStr(filestringcopy,htarget)-filelength),InStr(filestringcopy,sfinder,,InStr(filestringcopy,htarget,,0))+strlen(sfinder)-filelength-1)
;

Loop
{
	if A_DefaultListView<>tauntview
	{
		Gui, MainGUI:ListView,tauntview
	}
	
	trimindex:=mod(A_Index,loopsbeforetrim+1) ; sets the index 1,2,3,...,...,n,0 where 0 at the end is neglected
	if (trimindex<=0)
		continue
	ipos := InStr(filestring,htarget,,,trimindex)
	
	if ipos<=0
	{
		;if fastmisc=1
		;{
			; IniWrite,%misccounter%,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,Taunts,TauntsCount
			;VarWrite("TauntsCount",misccounter)	;VarWrite(Key := "", Value := "")
		;}
		Break
	}
	
	ipos1:=InStr(filestring,sfinder,,ipos-strlen(filestring))
	ipos:=InStr(filestring,sfinder,,ipos)
	filecontent:=Substr(filestring,ipos1,ipos-ipos1)
	if !InStr(filecontent,"`r`n			""baseitem""		""1""")
	{
		hitemname:=searchstringdetector(filecontent,"""name""") ; detects the name of the item
		hitemid:=iddetector(filecontent) ;filecontent := extracted content from items_game.txt
		hitemrarity:=searchstringdetector(filecontent,"""item_rarity""") ; detects the item's rarity
		hherouser:=searchstringdetector(filecontent,"""used_by_heroes""") ; detects the hero who uses the item
		StringTrimLeft, hherouser, hherouser, 14
		;if fastmisc=1
		;{
			misccounter+=1 ; used by items count
			;IniWrite,%hitemname%,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,Taunts,TauntName%misccounter%
			;IniWrite,%hitemrarity%,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,Taunts,TauntRarity%misccounter%
			;IniWrite,%hitemid%,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,Taunts,TauntID%misccounter%
			;IniWrite,%hherouser%,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,Taunts,TauntUser%misccounter%
			;VarWrite("TauntName" misccounter,hitemname)	;VarWrite(Key := "", Value := "")
			;VarWrite("TauntRarity" misccounter,hitemrarity)	;VarWrite(Key := "", Value := "")
			;VarWrite("TauntID" misccounter,hitemid)	;VarWrite(Key := "", Value := "")
			;VarWrite("TauntUser" misccounter,hherouser)	;VarWrite(Key := "", Value := "")
		;}
		LV_Add(,hitemname,hitemrarity,hitemid,hherouser)
		GuiControl,Text,searchnofound,Preloading %hitemname%
	}
	if ErrorLevel=1 ; hunt this errorlevel
	{
		;if fastmisc=1
		;{
			; IniWrite,%misccounter%,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,Taunts,TauntsCount
			;VarWrite("TauntsCount",misccounter)	;VarWrite(Key := "", Value := "")
		;}
		Break
	}
	if (trimindex=loopsbeforetrim)
		filestring:=SubStr(filestring,ipos)
}
LV_ModifyCol(4,"Sort")

filter=`r`n%A_Tab%%A_Tab%%A_Tab%"prefab"%A_Tab%%A_Tab%"misc"`r`n

param:=[["weatherchoice","weather"],["multikillchoice","multikill_banner"]]

for intsaver, in param
{
	subject:=param[intsaver,2]
	htarget=`r`n%A_Tab%%A_Tab%%A_Tab%"item_slot"%A_Tab%%A_Tab%"%subject%"`r`n
	misccounter:=0 ; resets back to zero
	
	;trim leftmost and rightmost sides that has no relevant search targets "filter"
	pos:=InStr(filestringcopy,sfinder,,InStr(filestringcopy,filter)-filelength)
	pos:=InStr(filestringcopy,sfinder,,InStr(filestringcopy,htarget,,pos)-filelength)
	pos1:=InStr(filestringcopy,sfinder,,InStr(filestringcopy,filter,,0))+strlen(sfinder)-1
	pos1:=InStr(filestringcopy,sfinder,,InStr(filestringcopy,htarget,,pos1+1-filelength))+strlen(sfinder)-1
	filestring:=Substr(filestringcopy,pos,pos1-filelength) ;set initial reference for this misc
	;
	
	Loop
	{
		if A_DefaultListView<>% param[intsaver,1]
		{
			Gui, MainGUI:ListView,% param[intsaver,1]
		}
	
		trimindex:=mod(A_Index,loopsbeforetrim+1) ; sets the index 1,2,3,...,...,n,0 where 0 at the end is neglected
		if (trimindex<=0)
			continue
		ipos := InStr(filestring,htarget,,,trimindex)
		
		if ipos<=0
		{
			;if fastmisc=1
			;{
				; IniWrite,%misccounter%,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,%subject%,%subject%Count
				;VarWrite(subject "Count",misccounter)	;VarWrite(Key := "", Value := "")
			;}
			Break
		}
		
		ipos1:=InStr(filestring,sfinder,,ipos-strlen(filestring))
		ipos:=InStr(filestring,sfinder,,ipos)
		filecontent:=Substr(filestring,ipos1,ipos-ipos1)
		if !InStr(filecontent,"`r`n			""baseitem""		""1""") and instr(filecontent,filter)
		{
			itemname:=searchstringdetector(filecontent,"""name""") ; detects the name of the item
			hitemname=%itemname%
			tmpbar:=iddetector(filecontent) ;filecontent := extracted content from items_game.txt
			hitemid=%tmpbar%
			itemname:=searchstringdetector(filecontent,"""item_rarity""") ; detects the item's rarity
			hitemrarity=%itemname%
			;if fastmisc=1
			;{
				misccounter+=1 ; used by items count
				; IniWrite,%hitemname%,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,%subject%,%subject%Name%misccounter%
				; IniWrite,%hitemrarity%,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,%subject%,%subject%Rarity%misccounter%
				; IniWrite,%hitemid%,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,%subject%,%subject%ID%misccounter%
				;VarWrite(subject "Name" misccounter,hitemname)	;VarWrite(Key := "", Value := "")
				;VarWrite(subject "Rarity" misccounter,hitemrarity)	;VarWrite(Key := "", Value := "")
				;VarWrite(subject "ID" misccounter,hitemid)	;VarWrite(Key := "", Value := "")
			;}
			LV_Add(,hitemname,hitemrarity,hitemid)
			GuiControl,Text,searchnofound,Preloading %subject% Effect: %hitemname%
		}
		if (trimindex=loopsbeforetrim)
			filestring:=SubStr(filestring,ipos)
	}
}
VarSetCapacity(filestringdummy,0)

param:=[["loadingscreenchoice","loading_screen"],["musicchoice","music"],["cursorchoice","cursor_pack"],["emblemchoice","emblem"],["versuscreenchoice","versus_screen"],["emoticonchoice","emoticon_tool"]]
for intsaver, in param
{
	subject:=param[intsaver,2]
	misccounter=0 ; resets back to zero
	htarget=`r`n%A_Tab%%A_Tab%%A_Tab%"prefab"%A_Tab%%A_Tab%"%subject%"`r`n
	
	;trim leftmost and rightmost sides that has no relevant search targets "htarget"
	filestring:=Substr(filestringcopy,InStr(filestringcopy,sfinder,,InStr(filestringcopy,htarget)-filelength),InStr(filestringcopy,sfinder,,InStr(filestringcopy,htarget,,0))+strlen(sfinder)-filelength-1)
	;
	
	Loop
	{
		if A_DefaultListView<>% param[intsaver,1]
		{
			Gui, MainGUI:ListView,% param[intsaver,1]
		}
	
		trimindex:=mod(A_Index,loopsbeforetrim+1) ; sets the index 1,2,3,...,...,n,0 where 0 at the end is neglected
		if (trimindex<=0)
			continue
		ipos := InStr(filestring,htarget,,,trimindex)
		
		if ipos<=0
		{
			;if fastmisc=1
			;{
				; IniWrite,%misccounter%,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,%subject%,%subject%Count
				;VarWrite(subject "Count",misccounter)	;VarWrite(Key := "", Value := "")
			;}
			Break
		}
		
		ipos1:=InStr(filestring,sfinder,,ipos-strlen(filestring))
		ipos:=InStr(filestring,sfinder,,ipos)
		filecontent:=Substr(filestring,ipos1,ipos-ipos1)
		if !InStr(filecontent,"`r`n			""baseitem""		""1""")
		{
			itemname:=searchstringdetector(filecontent,"""name""") ; detects the name of the item
			hitemname=%itemname%
			tmpbar:=iddetector(filecontent) ;filecontent := extracted content from items_game.txt
			hitemid=%tmpbar%
			itemname:=searchstringdetector(filecontent,"""item_rarity""") ; detects the item's rarity
			hitemrarity=%itemname%
			;if fastmisc=1
			;{
				misccounter+=1 ; used by items count
				; IniWrite,%hitemname%,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,%subject%,%subject%Name%misccounter%
				; IniWrite,%hitemrarity%,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,%subject%,%subject%Rarity%misccounter%
				; IniWrite,%hitemid%,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,%subject%,%subject%ID%misccounter%
				;VarWrite(subject "Name" misccounter,hitemname)	;VarWrite(Key := "", Value := "")
				;VarWrite(subject "Rarity" misccounter,hitemrarity)	;VarWrite(Key := "", Value := "")
				;VarWrite(subject "ID" misccounter,hitemid)	;VarWrite(Key := "", Value := "")
			;}
			LV_Add(,hitemname,hitemrarity,hitemid)
			GuiControl,Text,searchnofound,Preloading %subject%: %hitemname%
		}
		if ErrorLevel=1 ; hunt this errorlevel
		{
			;if fastmisc=1
			;{
				; IniWrite,%misccounter%,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,%subject%,%subject%Count
				;VarWrite(subject "Count",misccounter)	;VarWrite(Key := "", Value := "")
			;}
			Break
		}
		if (trimindex=loopsbeforetrim)
			filestring:=SubStr(filestring,ipos)
	}
}
param:=[["courierchoice","courier"],["wardchoice","ward"],["hudchoice","hud_skin"],["radcreepchoice","radiantcreeps"],["direcreepchoice","direcreeps"],["radtowerchoice","radianttowers"],["diretowerchoice","diretowers"],["terrainchoice","terrain"]]
for intsaver, in param
{
	subject:=param[intsaver,2]
	misccounter=0 ; resets back to zero
	htarget=`r`n%A_Tab%%A_Tab%%A_Tab%"prefab"%A_Tab%%A_Tab%"%subject%"`r`n
	
	;trim leftmost and rightmost sides that has no relevant search targets "htarget"
	filestring:=Substr(filestringcopy,InStr(filestringcopy,sfinder,,InStr(filestringcopy,htarget)-filelength),InStr(filestringcopy,sfinder,,InStr(filestringcopy,htarget,,0))+strlen(sfinder)-filelength-1)
	;
	
	Loop
	{
		if A_DefaultListView<>% param[intsaver,1]
		{
			Gui, MainGUI:ListView,% param[intsaver,1]
		}
	
		trimindex:=mod(A_Index,loopsbeforetrim+1) ; sets the index 1,2,3,...,...,n,0 where 0 at the end is neglected
		if (trimindex<=0)
			continue
		ipos := InStr(filestring,htarget,,,trimindex)
		
		if ipos<=0
		{
			;if fastmisc=1
			;{
				; IniWrite,%misccounter%,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,%subject%,%subject%Count
				;VarWrite(subject "Count",misccounter)	;VarWrite(Key := "", Value := "")
			;}
			Break
		}
		
		ipos1:=InStr(filestring,sfinder,,ipos-strlen(filestring))
		ipos:=InStr(filestring,sfinder,,ipos)
		filecontent:=Substr(filestring,ipos1,ipos-ipos1)
		if !InStr(filecontent,"`r`n			""baseitem""		""1""")
		{
			itemname:=searchstringdetector(filecontent,"""name""") ; detects the name of the item
			hitemname=%itemname%
			tmpbar:=iddetector(filecontent) ;filecontent := extracted content from items_game.txt
			hitemid=%tmpbar%
			itemname:=searchstringdetector(filecontent,"""item_rarity""") ; detects the item's rarity
			hitemrarity=%itemname%
			stylescount:=stylecountdetector(filecontent) ;counts the number of allowed styles of an item
			;if fastmisc=1
			;{
				misccounter+=1 ; used by items count
				; IniWrite,%hitemname%,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,%subject%,%subject%Name%misccounter%
				; IniWrite,%hitemrarity%,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,%subject%,%subject%Rarity%misccounter%
				; IniWrite,%hitemid%,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,%subject%,%subject%ID%misccounter%
				; IniWrite,%stylescount%,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,%subject%,%subject%StyleCount%misccounter%
				; IniWrite,0,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,%subject%,%subject%ActivedStyle%misccounter%
				;VarWrite(subject "Name" misccounter,hitemname)	;VarWrite(Key := "", Value := "")
				;VarWrite(subject "Rarity" misccounter,hitemrarity)	;VarWrite(Key := "", Value := "")
				;VarWrite(subject "ID" misccounter,hitemid)	;VarWrite(Key := "", Value := "")
				;VarWrite(subject "StyleCount" misccounter,stylescount)	;VarWrite(Key := "", Value := "")
				;VarWrite(subject "ActivedStyle" misccounter,"0")	;VarWrite(Key := "", Value := "")
			;}
			LV_Add(,hitemname,hitemrarity,hitemid,stylescount,"0")
			GuiControl,Text,searchnofound,Preloading %subject%: %hitemname%
		}
		if ErrorLevel=1 ; hunt this errorlevel
		{
			;if fastmisc=1
			;{
				; IniWrite,%misccounter%,%A_ScriptDir%\Library\Reference.aldrin_dota2mod,%subject%,%subject%Count
				;VarWrite(subject "Count",misccounter)	;VarWrite(Key := "", Value := "")
			;}
			Break
		}
		if (trimindex=loopsbeforetrim)
			filestring:=SubStr(filestring,ipos)
	}
	
}
VarSetCapacity(param,0)
;speedtesting
;speedmessage.="trim at " A_Index " : " A_TickCount-fnawofjwao "`n"
;}
;msgbox %speedmessage%
;

GuiControl,Text,searchnofound,Creating Reference File
;FileAppend,% VarWrite( , "GetVar") "`r`n" firstmessage GlobalArray["items_game.txt"] lastmessage,%A_ScriptDir%\Library\Reference.aldrin_dota2mod ;"VarWrite( ,"GetVar")" function returns the text that will be stored in the file choosed by user, the first parameter must be omitted or blank
filestring:=GlobalArray["items_game.txt"]
loop,parse,lvparam,`,
{
	if A_DefaultListView<>%A_LoopField%
	{
		Gui, MainGUI:ListView,%A_LoopField%
	}
	GuiControl,Text,searchnofound,Saving Contents of ListView: %A_LoopField%
	filestring.="`r`n~~~~~~~~~~" A_LoopField "~~~~~~~~~~`r`n" ListViewSave(" ") "`r`n~~~~~~~~~~" A_LoopField "~~~~~~~~~~`r`n"
	GoSub,lvautosize
	gosub,detectsorting
}
FileAppend,%filestring%,%A_ScriptDir%\Library\Reference.aldrin_dota2mod ; write a save scratch of the items_game.txt
FileSetAttrib,+RH,%A_ScriptDir%\Library\Reference.aldrin_dota2mod ; protect the setting file from noobs
GuiControl,MainGUI:Text,searchnofound,%defaultshoutout%
GuiControl,MainGUI:Show,searchnofound
GuiControl,+cDefault,searchnofound
Gui, MainGUI:-Disabled
return

autovpkon:
Gui, MainGUI:Submit, NoHide
if autovpkon=1
{
	ifnotExist,%giloc%
	{
		Gui, MainGUI:+Disabled 
		guicontrol,,autovpkon,0
		msgbox,16,ERROR!,The located "gameinfo.gi" path Does not EXIST!
		Gui, MainGUI:-Disabled 
	}
	else if giloc=
	{
		Gui, MainGUI:+Disabled 
		guicontrol,,autovpkon,0
		msgbox,16,ERROR!,Please locate "gameinfo.gi" first before activating this feature.
		Gui, MainGUI:-Disabled 
	}
}
return

basicmisc:
if InStr(ErrorLevel, "C", true)
{
	if A_DefaultListView<>%A_GuiControl%
	{
		Gui, MainGUI:ListView, %A_GuiControl%
	}
	Loop % LV_GetCount()
	{
		if A_EventInfo<>%A_Index%
		{
			LV_Modify(A_Index,"-Check")
		}
	}
}
gosub,detectsorting
return

announcerview:
if InStr(ErrorLevel, "C", true)
{
	if A_DefaultListView<>announcerview
	{
		Gui, MainGUI:ListView,announcerview
	}
	LV_GetText(tmp,A_EventInfo,2)
	Loop % LV_GetCount()
	{
		if A_EventInfo<>%A_Index%
		{
			LV_GetText(tmp1,A_Index,2)
			if tmp=%tmp1%
			{
				LV_Modify(A_Index,"-Check")
			}
		}
	}
}
gosub,detectsorting
return

tauntview:
if InStr(ErrorLevel, "C", true)
{
	if A_DefaultListView<>tauntview
	{
		Gui, MainGUI:ListView,tauntview
	}
	LV_GetText(tmp,A_EventInfo,4)
	Loop % LV_GetCount()
	{
		if A_EventInfo<>%A_Index%
		{
			LV_GetText(tmp1,A_Index,4)
			if tmp=%tmp1%
			{
				LV_Modify(A_Index,"-Check")
			}
		}
	}
}
gosub,detectsorting
return

d2locbrowse:
Gui MainGUI:+OwnDialogs
FileSelectFolder,invfolder,*%SteamPath%\steamapps\common\,,Browse DOTA2 Directory
if invfolder<>
{
	ifexist,%invfolder%\game\dota\pak01_dir.vpk
	{
		msgbox,36,Confirmation,Are you Sure that:`n`n%invfolder%\`n`nIs the Directory of your DOTA2 Beta?
		IfMsgBox Yes
		{
			GuiControl,Text,dota2dir,%invfolder%||
			dota2dir=%invfolder%
			mapdota2dir=%invfolder%
			IfExist,%A_ScriptDir%\Settings.aldrin_dota2mod
			{
				FileSetAttrib,-R,%A_ScriptDir%\Settings.aldrin_dota2mod
				IniWrite,%dota2dir%,%A_ScriptDir%\Settings.aldrin_dota2mod,Edits,mapdota2dir
				FileSetAttrib,+R,%A_ScriptDir%\Settings.aldrin_dota2mod
			}
		}
		else
		{
			gosub,d2locbrowse
		}
	}
	else
	{
		msgbox,48,ERROR!!!,%invfolder%\game\dota\pak01_dir.vpk should exist on the folder you selected!!! TRY AGAIN!!!
		gosub,d2locbrowse
	}
}
return

d2dirdetection:
RegRead, SteamPath, HKEY_CURRENT_USER, Software\Valve\Steam, SteamPath
StringReplace,SteamPath,SteamPath,/,\,1
Loop,%SteamPath%\steamapps\common\*,2
{
	ifexist,%A_LoopFileFullPath%\game\dota\pak01_dir.vpk
	{
		dota2dir=%A_LoopFileFullPath%
		mapdota2dir=%A_LoopFileFullPath%
		GuiControl,Text,dota2dir,%A_LoopFileFullPath%||
		Break
	}
}
if dota2dir=
{
	msgbox,16,ERROR!!!,DOTA2 Directory cannot be detected`, Please Locate the Directory of your DOTA2 Game found at "%SteamPath%/steamapps/common/"`n`nERROR Result: "game/dota/pak01_dir.vpk" cannot be detected.
	gosub,d2locbrowse
}
return

gilocbrowse:
Gui MainGUI:+OwnDialogs
FileSelectFile,invfile,3,,gameinfo.gi,gameinfo.gi
if invfile<>
{
	GuiControl,Text,giloc,%invfile%||
}
return

dirremover:
if (invdirview<>"") and (A_GuiControl="invdirview")
{
	msgbox,36,Confirm Dropdownlist Removal, Your are about to disable the use of "Custom items_game.txt". Are you sure you want to remove:`n"%invdirview%"
	IfMsgBox No
	{
		return
	}
	else IfMsgBox Yes
	{
		guicontrol,,ucron,0
	}
}
else if (giloc<>"") and (A_GuiControl="giloc")
{
	msgbox,36,Confirm Dropdownlist Removal, Your are about to disable the use of "Auto-Shutnik Method". The Following consequences will be initiated:`n`nENABLED-Auto-Creation of pak01_dir Folder with all hero cosmetic item files inside at:`n"%A_ScriptDir%\Generated MOD\"`nDISABLED-Auto-Patching of "gameinfo.gi"`nDISABLED-Auto-Creation of pak01_dir.vpk archieve at:`n"%dota2dir%\game\Aldrin_Mods\"`n`nAre you sure you want to Clear this path on the list?:`n"%giloc%"
	IfMsgBox No
	{
		return
	}
	else IfMsgBox Yes
	{
		guicontrol,,autovpkon,0
	}
}
else if (datadirview<>"") and (A_GuiControl="datadirview")
{
	msgbox,36,Confirm Dropdownlist Removal, Your are about to EMPTY the Datalists.Are you sure you want to Clear this path on the list?:`n"%datadirview%"
	IfMsgBox No
	{
		return
	}
	else IfMsgBox Yes
	{
		if A_DefaultListView<>invlv
		{
			Gui, MainGUI:ListView, invlv
		}
		LV_ClearAll()
	}
}
else if (hdatadirview<>"") and (A_GuiControl="hdatadirview")
{
	msgbox,36,Confirm Dropdownlist Removal, Your are about to EMPTY the Datalists.Are you sure you want to Clear this path on the list?:`n"%hdatadirview%"
	IfMsgBox No
	{
		return
	}
	else IfMsgBox Yes
	{
		if A_DefaultListView<>itemview
		{
			Gui, MainGUI:ListView,itemview
		}
		;LV_ClearAll()
		LV_Delete() ; delete all items at itemlist
		checkdetector() ; unchecks everything at the showitems listview
	}
}
GuiControl,MainGUI:Text,%A_GuiControl%,|
Gui, MainGUI:Submit, NoHide
return

chreload:
Gui, MainGUI:Default
Gui, MainGUI:+Disabled 
if A_DefaultListView<>chview
{
	Gui, MainGUI:ListView, chview
}
Loop %customherocount%
{
	IniRead,tmp2,%A_ScriptDir%\CustomHeroes.aldrin_dota2mod,CustomHeroes,CustomHero%A_Index%
	tmp := StrReplace(tmp,chbar,chbar,existencecount)
	LV_Add(,tmp2,existencecount)
	GoSub,lvautosize
}
Gui, MainGUI:-Disabled 
return

chbuttondelete:
Gui, MainGUI:Default
if A_DefaultListView<>chview
{
	Gui, MainGUI:ListView, chview
}
gosub,deleterow
return

chview:
if A_GuiControl=chview
{
	if A_GuiEvent=RightClick
	{
		Menu, chContextMenu, Show
	}
}
return

chadd:
Gui, MainGUI:Submit, NoHide
if InStr(GlobalArray["herolist"],chbar) and (chbar!="None")
{
	return
}
if A_DefaultListView<>chview
{
	Gui, MainGUI:ListView, chview
}
Loop % LV_GetCount()
{
	LV_GetText(checker,A_Index,1)
	if checker=%chbar%
	{
		return
	}
}
StrReplace(GlobalArray["items_game.txt"],chbar,chbar,existencecount) ; count number of relevance if it existed in the items_game.txt
LV_Add(,chbar,existencecount)
GoSub,lvautosize
return

chsave:
gosub,leakdestroyer
Gui, MainGUI:Submit, NoHide
ifexist,%A_ScriptDir%\CustomHeroes.aldrin_dota2mod
{
	FileSetAttrib,-R,%A_ScriptDir%\CustomHeroes.aldrin_dota2mod
	FileDelete,%A_ScriptDir%\CustomHeroes.aldrin_dota2mod
}
FileAppend,%masterfilecontent%,%A_ScriptDir%\CustomHeroes.aldrin_dota2mod
Loop % LV_GetCount()
{
	LV_GetText(tmp,A_Index,1)
	IniWrite,%tmp%,%A_ScriptDir%\CustomHeroes.aldrin_dota2mod,CustomHeroes,CustomHero%A_Index%
}
FileSetAttrib,+RH,%A_ScriptDir%\CustomHeroes.aldrin_dota2mod ; protect the setting file from noobs
gosub,savetab ; before reloading the script, save the current active tabs
Reload
Sleep 1000
msgbox,16,Failed to Reload,Please Restart this Tool Manually.
return

default_settings:
IfNotExist,%A_ScriptDir%\Settings.aldrin_dota2mod
{
	FileAppend,,%A_ScriptDir%\Settings.aldrin_dota2mod
	tmpr:=ceil(getmemoryspecs()*getmemoryspecs("Speed")/400000000000)
	if !(tmpr>=1)
		tmpr:=5
	IniWrite,%tmpr%,%A_ScriptDir%\Settings.aldrin_dota2mod,Edits,cmdmaxinstances
	param:=[["pet",0],["usemisc",1],["mappetstyle",3],["soundon",1],["useextportraitfile",0],["useextfile",0],["useextitemgamefile",0],["fastmisc",0],["showtooltips",1],["singlesourcechoice",1],["multiplestyleschoice",1],["disableautoupdate",0],["ucr",0]]
	for index, in param
	{
		IniWrite,% param[index,2],%A_ScriptDir%\Settings.aldrin_dota2mod,Edits,% param[index,1]
	}
	RegRead, SteamPath, HKEY_CURRENT_USER, Software\Valve\Steam, SteamPath
	StringReplace,SteamPath,SteamPath,/,\,1
	ifexist,%dota2dir%\game\dota\gameinfo.gi
	{
		IniWrite,%dota2dir%\game\dota\gameinfo.gi,%A_ScriptDir%\Settings.aldrin_dota2mod,Edits,mapgiloc
		IniWrite,1,%A_ScriptDir%\Settings.aldrin_dota2mod,Edits,autovpk
	}
	else
	{
		IniWrite,0,%A_ScriptDir%\Settings.aldrin_dota2mod,Edits,autovpk
	}
	ifexist,%SteamPath%\steamapps\common\dota 2 beta\game\dota\pak01_dir.vpk
	{
		IniWrite,%SteamPath%\steamapps\common\dota 2 beta,%A_ScriptDir%\Settings.aldrin_dota2mod,Edits,mapdota2dir
	}
	else ifexist,%dota2dir%\game\dota\pak01_dir.vpk
	{
		IniWrite,%dota2dir%,%A_ScriptDir%\Settings.aldrin_dota2mod,Edits,mapdota2dir
	}
	newuser=1
	FileSetAttrib,+RH,%A_ScriptDir%\Settings.aldrin_dota2mod ; protect the setting file from noobs
}
return

mdirbrowse:
Gui MainGUI:+OwnDialogs
Gui,MainGUI:Submit,NoHide
FileSelectFile,invfile,3,,items_game.txt,items_game.txt
checker:=SubStr(invfile,-13,14)
If checker=items_game.txt
{
	GuiControl,Text,mdirview,%invfile%||
}
return

mselectinject:
gosub,leakdestroyer
ifnotexist,%A_ScriptDir%\Library\items_game.txt
{
	msgbox,16,Error!!!,"%A_ScriptDir%\Library\items_game.txt"`n`nIs Missing!!! Make sure to add the original "items_game.txt" at "%A_ScriptDir%\Library" Folder.`n`nIf you dont have an Idea how to get the original "items_game.txt" use "GCFScape.exe" or "Valve's Resource Viewer" application to access "Pak01_dir.vpk". Inside the VPK Archive`,Hit "Ctrl+F"(Find) and search for "items_game.txt". If successfully found`, extract it(items_game.txt) at "%A_ScriptDir%\Library\" Folder.
	return
}
Gui, MainGUI:+Disabled 
Gui,MainGUI:Submit,NoHide
FileRead,filefrom,%mdirview%
filefromlength:=StrLen(filefrom)
fileto:=GlobalArray["items_game.txt"]
filetolength:=StrLen(fileto)
filechecker:=fileto,masterfilecontent:=fileto,IPS:=A_TickCount
usedFinder=%A_Tab%%A_Tab%%A_Tab%"prefab"%A_Tab%%A_Tab%"default_item"
usedBarrier=%A_Tab%%A_Tab%}`r`n%A_Tab%%A_Tab%" ;"
GuiControl,+cBlue,searchnofound
Loop
{
	StringGetPos, pos, filefrom,%usedFinder%,L%A_Index%
	if pos<0
	{
		Break
	}
	StringGetPos, pos1, filefrom,%usedBarrier%,,pos
	rightpos:=filefromlength-pos1
	StringGetPos, pos2, filefrom,%usedBarrier%,R1,rightpos
	length:=pos1-pos2
	StringMid,comparedfrom,filefrom,%pos2%,%length%
	if comparedfrom=
	{
		Break
	}
	filecontent=%comparedfrom%
	itemname:=searchstringdetector(filecontent,"""item_slot""") ; detects the hero body slot of the item
	itemslotfrom=%itemname%
	itemname:=searchstringdetector(filecontent,"""used_by_heroes""") ; detects the hero who uses the item
	herouserfrom=%itemname%
	if herouserfrom<>name
	{
		tmpbar:=iddetector(filecontent) ;filecontent := extracted content from items_game.txt
		idfrom=%tmpbar%
		tmpstring=%tmpbar%
		; measures the number of items injected per second
		Gui,MainGUI:Show,NoActivate,% floor(1000/(A_TickCount-IPS)) " Items per Second"
		IPS:=A_TickCount
		;
		GuiControl,Text,searchnofound,Please Stand By`, Migrating %herouserfrom%'s %itemslotfrom%
		filestring=%fileto%
		filecontent:=itemdetector(tmpstring) ;filecontent:=itemdetector(tmpstring,filestring)
		comparedto=%filecontent%
		itemname:=searchstringdetector(filecontent,"""item_slot""") ; detects the hero body slot of the item
		itemslotto=%itemname%
		itemname:=searchstringdetector(filecontent,"""used_by_heroes""") ; detects the hero who uses the item
		herouserto=%itemname%
		if (itemslotto=itemslotfrom) and (herouserto=herouserfrom) and (comparedto<>comparedfrom)
		{
			StringReplace,masterfilecontent,masterfilecontent,%comparedto%,%comparedfrom%,1
		}
		else if comparedto<>%comparedfrom%
		{
			loop
			{
				StringGetPos, pos, fileto,%herouserfrom%,L%A_Index%
				if pos<0
				{
					Break
				}
				StringGetPos, pos1, fileto,%usedBarrier%,,pos
				rightpos:=filetolength-pos1
				StringGetPos, pos2, fileto,%usedBarrier%,R1,rightpos
				length:=pos1-pos2
				StringMid,comparedto,fileto,%pos2%,%length%
				if comparedto=
				{
					Break
				}
				filecontent=%comparedto%
				itemname:=searchstringdetector(filecontent,"""item_slot""") ; detects the hero body slot of the item
				itemslotto=%itemname%
				itemname:=searchstringdetector(filecontent,"""used_by_heroes""") ; detects the hero who uses the item
				herouserto=%itemname%
				if (InStr(comparedto,"default_item")) and (itemslotto=itemslotfrom)
				{
					tmpbar:=iddetector(filecontent) ;filecontent := extracted content from items_game.txt
					idto=%tmpbar%
					StringReplace,comparedfrom,comparedfrom,"%idfrom%","%idto%",1
					StringReplace,masterfilecontent,masterfilecontent,%comparedto%,%comparedfrom%,1
					Break
				}
				If ErrorLevel=1 ; hunt this errorlevel
				{
					Break
				}
			}
		}
		If ErrorLevel=1 ; hunt this errorlevel
		{
			Break
		}
	}
}
if usemiscon=1
{
	GoSub,execmisc
}
if masterfilecontent=%filechecker%
{
	msgbox,16,ERROR!,No change was found to be migrated!
}
else
{
	IfNotExist,%A_ScriptDir%\Generated MOD\
	{
		FileCreateDir, %A_ScriptDir%\Generated MOD
	}
	else ifexist,%A_ScriptDir%\Generated MOD\items_game.txt
	{
		FileDelete,%A_ScriptDir%\Generated MOD\items_game.txt
	}
	FileAppend,%masterfilecontent%,%A_ScriptDir%\Generated MOD\items_game.txt
	GuiControl,+cGreen,searchnofound
	GuiControl,Text,searchnofound,Operation Finished!
	sleep 1000
	Run, %A_ScriptDir%\Generated MOD\,,UseErrorLevel
}
GuiControl,+cDefault,searchnofound
GuiControl,MainGUI:Text,searchnofound,%defaultshoutout%
GuiControl,MainGUI:Show,searchnofound
Gui,MainGUI:Show,NA,AJOM's Dota 2 MOD Master
Gui, MainGUI:-Disabled
gosub,leakdestroyer
return

itemview:
if A_GuiControl=itemview
{
	if A_GuiEvent=RightClick
	{
		position=%A_EventInfo%
		Menu, MyContextMenu, Show
	}
}
return

hbuttondelete:
Gui, MainGUI:Default
if A_DefaultListView<>itemview
{
	Gui, MainGUI:ListView, itemview
}
gosub,deleterow
checkdetector() ; check any field that exist on the listview "itemview"
return

hbuttonstyle:
Gui, MainGUI:Default
if A_DefaultListView<>itemview
{
	Gui, MainGUI:ListView, itemview
}
LV_GetText(stylescount,position,6)
LV_GetText(countcheck,position,7)
if stylescount>%countcheck%
{
	LV_Modify(position,"Select" "Col7",,,,,,,countcheck+1)
}
else
{
	LV_Modify(position,"Select" "Col7",,,,,,,"0")
}
checkdetector() ; check any field that exist on the listview "itemview"
return

movepak:
tempo:=A_DetectHiddenWindows 
DetectHiddenWindows,On
;finish all extractions first
;for index,cPID in extractpid
;{
;	WinWaitClose,% "ahk_pid " cPID " ahk_exe cmd.exe ahk_class ConsoleWindowClass" ;wait indefinitely until it closes
;}
loop,parse,extractpid,`,
{
	WinWaitClose,% "ahk_pid " A_LoopField " ahk_exe cmd.exe ahk_class ConsoleWindowClass" ;wait indefinitely until it closes
}
VarSetCapacity(extractpid,0)
;

;command the thread of skinextract to terminate itself after finishing all its queue operations
if !fileexist(A_Temp "\AJOM Innovations\DOTA2 MOD Master\extractlist.aldrin_dota2list")
	FileAppend,,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\extractlist.aldrin_dota2list
IniWrite,1,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\extractlist.aldrin_dota2list,Status,terminateprogram

WinWaitClose, ahk_pid %skinextract% ; wait for the skinextract thread to close
;
DetectHiddenWindows,%tempo%

IfNotExist,%A_ScriptDir%\Generated MOD\
{
	FileCreateDir, %A_ScriptDir%\Generated MOD
}
else ifexist,%A_ScriptDir%\Generated MOD\pak01_dir\
{
	GuiControl,Text,searchnofound,Deleting pak01_dir Folder at Generated MOD Folder
	FileRemoveDir,%A_ScriptDir%\Generated MOD\pak01_dir,1
}
IfNotExist,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\scripts\items\
{
	FileCreateDir,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\scripts\items\
}
else ifexist,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\scripts\items\items_game.txt
{
	FileDelete,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\scripts\items\items_game.txt
}
FileAppend,%masterfilecontent%,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\scripts\items\items_game.txt
IfNotExist,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\scripts\npc\
{
	FileCreateDir,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\scripts\npc\
}
else ifexist,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\scripts\npc\portraits.txt
{
	FileDelete,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\scripts\npc\portraits.txt
}
FileAppend,%portstring%,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\scripts\npc\portraits.txt
gosub,externalfiles
FileMoveDir,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir,%A_ScriptDir%\Generated MOD\pak01_dir,2
if soundon=1
{
	SoundPlay,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\Sound\OperationFinished.wav
}
GuiControl,+cGreen,searchnofound
GuiControl,Text,searchnofound,Operation Finished!
sleep 1000
Run, %A_ScriptDir%\Generated MOD\,,UseErrorLevel
GuiControl,+cDefault,searchnofound
GuiControl,MainGUI:Text,searchnofound,%defaultshoutout%
GuiControl,MainGUI:Show,searchnofound

return

;Scans the database then put a checkmark on each miscellaneous it uses
reloadmisc(invfile) {
	Gui, MainGUI:+Disabled 
	gosub,hideprogress
	GuiControl,+cBlue,searchnofound
	
	GuiControlGet,maperrorshow,,errorshow
	if VarRead("@DataBaseVersion!")=2
	{
		param=terrainchoice,weatherchoice,hudchoice,courierchoice,wardchoice,loadingscreenchoice,tauntview,announcerview,musicchoice,cursorchoice,multikillchoice,emblemchoice,radcreepchoice,direcreepchoice,radtowerchoice,diretowerchoice,versuscreenchoice,emoticonchoice
		Loop,parse,param,`,
		{
			if A_DefaultListView<>%A_LoopField%
			{
				Gui, MainGUI:ListView,%A_LoopField%
			}
			LV_Modify(0,"-check")
		}
		loop ; everlasting loop until encountering redundancy(errorlevel=1)
		{
			miscid:=VarRead("miscid" A_Index)
			GuiControl,Text,searchnofound, Preloading Miscellaneous ID: %miscid%
			miscidname:=VarRead("miscidname" A_Index)
			misclv:=VarRead("misclv" A_Index)
			;IniRead,miscid%A_Index%,%invfile%,Miscellaneous,miscid%A_Index%
			;IniRead,miscidname%A_Index%,%invfile%,Miscellaneous,miscidname%A_Index%
			;IniRead,misclv%A_Index%,%invfile%,Miscellaneous,misclv%A_Index%
			if A_DefaultListView<>% misclv
			{
				Gui, MainGUI:ListView,% misclv
			}
			GuiControl,-g,% misclv
			if (misclv="courierchoice") or (misclv="wardchoice") or (misclv="hudchoice") or (misclv="radcreepchoice") or (misclv="direcreepchoice") or (misclv="radtowerchoice") or (misclv="diretowerchoice") or (misclv="terrainchoice")
			{
				;IniRead,miscstyle%A_Index%,%invfile%,Miscellaneous,miscstyle%A_Index%
				miscstyle:=VarRead("miscstyle" A_Index)
			}
			loop % LV_GetCount()
			{
				if misclv=announcerview
				{
					LV_GetText(tmp,A_Index,4)
				}
				else
				{
					LV_GetText(tmp,A_Index,3)
				}
				if miscid=%tmp%
				{
					LV_GetText(tmp,A_Index,1)
					if miscidname<>%tmp%
					{
						tmpbar:=newiddetector(miscidname) ;tmpbar:=newiddetector(miscidname,filestring) ; tmpstring:=item name , filestring:=items_game.txt
						if tmpbar<>
						{
							maperrorshow=% maperrorshow "Section: Miscellaneous:`nListview: " A_DefaultListView "`nName: " miscidname "`nRegistered ID: "  miscid "`nProblem: Name does not pair with the Registered ID!`nSolution: changing the Registered ID into " tmpbar "`nStatus: Solved! No need for Further User Action`n`n"
							miscid=%tmpbar%
						}
						else
						{
							maperrorshow=% maperrorshow "Section: Miscellaneous:`nListview: " A_DefaultListView "`nID: " miscid "Registered Name: " miscidname "`nProblem: ID has a different name!`nSolution: changing the registered name into " tmp "`nStatus: Solved! No need for Further User Action`n`n"
						}
					}
					if (misclv="courierchoice") or (misclv="wardchoice") or (misclv="hudchoice") or (misclv="radcreepchoice") or (misclv="direcreepchoice") or (misclv="radtowerchoice") or (misclv="diretowerchoice") or (misclv="terrainchoice")
					{
						LV_GetText(checker,A_Index,4)
						if miscstyle<=%checker%
						{
							LV_Modify(A_Index,"Col5",miscstyle)
						}
					}
					LV_Modify(A_Index,"check")
					Break
				}
			}
			if (misclv="announcerview") or (misclv="tauntview")
			{
				GuiControl,% "+g" misclv,% misclv
			}
			else if (misclv="courierchoice") or (misclv="wardchoice") or (misclv="hudchoice") or (misclv="radcreepchoice") or (misclv="direcreepchoice") or (misclv="radtowerchoice") or (misclv="diretowerchoice") or (misclv="terrainchoice")
			{
				GuiControl,+gmiscstyle,% misclv
			}
			else
			{
				GuiControl,+gbasicmisc,% misclv
			}
			If ErrorLevel=1 ;;; If the loop proves redundancy, terminate it
			{
				Break
			}
		}
		pet:=VarRead("pet")
		mappetstyle:=VarRead("mappetstyle")
		;IniRead,pet,%invfile%,Miscellaneous,pet
		;IniRead,mappetstyle,%invfile%,Miscellaneous,mappetstyle
		if pet<>1
		{
			pet=0
		}
		GuiControl,,peton,%pet%
		GuiControl,ChooseString,petstyle,%mappetstyle%
	}
	else if VarRead("@DataBaseVersion!")=1.5 ; if version 1.5, the recommended version
	{
		fileread,tmp,%invfile%
		loop
		{
			checker=miscid%A_Index%
			if InStr(tmp,checker)
			{
				count=%A_Index%
			}
			else
			{
				Break
			}
			If ErrorLevel=1 ; hunt this errorlevel
			{
				Break
			}
		}
		param=terrainchoice,weatherchoice,hudchoice,courierchoice,wardchoice,loadingscreenchoice,tauntview,announcerview,musicchoice,cursorchoice,multikillchoice,emblemchoice,radcreepchoice,direcreepchoice,radtowerchoice,diretowerchoice,versuscreenchoice,emoticonchoice
		Loop,parse,param,`,
		{
			if A_DefaultListView<>%A_LoopField%
			{
				Gui, MainGUI:ListView,%A_LoopField%
			}
			LV_Modify(0,"-check")
		}
		loop %count%
		{
			miscid:=VarRead("miscid" A_Index)
			miscidname:=VarRead("miscidname" A_Index)
			;IniRead,miscid,%invfile%,Miscellaneous,miscid%A_Index%
			;IniRead,miscidname,%invfile%,Miscellaneous,miscidname%A_Index%
			GuiControl,Text,searchnofound,% "Preloading Miscellaneous ID: " miscid
			misclv:=VarRead("misclv" A_Index)
			;IniRead,misclv,%invfile%,Miscellaneous,misclv%A_Index%
			if A_DefaultListView<>% misclv
			{
				Gui, MainGUI:ListView,% misclv
			}
			GuiControl,-g,% misclv
			if (misclv="courierchoice") or (misclv="wardchoice") or (misclv="hudchoice") or (misclv="radcreepchoice") or (misclv="direcreepchoice") or (misclv="radtowerchoice") or (misclv="diretowerchoice") or (misclv="terrainchoice")
			{
				miscstyle:=VarRead("miscstyle" A_Index)
				;IniRead,miscstyle,%invfile%,Miscellaneous,miscstyle%A_Index%
			}
			
			loop % LV_GetCount()
			{
				if misclv=announcerview
				{
					LV_GetText(tmp,A_Index,4)
				}
				else
				{
					LV_GetText(tmp,A_Index,3)
				}
				if miscid=%tmp%
				{
					LV_GetText(tmp,A_Index,1)
					if miscidname<>%tmp%
					{
						tmpbar:=newiddetector(miscidname) ;tmpbar:=newiddetector(tmpstring,filestring) ; tmpstring:=item name , filestring:=items_game.txt
						if tmpbar<>
						{
							maperrorshow=% maperrorshow "Section: Miscellaneous:`nListview: " A_DefaultListView "`nName: " miscidname "`nRegistered ID: "  miscid "`nProblem: Name does not pair with the Registered ID!`nSolution: changing the Registered ID into " tmpbar "`nStatus: Solved! No need for Further User Action`n`n"
							miscid=%tmpbar%
							VarWrite("miscid" intsaver,tmpbar)	;VarWrite(Key := "", Value := "")
							;IniWrite,%tmpbar%,%invfile%,Miscellaneous,miscid%intsaver%
						}
						else
						{
							maperrorshow=% maperrorshow "Section: Miscellaneous:`nListview: " A_DefaultListView "`nID: " miscid "Registered Name: " miscidname "`nProblem: ID has a different name!`nSolution: changing the registered name into " tmp "`nStatus: Solved! No need for Further User Action`n`n"
							VarWrite("miscidname" intsaver,tmp)	;VarWrite(Key := "", Value := "")
							;IniWrite,%tmp%,%invfile%,Miscellaneous,miscidname%intsaver%
						}
					}
					if (misclv="courierchoice") or (misclv="wardchoice") or (misclv="hudchoice") or (misclv="radcreepchoice") or (misclv="direcreepchoice") or (misclv="radtowerchoice") or (misclv="diretowerchoice") or (misclv="terrainchoice")
					{
						LV_GetText(checker,A_Index,4)
						if miscstyle<=%checker%
						{
							LV_Modify(A_Index,"Col5",miscstyle)
						}
					}
					LV_Modify(A_Index,"check")
					Break
				}
			}
			if (misclv="announcerview") or (misclv="tauntview")
			{
				GuiControl,% "+g" misclv,% misclv
			}
			else if (misclv="courierchoice") or (misclv="wardchoice") or (misclv="hudchoice") or (misclv="radcreepchoice") or (misclv="direcreepchoice") or (misclv="radtowerchoice") or (misclv="diretowerchoice") or (misclv="terrainchoice")
			{
				GuiControl,+gmiscstyle,% misclv
			}
			else
			{
				GuiControl,+gbasicmisc,% misclv
			}
		}
		pet:=VarRead("pet")
		mappetstyle:=VarRead("mappetstyle")
		;IniRead,pet,%invfile%,Miscellaneous,pet
		;IniRead,mappetstyle,%invfile%,Miscellaneous,mappetstyle
		if pet<>1
		{
			pet=0
		}
		GuiControl,,peton,%pet%
		GuiControl,ChooseString,petstyle,%mappetstyle%
	}
	else ;;; if version 1(oldest version) the slowest one but the most accurate one
	{
		fileread,tmp,%invfile%
		loop
		{
			checker=miscid%A_Index%
			if InStr(tmp,checker)
			{
				count=%A_Index%
			}
			else
			{
				Break
			}
			If ErrorLevel=1 ; hunt this errorlevel
			{
				Break
			}
		}
		param=terrainchoice,weatherchoice,hudchoice,courierchoice,wardchoice,loadingscreenchoice,tauntview,announcerview,musicchoice,cursorchoice,multikillchoice,emblemchoice,radcreepchoice,direcreepchoice,radtowerchoice,diretowerchoice,versuscreenchoice,emoticonchoice
		Loop,parse,param,`,
		{
			if A_DefaultListView<>%A_LoopField%
			{
				Gui, MainGUI:ListView,%A_LoopField%
			}
			LV_Modify(0,"-check")
		}
		loop %count%
		{
			intsaver:=A_Index
			IniRead,miscid,%invfile%,Miscellaneous,miscid%intsaver%
			IniRead,miscidname,%invfile%,Miscellaneous,miscidname%intsaver%
			GuiControl,Text,searchnofound,% "Preloading Miscellaneous ID: " miscid
			IniRead,misclv,%invfile%,Miscellaneous,misclv%intsaver%
			if A_DefaultListView<>% misclv
			{
				Gui, MainGUI:ListView,% misclv
			}
			GuiControl,-g,% misclv
			if (misclv="courierchoice") or (misclv="wardchoice") or (misclv="hudchoice") or (misclv="radcreepchoice") or (misclv="direcreepchoice") or (misclv="radtowerchoice") or (misclv="diretowerchoice") or (misclv="terrainchoice")
			{
				IniRead,miscstyle,%invfile%,Miscellaneous,miscstyle%intsaver%
			}
			loop % LV_GetCount()
			{
				if misclv=announcerview
				{
					LV_GetText(tmp,A_Index,4) ; get id
				}
				else
				{
					LV_GetText(tmp,A_Index,3) ; get id
				}
				if miscid=%tmp%
				{
					LV_GetText(tmp,A_Index,1) ; get name
					if miscidname<>%tmp%
					{
						tmpbar:=newiddetector(miscidname) ;tmpbar:=newiddetector(tmpstring,filestring) ; tmpstring:=item name , filestring:=items_game.txt
						if tmpbar<>
						{
							maperrorshow=% maperrorshow "Section: Miscellaneous:`nListview: " A_DefaultListView "`nName: " miscidname "`nRegistered ID: "  miscid "`nProblem: Name does not pair with the Registered ID!`nSolution: changing the Registered ID into " tmpbar "`nStatus: Solved! No need for Further User Action`n`n"
							miscid=%tmpbar%
							IniWrite,%tmpbar%,%invfile%,Miscellaneous,miscid%intsaver%
						}
						else
						{
							maperrorshow=% maperrorshow "Section: Miscellaneous:`nListview: " A_DefaultListView "`nID: " miscid "Registered Name: " miscidname "`nProblem: ID has a different name!`nSolution: changing the registered name into " tmp "`nStatus: Solved! No need for Further User Action`n`n"
							IniWrite,%tmp%,%invfile%,Miscellaneous,miscidname%intsaver%
						}
					}
					if (misclv="courierchoice") or (misclv="wardchoice") or (misclv="hudchoice") or (misclv="radcreepchoice") or (misclv="direcreepchoice") or (misclv="radtowerchoice") or (misclv="diretowerchoice") or (misclv="terrainchoice")
					{
						LV_GetText(checker,A_Index,4)
						if miscstyle<=%checker%
						{
							LV_Modify(A_Index,"Col5",miscstyle)
						}
					}
					LV_Modify(A_Index,"check")
					Break
				}
			}
			if (misclv="announcerview") or (misclv="tauntview")
			{
				GuiControl,% "+g" misclv,% misclv
			}
			else if (misclv="courierchoice") or (misclv="wardchoice") or (misclv="hudchoice") or (misclv="radcreepchoice") or (misclv="direcreepchoice") or (misclv="radtowerchoice") or (misclv="diretowerchoice") or (misclv="terrainchoice")
			{
				GuiControl,+gmiscstyle,% misclv
			}
			else
			{
				GuiControl,+gbasicmisc,% misclv
			}
		}
		IniRead,pet,%invfile%,Miscellaneous,pet
		IniRead,mappetstyle,%invfile%,Miscellaneous,mappetstyle
		if pet<>1
		{
			pet=0
		}
		GuiControl,,peton,%pet%
		GuiControl,ChooseString,petstyle,%mappetstyle%
	}
	GuiControl,+cDefault,searchnofound
	GuiControl,MainGUI:Text,searchnofound,%defaultshoutout%
	GuiControl,MainGUI:Show,searchnofound
	GuiControl,Text,errorshow,%maperrorshow%
	Gui,MainGUI:Submit,NoHide
	if errorshow<>
	{
		msgbox,16,ERROR DETECTED!,Preloading Database Complete! But There are ERRORS Detected and the Injector Distinguished them All. Check the "Advance" Section to view the ERROR Report and How the Injector Dealt them.
	}
	
	Gui, MainGUI:-Disabled 
}

savemisc:
multiplestyleparam=courierchoice,wardchoice,hudchoice,radcreepchoice,direcreepchoice,radtowerchoice,diretowerchoice,terrainchoice
multiplesourceparam=tauntview,announcerview
param=weatherchoice,multikillchoice,emblemchoice,musicchoice,cursorchoice,loadingscreenchoice,versuscreenchoice,emoticonchoice,%multiplestyleparam%,%multiplesourceparam%
;param=terrainchoice,weatherchoice,hudchoice,loadingscreenchoice,tauntview,announcerview,courierchoice,wardchoice,musicchoice,cursorchoice,multikillchoice,emblemchoice,radcreepchoice,direcreepchoice,radtowerchoice,diretowerchoice,versuscreenchoice,emoticonchoice
gosub,hideprogress
count:=0
if MyObject.FileTypeIndex=1
{
	loop,parse,param,`,
	{
		if A_DefaultListView<>%A_LoopField%
		{
			Gui, MainGUI:ListView,%A_LoopField%
		}
		saver=%A_LoopField%
		if LV_GetNext(,"Checked")>0
		{
			Loop % LV_GetCount()
			{
				if (A_Index=LV_GetNext(A_Index-1,"Checked"))
				{
					if saver=announcerview
					{
						LV_GetText(tmp,A_Index,4)
					}
					else
					{
						LV_GetText(tmp,A_Index,3)
					}
					count+=1
					
					VarWrite("miscid" count,tmp)	;VarWrite(Key := "", Value := "") ; Saves the Database Version for future version detection
					;IniWrite, %tmp%, %invfile%, Miscellaneous, miscid%count%
					
					GuiControl,Text,searchnofound,Saving Miscellaneous ID: %tmp%
					
					VarWrite("misclv" count,saver)	;VarWrite(Key := "", Value := "") ; Saves the Database Version for future version detection
					;IniWrite, %saver%, %invfile%, Miscellaneous, misclv%count%
					
					if instr(multiplestyleparam,saver) ; if a multistyle listview
					{
						LV_GetText(tmp,A_Index,5)
						
						VarWrite("miscstyle" count,tmp)	;VarWrite(Key := "", Value := "") ; Saves the Database Version for future version detection
						;IniWrite, %tmp%, %invfile%, Miscellaneous, miscstyle%count%
						
					}
					LV_GetText(tmp,A_Index,1)
					
					VarWrite("miscidname" count,tmp)	;VarWrite(Key := "", Value := "") ; Saves the Database Version for future version detection
					;IniWrite, %tmp%, %invfile%, Miscellaneous, miscidname%count%
					
				}
			}
		}
	}
	
	VarWrite("pet",peton)	;VarWrite(Key := "", Value := "") ; Saves the Database Version for future version 
	VarWrite("mappetstyle",petstyle)	;VarWrite(Key := "", Value := "") ; Saves the Database Version for future version 
	;IniWrite,%peton%, %invfile%, Miscellaneous, pet
	;IniWrite,%petstyle%, %invfile%, Miscellaneous, mappetstyle
}
else if MyObject.FileTypeIndex=2
{	
	loop,parse,param,`,
	{
		if A_DefaultListView<>%A_LoopField%
		{
			Gui, MainGUI:ListView,%A_LoopField%
		}
		saver=%A_LoopField%
		intsaver=%A_Index%
		if LV_GetNext(,"Checked")>0
		{
			Loop % LV_GetCount()
			{
				if (A_Index=LV_GetNext(A_Index-1,"Checked"))
				{
					if saver=announcerview
					{
						LV_GetText(tmp,A_Index,4)
					}
					else
					{
						LV_GetText(tmp,A_Index,3)
					}
					count+=1
					
					VarWrite("miscid" count,tmp)	;VarWrite(Key := "", Value := "")
					
					GuiControl,Text,searchnofound,Saving Miscellaneous ID: %tmp%
					
					VarWrite("misclv" count,saver)	;VarWrite(Key := "", Value := "")
					
					if instr(multiplestyleparam,saver) ; if a multistyle listview
					{
						LV_GetText(tmp,A_Index,5)
						
						VarWrite("miscstyle" count,tmp)	;VarWrite(Key := "", Value := "")
						
					}
					LV_GetText(tmp,A_Index,1)
					
					VarWrite("miscidname" count,tmp)	;VarWrite(Key := "", Value := "")
					
				}
			}
		}
	}
	
	VarWrite("pet",peton)	;VarWrite(Key := "", Value := "")
	VarWrite("mappetstyle",petstyle)	;VarWrite(Key := "", Value := "")
}
VarSetCapacity(multiplestyleparam,0),VarSetCapacity(multiplesourceparam,0),VarSetCapacity(param,0)
return

hdatasave:
gosub,leakdestroyer
Gui, MainGUI:Submit, NoHide
Gui, MainGUI:Default
if A_DefaultListView<>itemview
{
	Gui, MainGUI:ListView, itemview
}
GuiControl, MainGUI:-Redraw, itemview
if LV_GetCount()=0
{
	GuiControl,MainGUI:Text,searchnofound,%defaultshoutout%
	GuiControl,MainGUI:Show,searchnofound
	gosub,hideprogress
	
	return
}
Gui, MainGUI:+Disabled 
;FileSelectFile,invfile,S24,,Name your Database and Specify where to Save,Handy Injection Database (*.aldrin_dota2hidb)

;;; SaveFile Returns two index on an object:
;;; File			-	the inputted filename
;;; FileTypeIndex	-	the chosen Filter(Files of type dropdownlist of the explorer gui)... This will Return the number of row of the selected filetype extension
MyObject := SaveFile( [0, "Name your Database and Specify where to Save"]    ; [owner, title/prompt]
             , ""    ; RootDir\Filename
             , {"Handy Injection Database Version 1.5": "*.aldrin_dota2hidb","Handy Injection Database Version 2 (EXPERIMENTAL)": "*.aldrin_dota2hidb"}     ; Filter
			 , 1	 ; Chosen Row at Filter Dropdownlist. Take note that the arrangement IS SORTED FIRST at the beggining, so after the arrangement of filter was sorted it will next choose the "2nd" row.
             , ""    ; CustomPlaces
             , 2)    ; Options ( 2 = FOS_OVERWRITEPROMPT )
invfile := MyObject.File

if invfile<>
{
	Gui,MainGUI:Show,NA
	If SubStr(invfile,-16,17)<>.aldrin_dota2hidb
	{
		invfile=%invfile%.aldrin_dota2hidb
	}
	IfExist,%invfile%
	{
		FileSetAttrib,-R,%invfile%
		FileDelete, %invfile%
	}
	
	VarWrite( ) ; blanks Function Static "Var" variable! Always start Writing in a blank variable, avoiding Rewritings (Faster) 
	if MyObject.FileTypeIndex=1 ; if database version 1.5
	{
		;;;;; the old method
		adder:=1000/LV_GetCount()
		progress=0
		gosub,showprogress
		;FileAppend,,%invfile%
		Loop % LV_GetCount()
		{
			LV_GetText(tmp,A_Index,4)
			VarWrite("ItemID" A_Index,tmp)	;VarWrite(Key := "", Value := "") ; Saves the Database Version for future version detection
			;IniWrite, %tmp%, %invfile%, Edits, ItemID%A_Index%
			LV_GetText(tmp,A_Index,7)
			VarWrite("ItemStyle" A_Index,tmp)	;VarWrite(Key := "", Value := "") ; Saves the Database Version for future version detection
			;IniWrite, %tmp%, %invfile%, Edits, ItemStyle%A_Index%
			LV_GetText(tmp,A_Index,1)
			VarWrite("ItemIDName" A_Index,tmp)	;VarWrite(Key := "", Value := "") ; Saves the Database Version for future version detection
			;IniWrite, %tmp%, %invfile%, Edits, ItemIDName%A_Index%
			LV_GetText(tmp,A_Index,5)
			VarWrite("ItemHeroUser" A_Index,tmp)	;VarWrite(Key := "", Value := "") ; Saves the Database Version for future version detection
			;IniWrite, %tmp%, %invfile%, Edits, ItemHeroUser%A_Index%
			progress+=adder
			GuiControl,MainGUI:, MyProgress,%progress%
		}
		VarWrite("hRegisteredDirectory",LV_GetCount())	;VarWrite(Key := "", Value := "") ; Saves the Database Version for future version detection
		;IniWrite, % LV_GetCount(), %invfile%, Edits, hRegisteredDirectory
		
		if usemiscon=1
		{
			GoSub,savemisc
		}
		
		VarWrite("@DataBaseVersion!","1.5")	;VarWrite(Key := "", Value := "") ; Saves the Database Version for future version detection
		FileAppend,% VarWrite( , "GetVar"),%invfile%  ;"VarWrite( ,"GetVar")" function returns the text that will be stored in the file choosed by user, the first parameter must be omitted or blank
	}
	else if MyObject.FileTypeIndex=2 ; if database version 2
	{
		LVSData:=ListViewSave(databasemessage)
		
		if usemiscon=1
		{
			GoSub,savemisc
			VarWrite("@DataBaseVersion!",MyObject.FileTypeIndex)	;VarWrite(Key := "", Value := "") ; Saves the Database Version for future version detection
			LVSData.=VarWrite( , "GetVar") ;"VarWrite( ,"GetVar")" function returns the text that will be stored in the file choosed by user, the first parameter must be omitted or blank
		}
		FileAppend,% LVSData,% invfile
	}
	if soundon=1
	{
		SoundPlay,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\Sound\savedatacomplete.wav
	}
	;FileSetAttrib,+R,%invfile% ; protect the setting file from noobs
}
GuiControl,MainGUI:Text,searchnofound,%defaultshoutout%
GuiControl,MainGUI:Show,searchnofound
; gosub,hideprogress
GuiControl, MainGUI:+Redraw, itemview
Gui, MainGUI:-Disabled 
gosub,leakdestroyer
return

heroportrait:
porthero:=npcherodetector(porthero,dota2dir "\game\dota\scripts\npc\npc_heroes.txt")
StringGetPos, portpos, porthero,`r`n%A_Tab%%A_Tab%"Model"
StringGetPos, portpos1, porthero,",L3,%portpos%
StringGetPos, portpos, porthero,",L2,%portpos1%
StringMid,porttmp,porthero,% portpos1+2, % portpos-portpos1-1
gosub,execportrait
return

execportrait:
if InStr(portstring,porttmp)<1
{
	porttmp1=%porttmp%
	tmp1=%filecontent%
	tmp2=%itemname%
	filecontent=%contentport%
	itemname:=searchstringdetector(filecontent,"""used_by_heroes""") ; detects the hero who uses the item
	porthero=%itemname%
	filecontent=%tmp1%
	itemname=%tmp2%
	npchero:=GlobalArray["npc_heroes.txt"]
	StringGetPos, portpos, npchero,`r`n%A_Tab%"%porthero% ;"
	StringGetPos, portpos1, npchero,`r`n%A_Tab%},,%portpos%
	StringMid,porthero,npchero,% portpos+1, % portpos1-portpos-1
	StringGetPos, portpos, porthero,`r`n%A_Tab%%A_Tab%"Model"
	StringGetPos, portpos1, porthero,",L3,%portpos%
	StringGetPos, portpos, porthero,",L2,%portpos1%
	StringMid,porttmp,porthero,% portpos1+2, % portpos-portpos1-1
	
	StringGetPos, portpos2, portstring,%porttmp%
	StringGetPos, portpos1, portstring,`r`n%A_Tab%},,%portpos2%
	StringGetPos, portpos, portstring,`r`n%A_Tab%",R1,% StrLen(portstring)-portpos1
	StringGetPos, portpos1, portstring,},,%portpos1%
	StringMid,tmp1,portstring,% portpos+1, % portpos1-portpos+1
	StringReplace,tmp2,tmp1,%porttmp%,%porttmp1%,1
	StringReplace,portstring,portstring,%tmp1%,%tmp1%%tmp2%,1
}
StringGetPos, portpos, contentport,%portfind%
StringGetPos, portpos1, contentport,",L2,%portpos%
StringGetPos, portpos, contentport,`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%},,%portpos1%
StringGetPos, portpos, contentport,},,%portpos%
StringMid,toportcontent1,contentport,% portpos1+2, % portpos-portpos1

StringGetPos, portpos2, portstring,%porttmp%
StringGetPos, portpos1, portstring,`r`n%A_Tab%{`r`n,,%portpos2%
StringGetPos, portpos, portstring,`r`n%A_Tab%},,%portpos1%
StringGetPos, portpos, portstring,},,%portpos%
StringMid,fromportcontent1,portstring,% portpos1+1, % portpos-portpos1+1
StringMid,fromportcontent,portstring,% portpos2+1, % portpos-portpos2+1
StringReplace,toportcontent,fromportcontent,%fromportcontent1%,%toportcontent1%,1

StringReplace,portstring,portstring,%fromportcontent%,%toportcontent%,1
return

hselectinject:
gosub,leakdestroyer
Gui, MainGUI:Submit, NoHide
Gui, MainGUI:Default
if A_DefaultListView<>itemview
{
	Gui, MainGUI:ListView, itemview
}
ifnotexist,%A_ScriptDir%\Library\items_game.txt
{
	msgbox,16,Error!!!,"%A_ScriptDir%\Library\items_game.txt"`n`nIs Missing!!! Make sure to add the original "items_game.txt" at "%A_ScriptDir%\Library" Folder.`n`nIf you dont have an Idea how to get the original "items_game.txt" use "GCFScape.exe" or "Valve's Resource Viewer" application to access "Pak01_dir.vpk". Inside the VPK Archive`,Hit "Ctrl+F"(Find) and search for "items_game.txt". If successfully found`, extract it(items_game.txt) at "%A_ScriptDir%\Library\" Folder.
	return
}
repmocount:=repparcount:=0
ifexist,%A_ScriptDir%\Plugins\ReportLog.aldrin_report
{
	FileSetAttrib,-R,%A_ScriptDir%\Plugins\ReportLog.aldrin_report
	FileSetAttrib,-R,%A_ScriptDir%\ReportLog.aldrin_report
	FileDelete,%A_ScriptDir%\Plugins\ReportLog.aldrin_report
	FileDelete,%A_ScriptDir%\ReportLog.aldrin_report
}
fileappend,**This Report can be sent to the Creator of the Injector that can be useful for investigation about your current Injection**`r`nReportLog Location Path:`r`n%A_ScriptDir%\ReportLog.aldrin_report,%A_ScriptDir%\Plugins\ReportLog.aldrin_report
VarSetCapacity(commanddir,0),VarSetCapacity(commandextract,0),VarSetCapacity(commandrename,0),VarSetCapacity(rptlimit,0)

gosub,materialsextractor ; create a separate thread that listens to incoming material files required to extract
skinextract:=materialpid.ProcessID
VarSetCapacity(materialpid,0)
FileDelete,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\extractlist.aldrin_dota2list

ifexist,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\
{
	GuiControl,MainGUI:Text,searchnofound,Deleting pak01_dir Folder.
	FileRemoveDir,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir,1
}
IfNotExist,%A_ScriptDir%\Generated MOD\
{
	FileCreateDir, %A_ScriptDir%\Generated MOD
}
else ifexist,%A_ScriptDir%\Generated MOD\pak01_dir\
{
	GuiControl,Text,searchnofound,Deleting pak01_dir Folder at Generated MOD Folder
	FileRemoveDir,%A_ScriptDir%\Generated MOD\pak01_dir,1
}
FileCreateDir,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\
filestring2:=masterfilecontent:=GlobalArray["items_game.txt"]
portstring:=GlobalArray["portraits.txt"]
filelength:=StrLen(filestring2)
GuiControl,Text,errorshow,
VarSetCapacity(maperrorshow,0)
Gui, MainGUI:+Disabled 
if LV_GetCount()=0
{
	if usemiscon=1
	{
		Goto,hinjectjump
	}
	else
	{
		GuiControl,MainGUI:Text,searchnofound,%defaultshoutout%
		GuiControl,MainGUI:Show,searchnofound
		gosub,hideprogress
		msgbox,16,Empty Task to be Injected,No "ID's" detected on the list!
		Gui, MainGUI:-Disabled 
		return
	}
}
adder:=1000/LV_GetCount()
if soundon=1
{
	soundint:=LV_GetCount()
	gosub,initsound
}
progress:=0
IPS:=A_TickCount
StartTimer:=A_TickCount
gosub,showprogress
;LV_ModifyCol(4,"Sort Integer") ; this increases the speed when finding the items... Type of strategy, lowest id number >>> highest id number
;LV_ModifyCol(4,"SortDesc Integer") ; this increases the speed when finding the items... Type of strategy, highest id number >>> lowest id number
Loop % LV_GetCount()
{
	progress+=adder
	if soundon=1
	{
		if (progress>=250) and (soundswitch1=0) and (sound25=1)
		{
			soundswitch1=1
			SoundPlay,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\Sound\25.wav
		}
		else if (progress>=350) and (soundswitch2=0) and (sound25=1)
		{
			soundswitch2=1
			SoundPlay,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\Sound\35.wav
		}
		else if (progress>=500) and (soundswitch3=0) and (sound25=1)
		{
			soundswitch3=1
			SoundPlay,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\Sound\50.wav
		}
		else if (progress>=650) and (soundswitch4=0) and (sound25=1)
		{
			soundswitch4=1
			SoundPlay,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\Sound\65.wav
		}
		else if (progress>=750) and (soundswitch5=0) and (sound25=1)
		{
			soundswitch5=1
			SoundPlay,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\Sound\75.wav
		}
	}
	GuiControl,MainGUI:, MyProgress,%progress%
	skip=0
	LV_GetText(itemslotcheck,A_Index,2)
	LV_GetText(string1,A_Index,4)
	LV_GetText(herousercheck,A_Index,5)
	herousercheck=npc_dota_hero_%herousercheck%
	tmpstring=%string1%
	filecontent:=itemdetector(tmpstring) ;filecontent:=itemdetector(tmpstring,filestring)
	LV_GetText(numcheck,A_Index,6)
	LV_GetText(stylechecker,A_Index,7)
	contentport=%filecontent%
	gosub,extractmodel
	porthero=%herousercheck%
	if stylechecker>0
	{
		filecontent:=stylechanger(stylechecker,filecontent) ;stylechanger will change the style of all particle effects and even the model
	}
	else
	{
		StringReplace,filecontent,filecontent,`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%%A_Tab%"style"%A_Tab%%A_Tab%"0",,1
	}
	stringcontent1=%filecontent%
	if stringcontent1=
	{
		maperrorshow=%maperrorshow%Cannot Find ID number "string1"!(Resource ID)`n
		skip=1
	}
	else if InStr(stringcontent1,"prefab")=0
	{
		maperrorshow=%maperrorshow%ID number "string1" was found but sadly it is not an "ITEM"!(Resource ID)`n
		skip=1
	}
	
	;setup all extractfiles and extractnames
	StrReplace(stringcontent1,"			""model_player",,modelplayercount)
	loop %modelplayercount%
	{
		extractfile:=modelpathdetector(filecontent,A_Index-1) "_c" ;detect the item root directory and change all slash into backslash
		extractname:=SubStr(extractfile,InStr(extractfile,"\",,0)+1)
	}
	;
	
	StringReplace,stringcontent1,stringcontent1,"prefab"%A_Tab%%A_Tab%"wearable","prefab"%A_Tab%%A_Tab%"default_item",1
	Finder=%A_Tab%%A_Tab%%A_Tab%"used_by_heroes"`r`n%A_Tab%%A_Tab%%A_Tab%{`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%"%herousercheck%"%A_Tab%%A_Tab%"1"`r`n%A_Tab%%A_Tab%%A_Tab%}
	defaultslotfinder=%A_Tab%%A_Tab%%A_Tab%"prefab"%A_Tab%%A_Tab%"default_item"
	Barrier=%A_Tab%%A_Tab%}`r`n%A_Tab%%A_Tab%" ;"
	Loop
	{
		
		
		StringGetPos, pos, filestring2,%Finder%,L%A_Index%
		if pos<0
			break
		;rightpos:=filelength-pos
		;StringGetPos, pos1, filestring2,%Barrier%,,%pos%
		;StringGetPos, pos2, filestring2,%Barrier%,R1,%rightpos%
		;pos3:=pos1-pos2
		;StringMid,filecontent,filestring2,%pos2%,%pos3%
		
		filecontent:=keyworddetector(pos) ;filecontent:=keyworddetector(pos,filestring2)
		
		if InStr(filecontent,defaultslotfinder)<>0
		{
			itemname:=searchstringdetector(filecontent,"""item_slot""") ; detects the hero body slot of the item
			if itemname=%itemslotcheck%
			{
				tmpbar:=iddetector(filecontent) ;filecontent := extracted content from items_game.txt
				string2=%tmpbar%
				if filecontent=
				{
					maperrorshow=%maperrorshow%Cannot Find ID number "string2"!(Injected ID)`n
					skip=1
				}
				else if InStr(filecontent,"prefab")=0
				{
					maperrorshow=%maperrorshow%ID number "string2" was found but sadly it is not an "ITEM"!(Injected ID)`n
					skip=1
				}
				if skip=1
				{
					continue
				}
				portfind=`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%"game"`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%{
				if InStr(stringcontent1,portfind)>0
				{
					contentport=%stringcontent1%
					gosub,heroportrait
				}
				StringReplace,stringcontent1,stringcontent1,%string1%,%string2%,1
				StringReplace,masterfilecontent,masterfilecontent,%filecontent%,%stringcontent1%,1
				; measures the number of items injected per second
				Gui,MainGUI:Show,NoActivate,% floor(1000/(A_TickCount-IPS)) " Items per Second"
				IPS:=A_TickCount
				;
				
				tmp=%A_Tab%%A_Tab%%A_Tab%"model_player ;"
				tmp:=StrReplace(filecontent,tmp,tmp,modelplayercount) ; for default item
				loop %modelplayercount%
				{
					defaultloc:=modelpathdetector(filecontent,A_Index-1) ;detect the item root directory and change all slash into backslash
					defaultname:=SubStr(defaultloc,InStr(defaultloc,"\",,0)+1) "_c"
					defaultloc:=SubStr(defaultloc,1,InStr(defaultloc,"\",,0)-1)
					
					if (defaultloc<>"") and (defaultname<>"")
					{
						gosub,extractfileruncmd ; extract files via cmd
						
						;detect if the set item style has an alternative skin coloring(.vmat file)
						skinindex:=searchstringdetector(visualsdetector(stringcontent1),"`r`n				""skin""")
						if (skinindex!="Undefined") and (skinindex!="") and (skinindex>0)
						{
							; the skinextract thread listen on this file, set its parameters
							valvefile=%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\%defaultloc%\%defaultname%
							IniRead,materialscount,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\extractlist.aldrin_dota2list,Materials,materialscount,0
							materialscount++
							if !FileExist(A_Temp "\AJOM Innovations\DOTA2 MOD Master\extractlist.aldrin_dota2list")
								FileAppend,,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\extractlist.aldrin_dota2list
							IniWrite,%valvefile%,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\extractlist.aldrin_dota2list,Materials,valvefile%materialscount%
							IniWrite,%skinindex%,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\extractlist.aldrin_dota2list,Materials,skinindex%materialscount%
							IniWrite,%materialscount%,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\extractlist.aldrin_dota2list,Materials,materialscount
						}
						;
						; measures the number of items injected per second
						Gui,MainGUI:Show,NoActivate,% floor(1000/(A_TickCount-IPS)) " Items per Second"
						IPS:=A_TickCount
						;
					}
				}
				Break
			}
		}
		If ErrorLevel=1 ; hunt this errorlevel
		{
			Break
		}
	}
}
if masterfilecontent=%filestring2%
{
	GuiControl,MainGUI:Text,searchnofound,%defaultshoutout%
	GuiControl,MainGUI:Show,searchnofound
	Gui,MainGUI:Show,NA,AJOM's Dota 2 MOD Master
	gosub,hideprogress
	
	msgbox,16,Empty Task to be Injected,No present actived/valid "ID's" detected on the list!
	Gui, MainGUI:-Disabled 
	if soundon=1
	{
		SoundPlay,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\Sound\finishederror.wav
	}
	return
}
hinjectjump:
gosub,hideprogress
if usemiscon=1
{
	GoSub,execmisc
}
GuiControl,Text,errorshow,%maperrorshow%
if autovpkon=0
{
	GoSub,movepak
}
else
{
	GoSub,createvpk
}
Gui,MainGUI:Submit,NoHide

tmpr:=Format_Msec(A_TickCount-StartTimer)
IniWrite,%tmpr%,%A_ScriptDir%\Plugins\ReportLog.aldrin_report,Summary,TotalOperationTime
IniWrite,%cmdmaxinstances%,%A_ScriptDir%\Plugins\ReportLog.aldrin_report,Settings,ThreadsCount

FileSetAttrib,-R,%A_ScriptDir%\ReportLog.aldrin_report ; unprotect
FileMove,%A_ScriptDir%\Plugins\ReportLog.aldrin_report,%A_ScriptDir%,1
fileread,tmp1,%A_ScriptDir%\ReportLog.aldrin_report
FileSetAttrib,+R,%A_ScriptDir%\ReportLog.aldrin_report ; protect the file from noobs

GuiControl,Text,reportshow,%tmp1%
if errorshow<>
{
	if soundon=1
	{
		SoundPlay,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\Sound\finishederror.wav
	}
	msgbox,16,ERROR DETECTED!,Injection Complete! But There are ERRORS Detected and the Injector Distinguished them All. Check the "Advance" Section to view the ERROR Report and How the Injector Dealt them.
}
else
{
	if soundon=1
	{
		SoundPlay,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\Sound\OperationFinished.wav
	}
}
GuiControl,MainGUI:Text,searchnofound,%defaultshoutout%
GuiControl,MainGUI:Show,searchnofound
Gui,MainGUI:Show,NA,AJOM's Dota 2 MOD Master
Gui, MainGUI:-Disabled 
gosub,leakdestroyer
return

doitems:
Critical
if A_GuiEvent = RightClick
{
	Gui, MainGUI:Default
	if A_DefaultListView<>showitems
	{
		Gui, MainGUI:ListView, showitems
	}
	loop 5
	{
		LV_GetText(del%A_Index%,A_EventInfo,A_Index)
	}
	LV_GetText(stylescount,A_EventInfo,6)
	LV_GetText(countcheck,A_EventInfo,7)
	if stylescount>%countcheck%
	{
		countcheck+=1
	}
	else
	{
		countcheck=0
	}
	LV_Modify(A_EventInfo,"Select" "Col7",,,,,,,countcheck)
	if A_DefaultListView<>itemview
	{
		Gui, MainGUI:ListView, itemview
	}
	loop % LV_GetCount()
	{
		delint=%A_Index%
		loop 5
		{
			LV_GetText(del1%A_Index%,delint,A_Index)
		}
		if del11=%del1%
		{
			if del12=%del2%
			{
				if del13=%del3%
				{
					if del14=%del4%
					{
						if del15=%del5%
						{
							LV_Modify(A_Index,"Select" "Col7",,,,,,,countcheck)
						}
					}
				}
			}
		}
	}
}
if InStr(ErrorLevel, "C", true)
{
	Gui, MainGUI:Default
	if A_DefaultListView<>showitems
	{
		Gui, MainGUI:ListView, showitems
	}
	LV_GetText(itemat1,A_EventInfo,2)
	Loop % LV_GetCount()
	{
		if A_DefaultListView<>showitems
		{
			Gui, MainGUI:ListView, showitems
		}
		if A_Index<>%A_EventInfo%
		{
			if A_Index= % LV_GetNext(A_Index-1,"Checked")
			{
				LV_GetText(itemat,A_Index,2)
				if itemat1=%itemat%
				{
					LV_Modify(A_Index,"-Check")
					delsaver=%A_Index%
					GoSub,autoshowitemsdelete
				}
			}
		}
	}
	if A_DefaultListView<>showitems
	{
		Gui, MainGUI:ListView, showitems
	}
	loop 7
	{
		LV_GetText(itemat%A_Index%,A_EventInfo,A_Index)
	}
	if A_DefaultListView<>itemview
	{
		Gui, MainGUI:ListView, itemview
	}
	LV_Add(, itemat1,itemat2,itemat3,itemat4,itemat5,itemat6,itemat7)
	GoSub,lvautosize
	LV_ModifyCol(2,"Sort")
}
else if InStr(ErrorLevel, "c", true)
{
	delsaver=%A_EventInfo%
	GoSub,autoshowitemsdelete
}
return

autoshowitemsdelete:
Gui, MainGUI:Default
if A_DefaultListView<>showitems
{
	Gui, MainGUI:ListView, showitems
}
loop 5
{
	LV_GetText(del%A_Index%,delsaver,A_Index)
}
if A_DefaultListView<>itemview
{
	Gui, MainGUI:ListView, itemview
}
loop % LV_GetCount()
{
	delint=%A_Index%
	loop 5
	{
		LV_GetText(del1%A_Index%,delint,A_Index)
	}
	if del11=%del1%
	{
		if del12=%del2%
		{
			if del13=%del3%
			{
				if del14=%del4%
				{
					if del15=%del5%
					{
						LV_Delete(delint)
					}
				}
			}
		}
	}
}
return

hdatabrowse: ;;;When user clicks browse database at handy injection section
Gui MainGUI:+OwnDialogs
gosub,leakdestroyer
FileSelectFile,invfile,3,,.aldrin_dota2hidb,*.aldrin_dota2hidb
If SubStr(invfile,-16,17)=.aldrin_dota2hidb
{
	timeconsumed:=A_TickCount
	GuiControl,Text,hdatadirview,%invfile%||
	Gui,MainGUI:Submit,NoHide
	Gui, MainGUI:Default
	if A_DefaultListView<>itemview
	{
		Gui, MainGUI:ListView,itemview
	}
	LV_ClearAll()
	VarSetCapacity(maperrorshow,0)
	GuiControl,Text,errorshow,
	FileRead,FileData,%hdatadirview%
	VarWrite(,FileData) ; sets the content of var to this content
	VarRead(,FileData) ; remember the contents of the variable and store to "static Var" that is inspected by varread
	hdatareload(hdatadirview)
	checkdetector() ; check any field that exist on the listview "itemview"
	if usemiscon=1 ; use miscellaneous section on future injection is checked, reload all misc resources
	{
		reloadmisc(invfile) ; ;Scans the database then put a checkmark on each miscellaneous it uses
	}
	
	tmpr:=VarWrite(,"GetVar")
	if (FileData!=tmpr) and (tmpr!="") ; renew the database
	{
		FileSetAttrib,-R,%hdatadirview%
		FileDelete,%hdatadirview%
		FileAppend,%tmpr%,%hdatadirview%  ;"VarWrite( ,"GetVar")" function returns the text that will be stored in the file choosed by user, the first parameter must be omitted or blank
		FileSetAttrib,+RH,%hdatadirview%
	}
	
	GuiControlGet,errorshow,,errorshow
	if errorshow<>
	{
		msgbox,16,ERROR DETECTED!,Preloading Database Complete! But There are ERRORS Detected and the Injector Distinguished them All. Check the "Advance" Section to view the ERROR Report and How the Injector Dealt them.
	}
	
	GuiControl,MainGUI:Text,searchnofound,%defaultshoutout%
	GuiControl,MainGUI:Show,searchnofound
	Gui, MainGUI:-Disabled
	Gui,MainGUI:Show,NoActivate,% (A_TickCount-timeconsumed)/1000 "s Preloading Time"
	SetTimer,restorguititle,-5000,-1
	
	
	if soundon=1
	{
		SoundPlay,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\Sound\loaddatacomplete.wav
	}
}
gosub,leakdestroyer
return

restorguititle: ;;; Restore the Title of the GUI into the default one
Gui,MainGUI:Show,NA,AJOM's Dota 2 MOD Master
return

;;; hdatareload function will preload the database of handy injection section listview
hdatareload(hdatadirview) {
	Gui, MainGUI:Default
	Gui, MainGUI:+Disabled 
	GuiControl,MainGUI:Hide,searchnofound
	if A_DefaultListView<>itemview
	{
		Gui, MainGUI:ListView, itemview
	}
	GuiControl, MainGUI:-Redraw, itemview
	FileRead,FileData,%hdatadirview%
	VarWrite(,FileData) ; sets the content of var to this content
	VarRead(,FileData) ; remember the contents of the variable and store to "static Var" that is inspected by varread
	if VarRead("@DataBaseVersion!")=2
	{
		VarRead(,ListViewLoad(FileData,databasemessage))	;the function loads the table and automatically returns Extra text found from the loaded file (Extra text found will be stored in "ExtraTextReturned" variable) and stores it at "static var" of varread
		
		;;; detects if the listview header was corrupted
		headercorrupted:=0
		param=Item Name|Item Slot|Rarity|Item ID|Used by|Styles Count|Active Style
		loop,parse,param,|
		{
			LV_GetText(tmp,0,A_Index)
			if tmp<>%A_LoopField%
			{
				LV_ModifyCol(A_Index,"AutoHdr",A_LoopField)
				maperrorshow=% maperrorshow "Section: Handy Injection`nSub-Section: Used Items Database`nControl: Listview`nColumn: " A_Index "`nRegistered Header Name: " tmp "`nProblem: DATABASE MIGHT BE CORRUPTED!!! The Database's Column " A_Index " Header Name does not match with the ListView Header Name. The Results on the Listview might show SCRAMBLED Informations on each rows that does not match on their specific Columns.`nStatus: UNKNOWN! DOTA2 MOD Master did not include this cosmetic item on the list.`nSolution: At ""Hero Items Selection"" Subsection, track down the cosmetic item and recheck that information.`n`n"
				headercorrupted=1 ; tell the system that the listview header was corrupted
			}
		}
		if headercorrupted>=1
		{
			gosub,VerifyListviewIntegrity ;if the listview header is corrupted, automatically verify the informations. 
		}
		;else
		;{
		;	SetTimer,timedverinteg,-1,-500 ; low priority integrity verification
		;	gosub,dummy
		;}
		;;;
	}
	else if VarRead("@DataBaseVersion!")=1.5 ; if version 1.5, the recommended version
	{
		hRegisteredDirectory:=VarRead("hRegisteredDirectory")
		if !(hRegisteredDirectory>=1)
		{
			hRegisteredDirectory=0
			Loop
			{
				if !InStr(FileData,"ItemID" A_Index) and !InStr(FileData,"ItemIDName" A_Index) and !InStr(FileData,"ItemHeroUser" A_Index)
				{
					hRegisteredDirectory:=A_Index-1
					VarWrite("hRegisteredDirectory",hRegisteredDirectory)	;VarWrite(Key := "", Value := "") ; Saves the Database Version for future version detection
					;IniWrite,%hRegisteredDirectory%,%hdatadirview%,Edits,hRegisteredDirectory
					Break
				}
			}
		}
		adder:=1000/hRegisteredDirectory
		gosub,showprogress
		progress=0
		filestring:=GlobalArray["items_game.txt"]
		Loop, %hRegisteredDirectory%
		{
			ItemID:=VarRead("ItemID" A_Index)
			ItemIDName:=VarRead("ItemIDName" A_Index)
			ItemStyle:=VarRead("ItemStyle" A_Index)
			;IniRead,ItemID,%hdatadirview%,Edits,ItemID%A_Index%
			;IniRead,ItemIDName,%hdatadirview%,Edits,ItemIDName%A_Index%
			;IniRead,ItemStyle,%hdatadirview%,Edits,ItemStyle%A_Index%
			mapinjectfrom:=ItemID
			VarSetCapacity(checker,0),VarSetCapacity(varlength,0),VarSetCapacity(zeroloop,0)
			varlength:=StrLen(mapinjectfrom)
			Loop, %varlength%
			{
				zeroloop=0%zeroloop%
				StringLeft,checker,mapinjectfrom,%A_Index%
				if checker=%zeroloop%
				{
					StringTrimLeft,mapinjectfrom,mapinjectfrom,%A_Index%
				}
			}
			filecontent:=itemdetector(ItemID) ;filecontent:=itemdetector(tmpstring,filestring)
			if filecontent=
			{
				tmpbar:=newiddetector(ItemIDName) ;tmpbar:=newiddetector(tmpstring,filestring) ; tmpstring:=item name , filestring:=items_game.txt
				ItemHeroUser:=VarRead("ItemHeroUser" A_Index)
				;IniRead,ItemHeroUser,%hdatadirview%,Edits,ItemHeroUser%A_Index%
				if tmpbar<>
				{
					maperrorshow=% maperrorshow "Section: Handy Injection`nHero: " ItemHeroUser "`nRegistered Item Name: " ItemIDName "`nRegistered ID: " ItemID "`nCurrent Style: " ItemStyle "`nProblem: Registered ID does not exist! But the Registered Name was found.`nSolution: Analyzing the Registered Name information at items_game.txt, FOUND ID " tmpbar ".`nStatus: Solved! DOTA2 MOD Master Changed the Registered ID into " tmpbar ", No need for Further User Action.`n`n"
					ItemID=%tmpbar%
					VarWrite("ItemID" A_Index,tmpbar)	;VarWrite(Key := "", Value := "") ; Saves the Database Version for future version detection
					;IniWrite,%tmpbar%,%hdatadirview%,Edits,ItemID%A_Index%
				}
				else
				{
					maperrorshow=% maperrorshow "Section: Handy Injection`nHero: " ItemHeroUser "`nRegistered ID: " ItemID "`nRegistered Item Name: " ItemIDName "`nCurrent Style: " ItemStyle "`nProblem: Registered ID nor the Registered Name for the Hero does not Exist! It might not be a valid item that has prefab and a Hero User`nStatus: UNSOLVED! DOTA2 MOD Master did not include this cosmetic item on the list.`nSolution: At ""Hero Items Selection"" Subsection, track down the cosmetic item and recheck that information.`n`n"
					continue
				}
			}
			itemname:=searchstringdetector(filecontent,"""name""") ; detects the name of the item
			if ItemIDName<>%itemname%
			{
				tmpstring:=ItemIDName
				tmpbar:=newiddetector(tmpstring) ;tmpbar:=newiddetector(tmpstring,filestring) ; tmpstring:=item name , filestring:=items_game.txt
				ItemHeroUser:=VarRead("ItemHeroUser" A_Index)
				;IniRead,ItemHeroUser,%hdatadirview%,Edits,ItemHeroUser%A_Index%
				if tmpbar<>
				{
					maperrorshow=% maperrorshow "Section: Handy Injection`nHero: " ItemHeroUser "`nRegistered Item Name: " ItemIDName "`nRegistered ID: " ItemID "`nCurrent Style: " ItemStyle "`nProblem: Hero Item Name Of the Registered ID from items_game.txt does not pair with the Database's Registered Item Name of the Hero`nSolution: Using the Hero User and the Item Name, Identify the item ID of this item. Found " tmpbar ".`nStatus: Solved! DOTA2 MOD Master Changed the Registered ID into " tmpbar ", No need for Further User Action.`n`n"
					ItemID=%tmpbar%
					VarWrite("ItemID" A_Index,tmpbar)	;VarWrite(Key := "", Value := "") ; Saves the Database Version for future version detection
					;IniWrite,%tmpbar%,%hdatadirview%,Edits,ItemID%A_Index%
				}
				else
				{
					maperrorshow=% maperrorshow "Section: Handy Injection`nHero: " ItemHeroUser "`nRegistered Item Name: " ItemIDName "`nRegistered ID: " ItemID "`nProblem: Registered ID for the Hero has a different cosmetic name at items_game.txt, it was does not match the Database's Registered Item Name`nSolution: Changing the Registered Name into " itemname ".`nStatus: Solved! No need for Further User Action`n`n"
					VarWrite("ItemIDName" A_Index,itemname)	;VarWrite(Key := "", Value := "") ; Saves the Database Version for future version detection
					;IniWrite,%itemname%,%hdatadirview%,Edits,ItemIDName%A_Index%
				}
			}
			tmpname1:=searchstringdetector(filecontent,"""name"""),tmpname2:=searchstringdetector(filecontent,"""item_slot"""),tmpname3:=searchstringdetector(filecontent,"""item_rarity"""),tmpname4:=searchstringdetector(filecontent,"""used_by_heroes""")
			StringTrimLeft, tmpname4, tmpname4, 14
			stylescount:=stylecountdetector(filecontent) ;counts the number of allowed styles of an item
			LV_Add(, tmpname1, tmpname2,tmpname3,ItemID,tmpname4,stylescount,ItemStyle)
			;LV_ModifyCol(5,"Sort")
			progress+=adder
			GuiControl,MainGUI:, MyProgress,%progress%
		}
	}
	else ;;; if version 1(oldest version) the slowest one but the most accurate one
	{
		IniRead,hRegisteredDirectory,%hdatadirview%,Edits,hRegisteredDirectory
		if !(hRegisteredDirectory>=1)
		{
			hRegisteredDirectory=0
			Loop
			{
				if !InStr(FileData,"ItemID" A_Index) and !InStr(FileData,"ItemIDName" A_Index) and !InStr(FileData,"ItemHeroUser" A_Index)
				{
					hRegisteredDirectory:=A_Index-1
					IniWrite,%hRegisteredDirectory%,%hdatadirview%,Edits,hRegisteredDirectory
					Break
				}
			}
		}
		adder:=1000/hRegisteredDirectory
		gosub,showprogress
		progress=0
		filestring:=GlobalArray["items_game.txt"]
		Loop, %hRegisteredDirectory%
		{
			IniRead,ItemID,%hdatadirview%,Edits,ItemID%A_Index%
			IniRead,ItemIDName,%hdatadirview%,Edits,ItemIDName%A_Index%
			IniRead,ItemStyle,%hdatadirview%,Edits,ItemStyle%A_Index%
			mapinjectfrom:=ItemID
			VarSetCapacity(checker,0),VarSetCapacity(varlength,0),VarSetCapacity(zeroloop,0)
			varlength:=StrLen(mapinjectfrom)
			Loop, %varlength%
			{
				zeroloop=0%zeroloop%
				StringLeft,checker,mapinjectfrom,%A_Index%
				if checker=%zeroloop%
				{
					StringTrimLeft,mapinjectfrom,mapinjectfrom,%A_Index%
				}
			}
			filecontent:=itemdetector(ItemID) ;filecontent:=itemdetector(tmpstring,filestring)
			if filecontent=
			{
				tmpbar:=newiddetector(ItemIDName) ;tmpbar:=newiddetector(tmpstring,filestring) ; tmpstring:=item name , filestring:=items_game.txt
				IniRead,ItemHeroUser,%hdatadirview%,Edits,ItemHeroUser%A_Index%
				if tmpbar<>
				{
					maperrorshow=% maperrorshow "Section: Handy Injection`nHero: " ItemHeroUser "`nRegistered Item Name: " ItemIDName "`nRegistered ID: " ItemID "`nCurrent Style: " ItemStyle "`nProblem: Registered ID does not exist! But the Registered Name was found.`nSolution: Analyzing the Registered Name information at items_game.txt, FOUND ID " tmpbar ".`nStatus: Solved! DOTA2 MOD Master Changed the Registered ID into " tmpbar ", No need for Further User Action.`n`n"
					ItemID=%tmpbar%
					IniWrite,%tmpbar%,%hdatadirview%,Edits,ItemID%A_Index%
				}
				else
				{
					maperrorshow=% maperrorshow "Section: Handy Injection`nHero: " ItemHeroUser "`nRegistered ID: " ItemID "`nRegistered Item Name: " ItemIDName "`nCurrent Style: " ItemStyle "`nProblem: Registered ID nor the Registered Name for the Hero does not Exist! It might not be a valid item that has prefab and a Hero User`nStatus: UNSOLVED! DOTA2 MOD Master did not include this cosmetic item on the list.`nSolution: At ""Hero Items Selection"" Subsection, track down the cosmetic item and recheck that information.`n`n"
					continue
				}
			}
			itemname:=searchstringdetector(filecontent,"""name""") ; detects the name of the item
			if ItemIDName<>%itemname%
			{
				tmpstring:=ItemIDName
				tmpbar:=newiddetector(tmpstring) ;tmpbar:=newiddetector(tmpstring,filestring) ; tmpstring:=item name , filestring:=items_game.txt
				IniRead,ItemHeroUser,%hdatadirview%,Edits,ItemHeroUser%A_Index%
				if tmpbar<>
				{
					maperrorshow=% maperrorshow "Section: Handy Injection`nHero: " ItemHeroUser "`nRegistered Item Name: " ItemIDName "`nRegistered ID: " ItemID "`nCurrent Style: " ItemStyle "`nProblem: Hero Item Name Of the Registered ID from items_game.txt does not pair with the Database's Registered Item Name of the Hero`nSolution: Using the Hero User and the Item Name, Identify the item ID of this item. Found " tmpbar ".`nStatus: Solved! DOTA2 MOD Master Changed the Registered ID into " tmpbar ", No need for Further User Action.`n`n"
					ItemID=%tmpbar%
					IniWrite,%tmpbar%,%hdatadirview%,Edits,ItemID%A_Index%
				}
				else
				{
					maperrorshow=% maperrorshow "Section: Handy Injection`nHero: " ItemHeroUser "`nRegistered Item Name: " ItemIDName "`nRegistered ID: " ItemID "`nProblem: Registered ID for the Hero has a different cosmetic name at items_game.txt, it was does not match the Database's Registered Item Name`nSolution: Changing the Registered Name into " itemname ".`nStatus: Solved! No need for Further User Action`n`n"
					IniWrite,%itemname%,%hdatadirview%,Edits,ItemIDName%A_Index%
				}
			}
			tmpname1:=searchstringdetector(filecontent,"""name"""),tmpname2:=searchstringdetector(filecontent,"""item_slot"""),tmpname3:=searchstringdetector(filecontent,"""item_rarity"""),tmpname4:=searchstringdetector(filecontent,"""used_by_heroes""")
			StringTrimLeft, tmpname4, tmpname4, 14
			stylescount:=stylecountdetector(filecontent) ;counts the number of allowed styles of an item
			LV_Add(, tmpname1, tmpname2,tmpname3,ItemID,tmpname4,stylescount,ItemStyle)
			;LV_ModifyCol(5,"Sort")
			progress+=adder
			GuiControl,MainGUI:, MyProgress,%progress%
		}
	}
	GuiControl,Text,errorshow,%maperrorshow%
	gosub,hideprogress
	GoSub,lvautosize
	GuiControl, MainGUI:+Redraw, itemview
	GuiControl,MainGUI:Show,searchnofound
}

dummy:
;msgbox here %A_DefaultListView%
SetTimer,timedverinteg,-1,-500 ; low priority integrity verification
return

timedverinteg: ; indicates that the function is low priority timer
if A_DefaultListView<>itemview
{
	Gui, MainGUI:ListView, itemview
}
;msgbox shit %A_DefaultListView%
timedverinteg()
return

timedverinteg() {
adder:=1000/LV_GetCount(),progress:=0
gosub,showprogress
filestring:=GlobalArray["items_game.txt"]
DataArray:={} ; decalares that the property of this array is associative 
if A_DefaultListView<>itemview
{
	Gui, MainGUI:ListView, itemview
}
Loop % LV_GetCount() ; constructs the data array
{
	LV_GetText(ItemIDName,A_Index,1),LV_GetText(ItemID,A_Index,4),LV_GetText(ItemHeroUser,A_Index,5)
	DataArray[ItemIDName%A_Index%]:=ItemIDName,DataArray[ItemID%A_Index%]:=ItemID,DataArray[ItemHeroUser%A_Index%]:=ItemHeroUser
}
;do not attempt to merge the above loop to below loop
;msgbox % LV_GetCount()
loop % LV_GetCount()
{
	NewItemID= ; start the detection for new item ID as blank, so that if later it was changed, the switch detection that the ID was changed will be true
	filecontent:=itemdetector(DataArray[ItemID%A_Index%]) ;filecontent:=itemdetector(ItemID,filestring)
	if filecontent=
	{
		tmpbar:=newiddetector(DataArray[ItemIDName%A_Index%]) ;tmpbar:=newiddetector(DataArray[ItemIDName%A_Index%],filestring) ; tmpstring:=item name , filestring:=items_game.txt
		if tmpbar<>
		{
			maperrorshow=% maperrorshow "Section: Handy Injection`nHero: " DataArray[ItemHeroUser%A_Index%] "`nRegistered Item Name: " DataArray[ItemIDName%A_Index%] "`nRegistered ID: " DataArray[ItemID%A_Index%] "`nCurrent Style: " ItemStyle "`nProblem: Registered ID does not exist! But the Registered Name was found.`nSolution: Analyzing the Registered Name information at items_game.txt, FOUND ID " tmpbar ".`nStatus: Solved! DOTA2 MOD Master Changed the Registered ID into " tmpbar ", No need for Further User Action.`n`n"
			NewItemID=%tmpbar%
		}
		else
		{
			maperrorshow=% maperrorshow "Section: Handy Injection`nHero: " DataArray[ItemHeroUser%A_Index%] "`nRegistered ID: " DataArray[ItemID%A_Index%] "`nRegistered Item Name: " DataArray[ItemIDName%A_Index%] "`nCurrent Style: " ItemStyle "`nProblem: Registered ID nor the Registered Name for the Hero does not Exist! It might not be a valid item that has prefab and a Hero User`nStatus: UNSOLVED! DOTA2 MOD Master did not include this cosmetic item on the list.`nSolution: At ""Hero Items Selection"" Subsection, track down the cosmetic item and recheck that information.`n`n"
			continue
		}
	}
	itemname:=searchstringdetector(filecontent,"""name""") ; detects the name of the item
	if DataArray[ItemIDName%A_Index%]<>%itemname%
	{
		tmpbar:=newiddetector(DataArray[ItemIDName%A_Index%]) ;tmpbar:=newiddetector(DataArray[ItemIDName%A_Index%],filestring) ; tmpstring:=item name , filestring:=items_game.txt
		if tmpbar<>
		{
			maperrorshow=% maperrorshow "Section: Handy Injection`nHero: " DataArray[ItemHeroUser%A_Index%] "`nRegistered Item Name: " DataArray[ItemIDName%A_Index%] "`nRegistered ID: " DataArray[ItemID%A_Index%] "`nCurrent Style: " ItemStyle "`nProblem: Hero Item Name Of the Registered ID from items_game.txt does not pair with the Database's Registered Item Name of the Hero`nSolution: Using the Hero User and the Item Name, Identify the item ID of this item. Found " tmpbar ".`nStatus: Solved! DOTA2 MOD Master Changed the Registered ID into " tmpbar ", No need for Further User Action.`n`n"
			NewItemID=%tmpbar%
		}
		else
		{
			maperrorshow=% maperrorshow "Section: Handy Injection`nHero: " DataArray[ItemHeroUser%A_Index%] "`nRegistered Item Name: " DataArray[ItemIDName%A_Index%] "`nRegistered ID: " DataArray[ItemID%A_Index%] "`nProblem: Registered ID for the Hero has a different cosmetic name at items_game.txt, it was does not match the Database's Registered Item Name`nSolution: Changing the Registered Name into " itemname ".`nStatus: Solved! No need for Further User Action`n`n"
		}
	}
	if NewItemID= ; there is no problem on the cosmetic item
	{
		NewItemID:=DataArray[ItemID%A_Index%]
	}
	tmpname1:=searchstringdetector(filecontent,"""name"""),tmpname2:=searchstringdetector(filecontent,"""item_slot"""),tmpname3:=searchstringdetector(filecontent,"""item_rarity"""),tmpname4:=searchstringdetector(filecontent,"""used_by_heroes""") ; define its field which are informations for the user for the listview
	StringTrimLeft, tmpname4, tmpname4, 14 ; remove "npc_dota_hero_"(14 characters on the left side)
	stylescount:=stylecountdetector(filecontent) ;counts the number of allowed styles of an item
	if (DataArray[ItemIDName%A_Index%]<>tmpname1) or (ItemSlot<>tmpname2) or (ItemRarity<>tmpname3) or (DataArray[ItemID%A_Index%]<>NewItemID) or (tmpname4<>DataArray[ItemHeroUser%A_Index%]) or (stylescount<>ItemCountStyle) ; detects when there was an error on the any informations on the listview
	{
		if A_DefaultListView<>itemview
		{
			Gui, MainGUI:ListView, itemview
		}
		LV_Modify(A_Index,, tmpname1, tmpname2,tmpname3,NewItemID,tmpname4,stylescount,ItemStyle) ; update informations on our listview
	}
	progress+=adder
	GuiControl,MainGUI:, MyProgress,%progress%
}
;msgbox finish
;LV_ModifyCol(5,"Sort") ; sorts the column 5 which is "hero user" column into a - z - A - Z - 0 - 9 - special chars
GoSub,lvautosize ; Fit all contents of the 7 columns including the header
GuiControl,Text,errorshow,%maperrorshow%
gosub,hideprogress
}

VerifyListviewIntegrity:
Gui, MainGUI:Default
Gui, MainGUI:+Disabled 
GuiControl,MainGUI:Hide,searchnofound
if A_DefaultListView<>itemview
{
	Gui, MainGUI:ListView, itemview
}
GuiControl, MainGUI:-Redraw, itemview
GuiControl,MainGUI:Text,searchnofound,
Gui,MainGUI:Submit,NoHide
VerifyListviewIntegrity()
GuiControl,MainGUI:Text,searchnofound,%defaultshoutout%
GuiControl,MainGUI:Show,searchnofound
GuiControl, MainGUI:+Redraw, itemview
Gui, MainGUI:-Disabled
return

VerifyListviewIntegrity()
{
	adder:=1000/LV_GetCount(),progress:=0
	gosub,showprogress
	filestring:=GlobalArray["items_game.txt"]
	Loop % LV_GetCount()
	{
		LV_GetText(ItemIDName,A_Index,1),LV_GetText(ItemSlot,A_Index,2),LV_GetText(ItemRarity,A_Index,3),LV_GetText(ItemID,A_Index,4),LV_GetText(ItemHeroUser,A_Index,5),LV_GetText(ItemCountStyle,A_Index,6),LV_GetText(ItemStyle,A_Index,7)
		NewItemID= ; start the detection for new item ID as blank, so that if later it was changed, the switch detection that the ID was changed will be true
		filecontent:=itemdetector(ItemID) ;filecontent:=itemdetector(ItemID,filestring)
		if filecontent=
		{
			tmpbar:=newiddetector(ItemIDName) ;tmpbar:=newiddetector(ItemIDName,filestring) ; tmpstring:=item name , filestring:=items_game.txt
			if tmpbar<>
			{
				maperrorshow=% maperrorshow "Section: Handy Injection`nHero: " ItemHeroUser "`nRegistered Item Name: " ItemIDName "`nRegistered ID: " ItemID "`nCurrent Style: " ItemStyle "`nProblem: Registered ID does not exist! But the Registered Name was found.`nSolution: Analyzing the Registered Name information at items_game.txt, FOUND ID " tmpbar ".`nStatus: Solved! DOTA2 MOD Master Changed the Registered ID into " tmpbar ", No need for Further User Action.`n`n"
				NewItemID=%tmpbar%
			}
			else
			{
				maperrorshow=% maperrorshow "Section: Handy Injection`nHero: " ItemHeroUser "`nRegistered ID: " ItemID "`nRegistered Item Name: " ItemIDName "`nCurrent Style: " ItemStyle "`nProblem: Registered ID nor the Registered Name for the Hero does not Exist! It might not be a valid item that has prefab and a Hero User`nStatus: UNSOLVED! DOTA2 MOD Master did not include this cosmetic item on the list.`nSolution: At ""Hero Items Selection"" Subsection, track down the cosmetic item and recheck that information.`n`n"
				continue
			}
		}
		itemname:=searchstringdetector(filecontent,"""name""") ; detects the name of the item
		if ItemIDName<>%itemname%
		{
			tmpbar:=newiddetector(ItemIDName) ;tmpbar:=newiddetector(ItemIDName,filestring) ; tmpstring:=item name , filestring:=items_game.txt
			if tmpbar<>
			{
				maperrorshow=% maperrorshow "Section: Handy Injection`nHero: " ItemHeroUser "`nRegistered Item Name: " ItemIDName "`nRegistered ID: " ItemID "`nCurrent Style: " ItemStyle "`nProblem: Hero Item Name Of the Registered ID from items_game.txt does not pair with the Database's Registered Item Name of the Hero`nSolution: Using the Hero User and the Item Name, Identify the item ID of this item. Found " tmpbar ".`nStatus: Solved! DOTA2 MOD Master Changed the Registered ID into " tmpbar ", No need for Further User Action.`n`n"
				NewItemID=%tmpbar%
			}
			else
			{
				maperrorshow=% maperrorshow "Section: Handy Injection`nHero: " ItemHeroUser "`nRegistered Item Name: " ItemIDName "`nRegistered ID: " ItemID "`nProblem: Registered ID for the Hero has a different cosmetic name at items_game.txt, it was does not match the Database's Registered Item Name`nSolution: Changing the Registered Name into " itemname ".`nStatus: Solved! No need for Further User Action`n`n"
			}
		}
		if NewItemID= ; there is no problem on the cosmetic item
		{
			NewItemID:=ItemID
		}
		tmpname1:=searchstringdetector(filecontent,"""name"""),tmpname2:=searchstringdetector(filecontent,"""item_slot"""),tmpname3:=searchstringdetector(filecontent,"""item_rarity"""),tmpname4:=searchstringdetector(filecontent,"""used_by_heroes""") ; define its field which are informations for the user for the listview
		StringTrimLeft, tmpname4, tmpname4, 14 ; remove "npc_dota_hero_"(14 characters on the left side)
		stylescount:=stylecountdetector(filecontent) ;counts the number of allowed styles of an item
		if (ItemIDName<>tmpname1) or (ItemSlot<>tmpname2) or (ItemRarity<>tmpname3) or (ItemID<>NewItemID) or (tmpname4<>ItemHeroUser) or (stylescount<>ItemCountStyle) ; detects when there was an error on the any informations on the listview
		{
			LV_Modify(A_Index,, tmpname1, tmpname2,tmpname3,NewItemID,tmpname4,stylescount,ItemStyle) ; update informations on our listview
		}
		progress+=adder
		GuiControl,MainGUI:, MyProgress,%progress%
	}
	;LV_ModifyCol(5,"Sort") ; sorts the column 5 which is "hero user" column into a - z - A - Z - 0 - 9 - special chars
	GoSub,lvautosize ; Fit all contents of the 7 columns including the header
	GuiControl,Text,errorshow,%maperrorshow%
	gosub,hideprogress
	if (maperrorshow!="")
	{
		msgbox,36,ListView Integrity Report,Item List has problems`, would you like to see the ERROR Log?
		IfMsgBox Yes
		{
			GuiControl,ChooseString,OuterTab,Advanced
			gosub,SelectOuterTab
		}
		Gui,MainGUI:Show,NA
	}
}

generateheroitems()
{
	;Gui, MainGUI:Submit, NoHide
	Gui, MainGUI:Default
	Gui, MainGUI:+Disabled 
	GUIControlGet,herochoice,,herochoice
	if A_DefaultListView<>showitems
	{
		Gui, MainGUI:ListView, showitems
	}
	GuiControl, MainGUI:-Redraw, showitems
	
	LV_ClearAll()
	if instr(GlobalArray["herolist"],herochoice)
	{
		GuiControl,-g, showitems
		GuiControl,+cBlue,searchnofound
		
		loopsbeforetrim:=9 ; the fastest averaging tests I conducted was trimming items_game.txt after 9 loops
		if (loopsbeforetrim<=0)
			loopsbeforetrim:=1
		
		animcount:=itemcount:=0
		sfinder=`r`n%A_Tab%%A_Tab%}`r`n%A_Tab%%A_Tab%" ;"
		htarget=%A_Tab%%A_Tab%%A_Tab%"used_by_heroes"`r`n%A_Tab%%A_Tab%%A_Tab%{`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%"npc_dota_hero_%herochoice%"%A_Tab%%A_Tab%"1"`r`n%A_Tab%%A_Tab%%A_Tab%}
		
		;trim leftmost and rightmost sides that has no relevant search targets "htarget"
		filelength:=StrLen(GlobalArray["items_game.txt"])
		filestring:=Substr(GlobalArray["items_game.txt"],InStr(GlobalArray["items_game.txt"],sfinder,,InStr(GlobalArray["items_game.txt"],htarget)-filelength),InStr(GlobalArray["items_game.txt"],sfinder,,InStr(GlobalArray["items_game.txt"],htarget,,0))+strlen(sfinder)-filelength-1)
		;
		
		Loop
		{
			trimindex:=mod(A_Index,loopsbeforetrim+1) ; sets the index 1,2,3,...,...,n,0 where 0 at the end is neglected
			if (trimindex<=0)
				continue
			ipos := InStr(filestring,htarget,,,trimindex)
			if ipos<=0
				Break
			ipos1:=InStr(filestring,sfinder,,ipos-strlen(filestring))
			ipos:=InStr(filestring,sfinder,,ipos)
			filecontent:=Substr(filestring,ipos1,ipos-ipos1)
			;msgbox % filecontent
			
			if InStr(filecontent,"			""prefab""		""wearable""")>0
			{
				itemname:=searchstringdetector(filecontent,"""name""") ; detects the name of the item
				hitemname=%itemname%
				itemname:=searchstringdetector(filecontent,"""item_slot""") ; detects the hero body slot of the item
				hitemslot=%itemname%
				tmpbar:=iddetector(filecontent) ;filecontent := extracted content from items_game.txt
				hitemid=%tmpbar%
				itemname:=searchstringdetector(filecontent,"""item_rarity""") ; detects the item's rarity
				hitemrarity=%itemname%
				stylescount:=stylecountdetector(filecontent) ;counts the number of allowed styles of an item
				LV_Add(,hitemname,hitemslot,hitemrarity,hitemid,herochoice,stylescount,"0")
				itemcount+=1
				animcount+=1
				animdot=%animdot%.
				GuiControl,Text,searchnofound,%itemcount% Items Found for "npc_dota_hero_%herochoice%"! Please Stand By%animdot%
				if animcount=30
				{
					animcount=0
					VarSetCapacity(animdot,0)
				}
			}
			if (trimindex=loopsbeforetrim)
				filestring:=SubStr(filestring,ipos)
		}
		
		LV_ModifyCol(2,"Sort")
		loop % LV_GetCount()
			raritycoloring(A_Index,3) ;listview coloring system
		GoSub,lvautosize
		
		checkdetector() ; check any field that exist on the listview "itemview"
		GuiControl,+cDefault,searchnofound
		GuiControl,MainGUI:Text,searchnofound,%defaultshoutout%
		GuiControl,MainGUI:Show,searchnofound
	}
	
	GuiControl, MainGUI:+Redraw, showitems
	Gui, MainGUI:-Disabled
}

herochoice:
GuiControlGet,herochoice,,herochoice
if lastherochoice=%herochoice%
{
	return
}
else if A_GuiEvent=DoubleClick
{
	lastherochoice=%herochoice%
	generateheroitems()
}
return

selectinject:
gosub,leakdestroyer
Gui, MainGUI:Submit, NoHide
Gui, MainGUI:Default
if A_DefaultListView<>invlv
{
	Gui, MainGUI:ListView, invlv
}
ifnotexist,%A_ScriptDir%\Library\items_game.txt
{
	msgbox,16,Error!!!,"%A_ScriptDir%\Library\items_game.txt"`n`nIs Missing!!! Make sure to add the original "items_game.txt" at "%A_ScriptDir%\Library" Folder.`n`nIf you dont have an Idea how to get the original "items_game.txt" use "GCFScape.exe" or "Valve's Resource Viewer" application to access "Pak01_dir.vpk". Inside the VPK Archive`,Hit "Ctrl+F"(Find) and search for "items_game.txt". If successfully found`, extract it(items_game.txt) at "%A_ScriptDir%\Library\" Folder.
	return
}
filestring2:=masterfilecontent:=GlobalArray["items_game.txt"]
portstring:=GlobalArray["portraits.txt"]
if ucron=1
{
	FileRead,filestring1,%invdirview%
}
else
{
	filestring1:=filestring2
}
GuiControl,Text,errorshow,
VarSetCapacity(maperrorshow,0)
Gui, MainGUI:+Disabled 
if LV_GetCount()=0
{
	if usemiscon=1
	{
		Goto,injectjump
	}
	else
	{
		GuiControl,MainGUI:Text,searchnofound,%defaultshoutout%
		GuiControl,MainGUI:Show,searchnofound
		gosub,hideprogress
		
		msgbox,16,Empty Task to be Injected,No "ID's" detected on the list!
		Gui, MainGUI:-Disabled 
		return
	}
}
repmocount:=repparcount:=0
ifexist,%A_ScriptDir%\Plugins\ReportLog.aldrin_report
{
	FileSetAttrib,-R,%A_ScriptDir%\Plugins\ReportLog.aldrin_report
	FileDelete,%A_ScriptDir%\Plugins\ReportLog.aldrin_report
}
fileappend,**This Report can be sent to the Creator of the Injector that can be useful for investigation about your current Injection**`r`nReportLog Location Path:`r`n%A_ScriptDir%\ReportLog.aldrin_report,%A_ScriptDir%\Plugins\ReportLog.aldrin_report
VarSetCapacity(commanddir,0),VarSetCapacity(commandextract,0),VarSetCapacity(commandrename,0),VarSetCapacity(rptlimit,0)
ifexist,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\
{
	GuiControl,MainGUI:Text,searchnofound,Deleting pak01_dir Folder.
	FileRemoveDir,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir,1
}
IfNotExist,%A_ScriptDir%\Generated MOD\
{
	FileCreateDir, %A_ScriptDir%\Generated MOD
}
else ifexist,%A_ScriptDir%\Generated MOD\pak01_dir\
{
	GuiControl,Text,searchnofound,Deleting pak01_dir Folder at Generated MOD Folder
	FileRemoveDir,%A_ScriptDir%\Generated MOD\pak01_dir,1
}
FileCreateDir,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\
adder:=1000/LV_GetCount()
if soundon=1
{
	soundint:=LV_GetCount()
	gosub,initsound
}
progress:=0
IPS:=A_TickCount
StartTimer:=A_TickCount
gosub,showprogress
Loop % LV_GetCount()
{
	progress+=adder
	if soundon=1
	{
		if (progress>=250) and (soundswitch1=0) and (sound25=1)
		{
			soundswitch1=1
			SoundPlay,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\Sound\25.wav
		}
		else if (progress>=350) and (soundswitch2=0) and (sound25=1)
		{
			soundswitch2=1
			SoundPlay,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\Sound\35.wav
		}
		else if (progress>=500) and (soundswitch3=0) and (sound25=1)
		{
			soundswitch3=1
			SoundPlay,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\Sound\50.wav
		}
		else if (progress>=650) and (soundswitch4=0) and (sound25=1)
		{
			soundswitch4=1
			SoundPlay,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\Sound\65.wav
		}
		else if (progress>=750) and (soundswitch5=0) and (sound25=1)
		{
			soundswitch5=1
			SoundPlay,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\Sound\75.wav
		}
	}
	GuiControl,MainGUI:, MyProgress,%progress%
	if ( A_Index = LV_GetNext(A_Index-1,"Checked"))
	{
		skip=0
		LV_GetText(string1,A_Index,1)
		LV_GetText(string2,A_Index,2)
		tmpstring=%string1%
		filecontent:=itemdetector(tmpstring) ;filecontent:=itemdetector(tmpstring,filestring)
		LV_GetText(numcheck,A_Index,5)
		LV_GetText(stylechecker,A_Index,6)
		itemname:=searchstringdetector(filecontent,"""used_by_heroes""") ; detects the hero who uses the item
		contentport=%filecontent%
		gosub,extractmodel
		porthero=%itemname%
		if stylechecker>0
		{
			filecontent:=stylechanger(stylechecker,filecontent) ;stylechanger will change the style of all particle effects and even the model
		}
		else
		{
			StringReplace,filecontent,filecontent,`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%%A_Tab%"style"%A_Tab%%A_Tab%"0",,1
		}
		stringcontent1=%filecontent%
		if stringcontent1=
		{
			maperrorshow=%maperrorshow%Cannot Find ID number "string1"!(Resource ID)`n
			skip=1
		}
		else if InStr(stringcontent1,"prefab")=0
		{
			maperrorshow=%maperrorshow%ID number "string1" was found but sadly it is not an "ITEM"!(Resource ID)`n
			skip=1
		}
		tmp=%A_Tab%%A_Tab%%A_Tab%"model_player ;"
		tmp:=StrReplace(stringcontent1,tmp,tmp,modelplayercount)
		loop %modelplayercount%
		{
			extractfile:=modelpathdetector(filecontent,A_Index-1) "_c" ;detect the item root directory and change all slash into backslash
			extractname:=SubStr(extractfile,InStr(extractfile,"\",,0)+1)
		}
		StringReplace,stringcontent1,stringcontent1,"prefab"%A_Tab%%A_Tab%"wearable","prefab"%A_Tab%%A_Tab%"default_item",1
		StringReplace,stringcontent1,stringcontent1,%string1%,%string2%,1
		tmpstring=%string2%
		filecontent:=itemdetector(tmpstring) ;filecontent:=itemdetector(tmpstring,filestring)
		if filecontent=
		{
			maperrorshow=%maperrorshow%Cannot Find ID number "string2"!(Injected ID)`n
			skip=1
		}
		else if InStr(filecontent,"prefab")=0
		{
			maperrorshow=%maperrorshow%ID number "string2" was found but sadly it is not an "ITEM"!(Injected ID)`n
			skip=1
		}
		if skip=1
		{
			continue
		}
		StringReplace,masterfilecontent,masterfilecontent,%filecontent%,%stringcontent1%,1
		; measures the number of items injected per second
		Gui,MainGUI:Show,NoActivate,% floor(1000/(A_TickCount-IPS)) " Items per Second"
		IPS:=A_TickCount
		;
		portfind=`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%"game"`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%{
		if InStr(stringcontent1,portfind)>0
		{
			contentport=%stringcontent1%
			gosub,heroportrait
		}
		tmp=%A_Tab%%A_Tab%%A_Tab%"model_player ;"
		tmp:=StrReplace(stringcontent1,tmp,tmp,modelplayercount)
		loop %modelplayercount%
		{
			modelloop:=A_Index-1
			itemname:=modelpathdetector(filecontent,modelloop) ;detect the item root directory and change all slash into backslash
			itemname=%itemname%_c
			varlength:=StrLen(itemname)
			StringGetPos,pos,itemname,\,R1
			StringTrimLeft,defaultname,itemname,% pos+1
			StringTrimRight,defaultloc,itemname,% varlength-pos
			if (defaultloc<>"") and (defaultname<>"")
			{
				gosub,extractfileruncmd ; extract this files via cmd
			}
		}
	}
}
if masterfilecontent=%filestring%
{
	GuiControl,MainGUI:Text,searchnofound,%defaultshoutout%
	GuiControl,MainGUI:Show,searchnofound
	Gui,MainGUI:Show,NA,AJOM's Dota 2 MOD Master
	gosub,hideprogress
	if soundon=1
	{
		SoundPlay,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\Sound\finishederror.wav
	}
	msgbox,16,Empty Task to be Injected,No present actived/valid "ID's" detected on the list!
	Gui, MainGUI:-Disabled 
	return
}
injectjump:
gosub,hideprogress
if usemiscon=1
{
	GoSub,execmisc
}
GuiControl,Text,errorshow,%maperrorshow%
if autovpkon=0
{
	GoSub,movepak
}
else
{
	GoSub,createvpk
}
Gui,MainGUI:Submit,NoHide
tmpr:=Format_Msec(A_TickCount-StartTimer)
IniWrite,%tmpr%,%A_ScriptDir%\Plugins\ReportLog.aldrin_report,Summary,TotalOperationTime
IniWrite,%cmdmaxinstances%,%A_ScriptDir%\Plugins\ReportLog.aldrin_report,Settings,ThreadsCount

FileSetAttrib,-R,%A_ScriptDir%\ReportLog.aldrin_report ; unprotect
FileMove,%A_ScriptDir%\Plugins\ReportLog.aldrin_report,%A_ScriptDir%,1
fileread,tmp1,%A_ScriptDir%\ReportLog.aldrin_report
FileSetAttrib,+R,%A_ScriptDir%\ReportLog.aldrin_report ; protect the setting file from noobs

GuiControl,Text,reportshow,%tmp1%
if errorshow<>
{
	if soundon=1
	{
		SoundPlay,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\Sound\finishederror.wav
	}
	msgbox,16,ERROR DETECTED!,Injection Complete! But There are ERRORS Detected and the Injector Distinguished them All. Check the "Advance" Section to view the ERROR Report and How the Injector Dealt them.
}
else
{
	if soundon=1
	{
		SoundPlay,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\Sound\OperationFinished.wav
	}
}
GuiControl,MainGUI:Text,searchnofound,%defaultshoutout%
GuiControl,MainGUI:Show,searchnofound
Gui,MainGUI:Show,NA,AJOM's Dota 2 MOD Master
Gui, MainGUI:-Disabled 
gosub,leakdestroyer
return

selectsave:
gosub,leakdestroyer
Gui, MainGUI:Submit, NoHide
GoSub,default_settings
FileSetAttrib,-R,%A_ScriptDir%\Settings.aldrin_dota2mod
param=ucr,mapinvdirview,mapdatadirview,maphdatadirview,mapmdirview,pet,autovpk,usemisc,mappetstyle,mapgiloc,maplowprocessor,mapdota2dir,soundon,useextportraitfile,useextfile,useextitemgamefile,fastmisc,showtooltips,singlesourcechoice,multiplestyleschoice,disableautoupdate,cmdmaxinstances
param1=%ucron%|%invdirview%|%datadirview%|%hdatadirview%|%mdirview%|%peton%|%autovpkon%|%usemiscon%|%petstyle%|%giloc%|%lowprocessor%|%dota2dir%|%soundon%|%useextportraitfile%|%useextfile%|%useextitemgamefile%|%fastmisc%|%showtooltips%|%singlesourcechoicegui%|%multiplestyleschoicegui%|%disableautoupdate%|%cmdmaxinstances%
Loop,parse,param1,|
{
	tmpstring=%A_LoopField%
	tmpint=%A_Index%
	Loop,parse,param,`,
	{
		if tmpint=%A_Index%
		{
			;tmpstring:=StrReplace(tmpstring,",","``,")
			;msgbox %tmpstring%
			IniWrite,%tmpstring%, %A_ScriptDir%\Settings.aldrin_dota2mod, Edits,%A_LoopField%
			Break
		}
	}
}
if A_DefaultListView<>extfilelist
{
	Gui, MainGUI:ListView, extfilelist
}
IniRead,tmpint, %A_ScriptDir%\Settings.aldrin_dota2mod,External_Files,CountExternalFolder,0
Loop %tmpint%
{
	IniDelete,%A_ScriptDir%\Settings.aldrin_dota2mod,External_Files,ExternalFolder%A_Index%
	IniDelete,%A_ScriptDir%\Settings.aldrin_dota2mod,External_Files,ExternalFolder%A_Index%Enabled
}
IniDelete,%A_ScriptDir%\Settings.aldrin_dota2mod,External_Files,CountExternalFolder
tmpint=0
Loop % LV_GetCount()
{
	tmpint+=1
	LV_GetText(tmpstring,A_Index ,7)
	IniWrite,%tmpstring% , %A_ScriptDir%\Settings.aldrin_dota2mod,External_Files,ExternalFolder%tmpint%
	if ( A_Index = LV_GetNext(A_Index-1,"Checked") )
	{
		IniWrite,+check, %A_ScriptDir%\Settings.aldrin_dota2mod,External_Files,ExternalFolder%tmpint%Enabled
	}
	else IniWrite,-check, %A_ScriptDir%\Settings.aldrin_dota2mod,External_Files,ExternalFolder%tmpint%Enabled
}
IniWrite,%tmpint% , %A_ScriptDir%\Settings.aldrin_dota2mod,External_Files,CountExternalFolder
FileSetAttrib,+R,%A_ScriptDir%\Settings.aldrin_dota2mod
gosub,leakdestroyer
return

invupdate:
Gui,MainGUI:Submit,NoHide
if injectfrom=
{
	return
}
else if injectto=
{
	return
}
Gui, MainGUI:Default
if A_DefaultListView<>invlv
{
	Gui, MainGUI:ListView, invlv
}
booleanexist=0
invstringhk:=injectfrom
VarSetCapacity(checker,0),VarSetCapacity(varlength,0),VarSetCapacity(zeroloop,0)
varlength:=StrLen(invstringhk)
Loop, %varlength%
{
	zeroloop=0%zeroloop%
	StringLeft,checker,invstringhk,%A_Index%
	if checker=%zeroloop%
	{
		StringTrimLeft,invstringhk,invstringhk,%A_Index%
	}
}
VarSetCapacity(checker,0),VarSetCapacity(varlength,0),VarSetCapacity(zeroloop,0)
varlength:=StrLen(injectto)
Loop, %varlength%
{
	zeroloop=0%zeroloop%
	StringLeft,checker,injectto,%A_Index%
	if checker=%zeroloop%
	{
		StringTrimLeft,injectto,injectto,%A_Index%
	}
}
Loop % LV_GetCount()
{
	LV_GetText(checker,A_Index ,2)
	if checker=%injectto%
	{
		LV_Modify(A_Index,"Select",invstringhk)
		booleanexist=1
		filestring:=GlobalArray["items_game.txt"]
		tmpstring=%checker%
		filecontent:=itemdetector(tmpstring) ;filecontent:=itemdetector(tmpstring,filestring)
		if InStr(filecontent,"prefab")<1
		{
			return
		}
		itemname:=searchstringdetector(filecontent,"""name""") ; detects the name of the item
		LV_Modify(A_Index,"Col4",itemname)
		if ucron=1
		{
			FileRead,filestring,%invdirview%
		}
		else
		{
			filestring:=GlobalArray["items_game.txt"]
		}
		LV_GetText(checker,A_Index ,1)
		tmpstring=%checker%
		filecontent:=itemdetector(tmpstring) ;filecontent:=itemdetector(tmpstring,filestring)
		if InStr(filecontent,"prefab")<1
		{
			return
		}
		itemname:=searchstringdetector(filecontent,"""name""") ; detects the name of the item
		LV_Modify(A_Index,"Col3",itemname)
		stylescount:=stylecountdetector(filecontent) ;counts the number of allowed styles of an item
		LV_Modify(A_Index,"Col5",stylescount)
		LV_Modify(A_Index,"Col6","0")
	}
}
if booleanexist=0
{
	filestring:=GlobalArray["items_game.txt"]
	tmpstring=%injectto%
	filecontent:=itemdetector(tmpstring) ;filecontent:=itemdetector(tmpstring,filestring)
	if InStr(filecontent,"prefab")<1
	{
		return
	}
	itemname:=searchstringdetector(filecontent,"""name""") ; detects the name of the item
	tmpname2=%itemname%
	if ucron=1
	{
		FileRead,filestring,%invdirview%
	}
	else
	{
		filestring:=GlobalArray["items_game.txt"]
	}
	tmpstring=%invstringhk%
	filecontent:=itemdetector(tmpstring) ;filecontent:=itemdetector(tmpstring,filestring)
	itemname:=searchstringdetector(filecontent,"""name""") ; detects the name of the item
	tmpname1=%itemname%
	stylescount:=stylecountdetector(filecontent) ;counts the number of allowed styles of an item
	LV_Add("Check", invstringhk, injectto,tmpname1,tmpname2,stylescount,"0")
}
GoSub,lvautosize
VarSetCapacity(zeroloop,0)
return

datareload:
Gui, MainGUI:Default
if A_DefaultListView<>invlv
{
	Gui, MainGUI:ListView, invlv
}
GuiControl, MainGUI:-Redraw, invlv
if VarRead("@DataBaseVersion!")=1.5
{
	RegisteredDirectory:=VarRead("RegisteredDirectory")
	if !(RegisteredDirectory>=1)
	{
		RegisteredDirectory=0
		Loop
		{
			if (!InStr(FileData,"IDInjected" A_Index) or !InStr(FileData,"ResourceID" A_Index)) and (!InStr(FileData,"ResourceIDName1" A_Index) or !InStr(FileData,"IDInjectedName1" A_Index))
			{
				RegisteredDirectory:=A_Index-1
				VarWrite("RegisteredDirectory",RegisteredDirectory)	;VarWrite(Key := "", Value := "") ; Saves the Database Version for future version detection
				;IniWrite,RegisteredDirectory%,%hdatadirview%,Edits,RegisteredDirectory
				Break
			}
		}
	}
	adder:=1000/RegisteredDirectory
	gosub,showprogress
	progress=0
	if ucron=1
	{
		FileRead,filestring,%invdirview%
	}
	else
	{
		filestring:=GlobalArray["items_game.txt"]
	}
	Loop, %RegisteredDirectory%
	{
		IDInjected:=VarRead("IDInjected" A_Index)
		ResourceID:=VarRead("ResourceID" A_Index)
		ActiveStyle:=VarRead("ActiveStyle" A_Index)
		ResourceIDEnabled:=VarRead("ResourceID" A_Index "Enabled")
		IDInjectedName:=VarRead("IDInjectedName" A_Index)
		ResourceIDName:=VarRead("ResourceIDName" A_Index)
		mapinjectfrom:=ResourceID
		mapinjectto:=IDInjected
		invwaschecked:=ResourceIDEnabled
		VarSetCapacity(checker,0),VarSetCapacity(varlength,0),VarSetCapacity(zeroloop,0)
		varlength:=StrLen(mapinjectfrom)
		Loop, %varlength%
		{
			zeroloop=0%zeroloop%
			StringLeft,checker,mapinjectfrom,%A_Index%
			if checker=%zeroloop%
			{
				StringTrimLeft,mapinjectfrom,mapinjectfrom,%A_Index%
			}
		}
		VarSetCapacity(checker,0),VarSetCapacity(varlength,0),VarSetCapacity(zeroloop,0)
		varlength:=StrLen(mapinjectto)
		Loop, %varlength%
		{
			zeroloop=0%zeroloop%
			StringLeft,checker,mapinjectto,%A_Index%
			if checker=%zeroloop%
			{
				StringTrimLeft,mapinjectto,mapinjectto,%A_Index%
			}
		}
		filestring:=GlobalArray["items_game.txt"]
		tmpstring:=IDInjected
		filecontent:=itemdetector(tmpstring) ;filecontent:=itemdetector(tmpstring,filestring)
		if filecontent=
		{
			tmpstring:=IDInjectedName
			tmpbar:=newiddetector(tmpstring) ;tmpbar:=newiddetector(tmpstring,filestring) ; tmpstring:=item name , filestring:=items_game.txt
			if tmpbar<>
			{
				maperrorshow=% maperrorshow "Section: General`nInjected ID: " IDInjected "`nInjected Registered Item Name: " IDInjectedName "`nProblem: The ID Injected does not exist! on items_game.txt, but the Registered Item Name was Found/Existed.`nSolution: analyzing the contents of the Item Name found at items_game.txt, FOUND ID " tmpbar "`nStatus: Solved! DOTA2 MOD Master changed the ID Injected into " tmpbar ", No need for Further User Action.`n`n"
				IDInjected=%tmpbar%
				VarWrite("IDInjected" A_Index,tmpbar)	;VarWrite(Key := "", Value := "") ; Saves the Database Version for future version detection
				;IniWrite,%tmpbar%,%datadirview%,Edits,IDInjected%A_Index%
			}
			else
			{
				maperrorshow=% maperrorshow "Section: General`nResource ID: " ResourceID "`nResource Registered Item Name: " ResourceIDName "`nInjected ID: "IDInjected "`nInjected Registered Item Name: " IDInjectedName "`nActived Style: " ActiveStyle "`nChecked: " ResourceIDEnabled "`nProblem: ID Injected nor the Injected Registered Item Name does not Exist!`nStatus: UNSOLVED! The General Information about the ID Injected is corrupted, and will not be included on the listview.`nSolution: Use all the information above, track down and configure the injected ID properly.`n`n"
				continue
			}
		}
		itemname:=searchstringdetector(filecontent,"""name""") ; detects the name of the item
		if IDInjectedName<>%itemname%
		{
			tmpstring:=IDInjectedName
			tmpbar:=newiddetector(tmpstring) ;tmpbar:=newiddetector(tmpstring,filestring) ; tmpstring:=item name , filestring:=items_game.txt
			if tmpbar<>
			{
				maperrorshow=% maperrorshow "Section: General`nInjected ID: " IDInjected "`nInjected Registered Item Name: " IDInjectedName "`nProblem: Registered Item Name does not pair with the Injected ID!`nSolution: changing the ID into " tmpbar "`nStatus: Solved: No need for Further User Action.`n`n"
				IDInjected=%tmpbar%
				VarWrite("IDInjected" A_Index,tmpbar)	;VarWrite(Key := "", Value := "") ; Saves the Database Version for future version detection
				;IniWrite,%tmpbar%,%datadirview%,Edits,IDInjected%A_Index%
				itemname:=searchstringdetector(filecontent,"""name""") ; detects the name of the item
			}
			else
			{
				maperrorshow=% maperrorshow "Section: General`nInjected ID: " IDInjected "`nInjected Registered Item Name: " IDInjectedName "`nProblem: ID has a different name and does not match with the Registered Item Name. It was " itemname "`nSolution: Changing the Registered Item name into" itemname "`nStatus: Solved: No need for Further User Action.`n`n"
				VarWrite("IDInjectedName" A_Index,itemname)	;VarWrite(Key := "", Value := "") ; Saves the Database Version for future version detection
			}
		}
		tmpname2=%itemname%
		tmpstring:=ResourceID
		filecontent:=itemdetector(tmpstring) ;filecontent:=itemdetector(tmpstring,filestring)
		itemname:=searchstringdetector(filecontent,"""name""") ; detects the name of the item
		if ResourceIDName<>%itemname%
		{
			tmpstring:=ResourceIDName
			tmpbar:=newiddetector(tmpstring) ;tmpbar:=newiddetector(tmpstring,filestring) ; tmpstring:=item name , filestring:=items_game.txt
			if tmpbar<>
			{
				maperrorshow=% maperrorshow "Section: General`nResource ID: " ResourceID "`nResource Registered Item Name: " ResourceIDName "`nProblem: Registered Item Name does not pair at the Resource ID.`nSolution: Changing the ID into " tmpbar "`nStatus: Solved: No need for Further User Action.`n`n"
				ResourceID=%tmpbar%
				VarWrite("ResourceID" A_Index,tmpbar)	;VarWrite(Key := "", Value := "") ; Saves the Database Version for future version detection
				;IniWrite,%tmpbar%,%datadirview%,Edits,ResourceID%A_Index%
				itemname:=searchstringdetector(filecontent,"""name""") ; detects the name of the item
			}
			else
			{
				maperrorshow=% maperrorshow "Section: General`nResource ID: " ResourceID "`nResource Registered Item Name: " ResourceIDName "`nProblem: ID has a different name at items_game.txt and was not Registered Item Name. It was " itemname "`nSolution: Changing Registered Item Name into " itemname "`nStatus: Solved: No need for Further User Action.`n`n"
				VarWrite("ResourceIDName" A_Index,itemname)	;VarWrite(Key := "", Value := "") ; Saves the Database Version for future version detection
			}
		}
		tmpname1=%itemname%
		stylescount:=stylecountdetector(filecontent) ;counts the number of allowed styles of an item
		if invwaschecked=+
		{
			LV_Add("Check", ResourceID, IDInjected,tmpname1,tmpname2,stylescount,ActiveStyle)
		}
		else
		{
			LV_Add("-Check", ResourceID, IDInjected,tmpname1,tmpname2,stylescount,ActiveStyle)
		}
		if invwaschecked=+
		{
			LV_Modify(A_Index, "check")
		}
		else
		{
			LV_Modify(A_Index, "-check")
		}
		GoSub,lvautosize
		progress+=adder
		GuiControl,MainGUI:, MyProgress,%progress%
	}
}
else ; if version 1, old version
{
	IniRead,RegisteredDirectory,%datadirview%,Edits,RegisteredDirectory,0
	if !(RegisteredDirectory>=1)
	{
		RegisteredDirectory=0
		Loop
		{
			if (!InStr(FileData,"IDInjected" A_Index) or !InStr(FileData,"ResourceID" A_Index)) and (!InStr(FileData,"ResourceIDName1" A_Index) or !InStr(FileData,"IDInjectedName1" A_Index))
			{
				RegisteredDirectory:=A_Index-1
				IniWrite,%RegisteredDirectory%,%datadirview%,Edits,RegisteredDirectory
				Break
			}
		}
	}
	
	adder:=1000/RegisteredDirectory
	gosub,showprogress
	progress=0
	Loop, %RegisteredDirectory%
	{
		IniRead,IDInjected,%datadirview%,Edits,IDInjected%A_Index%
		IniRead,ResourceID,%datadirview%,Edits,ResourceID%A_Index%
		IniRead,ActiveStyle,%datadirview%,Edits,ActiveStyle%A_Index%
		IniRead,ResourceIDEnabled,%datadirview%,Edits,ResourceID%A_Index%Enabled
		IniRead,IDInjectedName,%datadirview%,Edits,IDInjectedName%A_Index%
		IniRead,ResourceIDName,%datadirview%,Edits,ResourceIDName%A_Index%
		mapinjectfrom:=ResourceID
		mapinjectto:=IDInjected
		invwaschecked:=ResourceIDEnabled
		VarSetCapacity(checker,0),VarSetCapacity(varlength,0),VarSetCapacity(zeroloop,0)
		varlength:=StrLen(mapinjectfrom)
		Loop, %varlength%
		{
			zeroloop=0%zeroloop%
			StringLeft,checker,mapinjectfrom,%A_Index%
			if checker=%zeroloop%
			{
				StringTrimLeft,mapinjectfrom,mapinjectfrom,%A_Index%
			}
		}
		VarSetCapacity(checker,0),VarSetCapacity(varlength,0),VarSetCapacity(zeroloop,0)
		varlength:=StrLen(mapinjectto)
		Loop, %varlength%
		{
			zeroloop=0%zeroloop%
			StringLeft,checker,mapinjectto,%A_Index%
			if checker=%zeroloop%
			{
				StringTrimLeft,mapinjectto,mapinjectto,%A_Index%
			}
		}
		filestring:=GlobalArray["items_game.txt"]
		tmpstring:=IDInjected
		filecontent:=itemdetector(tmpstring) ;filecontent:=itemdetector(tmpstring,filestring)
		if filecontent=
		{
			tmpstring:=IDInjectedName
			tmpbar:=newiddetector(tmpstring) ;tmpbar:=newiddetector(tmpstring,filestring) ; tmpstring:=item name , filestring:=items_game.txt
			if tmpbar<>
			{
				maperrorshow=% maperrorshow "Section: General`nInjected ID: " IDInjected "`nInjected Registered Item Name: " IDInjectedName "`nProblem: The ID Injected does not exist! on items_game.txt, but the Registered Item Name was Found/Existed.`nSolution: analyzing the contents of the Item Name found at items_game.txt, FOUND ID " tmpbar "`nStatus: Solved! DOTA2 MOD Master changed the ID Injected into " tmpbar ", No need for Further User Action.`n`n"
				IDInjected=%tmpbar%
				IniWrite,%tmpbar%,%datadirview%,Edits,IDInjected%A_Index%
			}
			else
			{
				maperrorshow=% maperrorshow "Section: General`nResource ID: " ResourceID "`nResource Registered Item Name: " ResourceIDName "`nInjected ID: "IDInjected "`nInjected Registered Item Name: " IDInjectedName "`nActived Style: " ActiveStyle "`nChecked: " ResourceIDEnabled "`nProblem: ID Injected nor the Injected Registered Item Name does not Exist!`nStatus: UNSOLVED! The General Information about the ID Injected is corrupted, and will not be included on the listview.`nSolution: Use all the information above, track down and configure the injected ID properly.`n`n"
				continue
			}
		}
		itemname:=searchstringdetector(filecontent,"""name""") ; detects the name of the item
		if IDInjectedName<>%itemname%
		{
			tmpstring:=IDInjectedName
			tmpbar:=newiddetector(tmpstring) ;tmpbar:=newiddetector(tmpstring,filestring) ; tmpstring:=item name , filestring:=items_game.txt
			if tmpbar<>
			{
				maperrorshow=% maperrorshow "Section: General`nInjected ID: " IDInjected "`nInjected Registered Item Name: " IDInjectedName "`nProblem: Registered Item Name does not pair with the Injected ID!`nSolution: changing the ID into " tmpbar "`nStatus: Solved: No need for Further User Action.`n`n"
				IDInjected=%tmpbar%
				IniWrite,%tmpbar%,%datadirview%,Edits,IDInjected%A_Index%
				itemname:=searchstringdetector(filecontent,"""name""") ; detects the name of the item
			}
			else
			{
				maperrorshow=% maperrorshow "Section: General`nInjected ID: " IDInjected "`nInjected Registered Item Name: " IDInjectedName "`nProblem: ID has a different name and does not match with the Registered Item Name. It was " itemname "`nSolution: Changing the Registered Item name into" itemname "`nStatus: Solved: No need for Further User Action.`n`n"
				IniWrite,%itemname%,%datadirview%,Edits,IDInjectedName%A_Index%
			}
		}
		tmpname2=%itemname%
		if ucron=1
		{
			FileRead,filestring,%invdirview%
		}
		else
		{
			filestring:=GlobalArray["items_game.txt"]
		}
		tmpstring:=ResourceID
		filecontent:=itemdetector(tmpstring) ;filecontent:=itemdetector(tmpstring,filestring)
		itemname:=searchstringdetector(filecontent,"""name""") ; detects the name of the item
		if ResourceIDName<>%itemname%
		{
			tmpstring:=ResourceIDName
			tmpbar:=newiddetector(tmpstring) ;tmpbar:=newiddetector(tmpstring,filestring) ; tmpstring:=item name , filestring:=items_game.txt
			if tmpbar<>
			{
				maperrorshow=% maperrorshow "Section: General`nResource ID: " ResourceID "`nResource Registered Item Name: " ResourceIDName "`nProblem: Registered Item Name does not pair at the Resource ID.`nSolution: Changing the ID into " tmpbar "`nStatus: Solved: No need for Further User Action.`n`n"
				ResourceID=%tmpbar%
				IniWrite,%tmpbar%,%datadirview%,Edits,ResourceID%A_Index%
				itemname:=searchstringdetector(filecontent,"""name""") ; detects the name of the item
			}
			else
			{
				maperrorshow=% maperrorshow "Section: General`nResource ID: " ResourceID "`nResource Registered Item Name: " ResourceIDName "`nProblem: ID has a different name at items_game.txt and was not Registered Item Name. It was " itemname "`nSolution: Changing Registered Item Name into " itemname "`nStatus: Solved: No need for Further User Action.`n`n"
			}
		}
		tmpname1=%itemname%
		stylescount:=stylecountdetector(filecontent) ;counts the number of allowed styles of an item
		if invwaschecked=+
		{
			LV_Add("Check", ResourceID, IDInjected,tmpname1,tmpname2,stylescount,ActiveStyle)
		}
		else
		{
			LV_Add("-Check", ResourceID, IDInjected,tmpname1,tmpname2,stylescount,ActiveStyle)
		}
		if invwaschecked=+
		{
			LV_Modify(A_Index, "check")
		}
		else
		{
			LV_Modify(A_Index, "-check")
		}
		GoSub,lvautosize
		progress+=adder
		GuiControl,MainGUI:, MyProgress,%progress%
	}
}
GuiControl,Text,errorshow,%maperrorshow%
gosub,hideprogress
GuiControl, MainGUI:+Redraw, invlv
return

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Some Functions~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
getmemoryspecs(key:="Capacity") ; by aldrinjohnom
{
	static specification
	
	if (specification="")
	{
		Run,%A_ComSpec%,,Hide UseErrorLevel,cPID
		DetectHiddenWindows,On
		WinWait,ahk_pid %cPID% ahk_exe cmd.exe ahk_class ConsoleWindowClass
		DllCall("kernel32\AttachConsole", "UInt",cPID)
		shell := ComObjCreate("WScript.Shell")
		; Execute a single command via cmd.exe
		exec := shell.Exec("""" ComSpec """ /C ""wmic memorychip list full""")
		DllCall("kernel32\FreeConsole")
		; Read and return the command's output
		specification:=Trim(strreplace(exec.StdOut.ReadAll(),"`r`r","`r"),A_Space "`t`r`n")
		Process,Close,%cPID%
		DetectHiddenWindows,Off
	}
	
	loop,parse,specification,`r
	{
		content:=Trim(A_LoopField,A_Space "`t`r`n")
		if (substr(content,1,instr(content,"=")-1)=key)
			return substr(content,instr(content,"=")+1)
	}
}

Format_Msec(ms,TimeFormat:="")
{
	VarSetCapacity(t,256),DllCall("GetDurationFormat","uint",2048,"uint",0,"ptr",0,"int64",ms*10000,"wstr","d' Days 'h' Hours 'm' Minutes 's' Seconds","wstr",t,"int",256)
	
	if (TimeFormat!="")
	{
		pos1:=InStr(t," Days ")+6
		Days:=SubStr(t,1,pos1-7)
		pos2:=InStr(t," Hours ")+7
		Hours:=SubStr(t,pos1,pos2-7-pos1)
		pos1:=InStr(t," Minutes ")+9
		Minutes:=SubStr(t,pos2,pos1-9-pos2)
		Seconds:=SubStr(t,pos1,InStr(t," Seconds")-pos1)
		VarSetCapacity(t,0)
		
		if (TimeFormat="Array") ; isolate day,hour,minute,second
		{
			t:=[]
			t["Day"]:=Days
			t["Hour"]:=Hours
			t["Minute"]:=Minutes
			t["Second"]:=Seconds
		}
		else ; custom time formatting
		{
			if !InStr(TimeFormat,"Day")
				Hours+=24*Days
			else if (Days!=0)
				t.=Days " Day" (Days>1 ? "s" : "") A_Space
			if !InStr(TimeFormat,"Hour")
				Minutes+=60*Hours
			else if (Hours!=0)
				t.=Hours " Hour" (Hours>1 ? "s" : "") A_Space
			
			if !InStr(TimeFormat,"Minute")
				Seconds+=60*Minutes
			else if (Minutes!=0)
				t.=Minutes " Minute" (Minutes>1 ? "s" : "") A_Space
				
			if InStr(TimeFormat,"Second") and (Seconds!=0)
				t.=Seconds " Second" (Seconds>1 ? "s" : "") A_Space
		}
	}
	
    return t
}

LV_ClearAll(switch:="-column") ;deletes the listview and removes coloring
;usage:
;switch	-	include strings even without space:
;			-column 	do not delete columns
;			-row 	do not delete rows
;			if switch is does not include those two parameters it will delete both rows and columns
{
	LVA_EraseAllCells(A_DefaultListView) ;remove cells coloring
	LVA_Refresh(A_DefaultListView) ; set the listview coloring by redrawing the listview
	
	if !instr(switch,"-row")
		LV_Delete()
	
	if !instr(switch,"-column")
		loop % LV_GetCount("Column")
			LV_DeleteCol(1)
}

raritycoloring(rarityrow,raritycolumn)
{
	static raritycolors
	if !IsObject(raritycolors)
	{
		raritycolors:=[]
		resource:=GlobalArray["items_game.txt"]
		length:=strlen(resource)
		loop
		{
			StartPos := InStr(resource,"""Rarity_",,,A_Index)
			if (StartPos<=0)
				break
			StartPos := InStr(resource,"`r`n		""",,StartPos-length)+1
			EndPos := InStr(resource,"`r`n		""",,StartPos)
			content:=SubStr(resource,StartPos,EndPos-StartPos)
			StartPos := InStr(content,"""")
			EndPos := InStr(content,"""",,,2)
			rarity:=SubStr(content,StartPos+1,EndPos-StartPos-1)
			StartPos := InStr(content,"""color""")
			StartPos := InStr(content,"""",,StartPos,3)
			EndPos := InStr(content,"""",,StartPos,2)
			color:=SubStr(content,StartPos+1,EndPos-StartPos-1)
			StartPos := InStr(resource,"`r`n		""" color """")
			StartPos := InStr(resource,"""hex_color""",,StartPos)
			StartPos := InStr(resource,"""",,StartPos,3)
			EndPos := InStr(resource,"""",,StartPos,2)
			color:=SubStr(resource,StartPos+2,EndPos-StartPos-2)
			raritycolors[rarity]:=color
		}
		VarSetCapacity(color,0),VarSetCapacity(StartPos,0),VarSetCapacity(EndPos,0),VarSetCapacity(resource,0),VarSetCapacity(content,0),VarSetCapacity(rarity,0)
	}
	LV_GetText(rarity,rarityrow,raritycolumn)
	For currentrarity,color in raritycolors
	{
		if (rarity=currentrarity) or (currentrarity="common" and rarity="Undefined")
		{
			;msgbox % rarity " and " currentrarity[0] " and " currentrarity[1]
			LVA_SetCell(A_DefaultListView,rarityrow,0,color,"") ;set row coloring
			LVA_Refresh(A_DefaultListView) ; set the listview coloring by redrawing the listview
			break
		}
	}
}

detectsorting: ;recolor everything if detected
if (A_GuiEvent!="ColClick") and (A_GuiControl!="")
	return
;Gui,MainGUI:+Disabled
if (A_DefaultListView<>A_GuiControl) and (A_GuiControl!="")
{
	Gui,MainGUI:ListView,%A_GuiControl%
}
GuiControl, MainGUI:-Redraw,%A_DefaultListView%
LVA_EraseAllCells(A_DefaultListView) ;remove cells coloring
loop % LV_GetCount("Column")
{
	LV_GetText(raritycolumn,0,A_Index)
	if instr(raritycolumn,"Rarity")
	{
		raritycolumn:=A_Index
		loop % LV_GetCount()
		{
			raritycoloring(A_Index,raritycolumn)
		}
		break
	}
}
GuiControl, MainGUI:+Redraw,%A_DefaultListView%
;Gui,MainGUI:-Disabled
return
;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Extractors~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
materialsextractor: ; requires (valvefile,skinindex) variables
if (MainGUIHWND!="")
{
	text=or !WinExist("ahk_id %MainGUIHWND%" )
}
VarSetCapacity(materialpid,0)
materialpid:=ExecScript("
(
#NoEnv
#KeyHistory 0
#NoTrayIcon

Hotkey,~$^+!l,,P2131
FileDelete,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\extractlist1.aldrin_dota2list

SetWorkingDir," A_ScriptDir "

;Attach
DetectHiddenWindows, on
Run,%A_ComSpec%,,Hide UseErrorLevel, cPID
WinWait,ahk_pid %cPID% ahk_exe cmd.exe ahk_class ConsoleWindowClass,, 10
DllCall(""AttachConsole"",""uint"",cPID)
hCon:=DllCall(""CreateFile"",""str"",""CONOUT$"",""uint"",0xC0000000,""uint"",7,""uint"",0,""uint"",3,""uint"",0,""uint"",0)

loop
{
	While !FileExist(A_Temp ""\AJOM Innovations\DOTA2 MOD Master\extractlist.aldrin_dota2list"")
	{
		if terminateprogram " text "
			goto,Clean_up
		else
		{
			sleep 500 ; give it time to sleep to avoid occupying large memory and cpu
			continue
		}
	}
	
	IniRead,materialscount,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\extractlist.aldrin_dota2list,Materials,materialscount,DNAPWIDAWnsIDmAWwBx
	if (materialscount=""DNAPWIDAWnsIDmAWwBx"")
	{
		IniRead,terminateprogram,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\extractlist.aldrin_dota2list,Status,terminateprogram,0
		if terminateprogram " text "
			goto,Clean_up
		else
			continue
	}
	IniRead,valvefile,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\extractlist.aldrin_dota2list,Materials,valvefile%materialscount%,DNAPWIDAWnsIDmAWwBx
	IniRead,skinindex,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\extractlist.aldrin_dota2list,Materials,skinindex%materialscount%,DNAPWIDAWnsIDmAWwBx
	if debugmode
		msgbox entering 1
	if (valvefile=""DNAPWIDAWnsIDmAWwBx"") or (skinindex=""DNAPWIDAWnsIDmAWwBx"")
	{
		IniRead,terminateprogram,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\extractlist.aldrin_dota2list,Status,terminateprogram,0
		if terminateprogram " text "
			goto,Clean_up
		else
			continue
	}
	
	FileDelete,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\extractlist1.aldrin_dota2list
	FileMove,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\extractlist.aldrin_dota2list,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\extractlist1.aldrin_dota2list,1
	IniRead,materialscount,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\extractlist1.aldrin_dota2list,Materials,materialscount,0
	if debugmode
		msgbox materialscount=%materialscount%
	loop %materialscount%
	{
		IniRead,valvefile,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\extractlist1.aldrin_dota2list,Materials,valvefile%A_Index%,DNAPWIDAWnsIDmAWwBx
		IniRead,skinindex,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\extractlist1.aldrin_dota2list,Materials,skinindex%A_Index%,DNAPWIDAWnsIDmAWwBx
		if (valvefile=""DNAPWIDAWnsIDmAWwBx"") or (skinindex=""DNAPWIDAWnsIDmAWwBx"")
		{
			continue
		}
		if debugmode
		msgbox out continue
		
		skinindex++
		
		timeout:=A_TickCount
		checkifmodelexist:
		if !FileExist(valvefile)
		{
			if (A_TickCount-timeout=10000) ; if after 10 seconds, the file still does not exist, recognize it as failure and go back to the start of the loop
				break
			else if terminateprogram " text "
				goto,Clean_up
			else
			{
				sleep 0 ; give it time to sleep as low as possible to avoid occupying large memory and cpu
				goto,checkifmodelexist
			}
		}
		
		if debugmode
		msgbox escaped
		
		;launch cmd
		objShell := ComObjCreate(""WScript.Shell"")
		objExec := objShell.Exec(""""""" dotnetfullpath """"" """""" A_WorkingDir ""\Plugins\Decompiler\Decompiler.dll"""" --block DATA --input """""" valvefile """""""")
		strStdOut:=""""
		while, !objExec.StdOut.AtEndOfStream
			stdout := objExec.StdOut.ReadAll()
		
		pos:=instr(stdout,""MaterialGroup_t"")
		stdout:=substr(stdout,pos,strlen(stdout)-pos+1)
		
		defaultmaterials:=[],itemmaterials:=[]
		strreplace(stdout,""MaterialGroup_t"",,count)
		loop %count%
		{
			index:=A_Index
			pos:=instr(stdout,""``r``n		{"",,,index)+1
			pos1:=instr(stdout,""``r``n		}"",,pos)
			content:=SubStr(stdout,pos,pos1-pos)
			
			strreplace(content,"".vmat"",,count)
			loop %count%
			{
				pos:=instr(content,""Name: "",,,A_Index)+6
				pos1:=instr(content,""``r``n"",,pos)
				material:=strreplace(SubStr(content,pos,pos1-pos) ""_c"",""/"",""\"")
				if (index=1)
				{	
					pos:=instr(material,""\"",,0)+1
					defaultmaterials[A_Index,1]:=SubStr(material,1,pos-2)
					defaultmaterials[A_Index,2]:=SubStr(material,pos)
				}
				else if (index=skinindex)
				{
					pos:=instr(material,""\"",,0)+1
					itemmaterials[A_Index,1]:=material
					itemmaterials[A_Index,2]:=SubStr(material,pos)
				}
				if (defaultmaterials.Count()=itemmaterials.Count())
					break
			}
		}
		repeater:
		pid:=[]
		DetectHiddenWindows,On
		for index, in defaultmaterials
		{
			if !FileExist(A_WorkingDir ""\Plugins\VPKCreator\pak01_dir\"" defaultmaterials[index,1] ""\"")
				FileCreateDir,% A_WorkingDir ""\Plugins\VPKCreator\pak01_dir\"" defaultmaterials[index,1]
			else FileDelete,% A_WorkingDir ""\Plugins\VPKCreator\pak01_dir\"" defaultmaterials[index,1] ""\"" defaultmaterials[A_Index,2]
			
			command:=""""""" strreplace(variablehllib,"/","\") """"" -p """"" strreplace(dota2dir,"/","\") "\game\dota\pak01_dir.vpk"""" -d """""" A_WorkingDir ""\Plugins\VPKCreator\pak01_dir\"" defaultmaterials[index,1] """""" -e """"root\"" itemmaterials[A_Index,1] """"""""
			if debugmode
				msgbox %command%
			run,%command%,,Hide UseErrorLevel,material
			pid[index]:=material
		}
		Process,Wait,%material%,2
		if debugmode
			msgbox escape 1
		for index,material in pid
		{
			Process,WaitClose,%material%,10
			
			if FileExist(A_WorkingDir ""\Plugins\VPKCreator\pak01_dir\"" defaultmaterials[index,1] ""\"" itemmaterials[A_Index,2])
				FileMove,% A_WorkingDir ""\Plugins\VPKCreator\pak01_dir\"" defaultmaterials[index,1] ""\"" itemmaterials[A_Index,2],% A_WorkingDir ""\Plugins\VPKCreator\pak01_dir\"" defaultmaterials[index,1] ""\"" defaultmaterials[A_Index,2],1
		}
		if debugmode
			msgbox escape 2
		DetectHiddenWindows,Off
		if terminateprogram " text "
			goto,Clean_up
		for index, in defaultmaterials
		{
			if !FileExist(A_WorkingDir ""\Plugins\VPKCreator\pak01_dir\"" defaultmaterials[index,1] ""\"" defaultmaterials[A_Index,2])
			{
				if debugmode
					msgbox % ""repeating because of``n``n"" A_WorkingDir ""\Plugins\VPKCreator\pak01_dir\"" defaultmaterials[index,1] ""\"" defaultmaterials[A_Index,2]
				goto,repeater
			}
		}
	}
	IniRead,terminateprogram,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\extractlist1.aldrin_dota2list,Status,terminateprogram,0
	if terminateprogram " text "
		goto,Clean_up
	if debugmode
		msgbox restarting
}

Clean_up:
DllCall(""CloseHandle"", ""uint"", hCon)
DllCall(""FreeConsole"")
Process, Close, %cPID%
exitapp

~$^+!l::
if debugmode
debugmode:=0
else debugmode:=1
tooltip, DEBUGMODE : %debugmode%
sleep 500
tooltip
return
)")
return

;ExecScript(script, ahk:="", args:="", kwargs*)
;{
;	;// Set default values for options first
;	child  := true ;// use WshShell.Exec(), otherwise .Run()
;	, name := "AHK_" . A_TickCount
;	, dir  := ""
;	, ahk  := A_AhkPath
;	, cp   := 0
;	
;	;added by aldrin john olaer manalansan
;	if !FileExist(ahk) or (ahk="")
;	{
;		if FileExist(A_AhkPath)
;			ahk:=A_AhkPath
;		else if FileExist(A_ScriptDir "\Plugins\AutoHotkey\AutoHotkeyU64.exe") and A_Is64bitOS and A_IsUnicode
;			ahk=%A_ScriptDir%\Plugins\AutoHotkey\AutoHotkeyU64.exe
;		else if FileExist(A_ScriptDir "\Plugins\AutoHotkey\AutoHotkeyU32.exe") and A_IsUnicode
;			ahk=%A_ScriptDir%\Plugins\AutoHotkey\AutoHotkeyU32.exe
;		else if FileExist(A_ScriptDir "\Plugins\AutoHotkey\AutoHotkeyA32.exe") and !A_IsUnicode
;			ahk=%A_ScriptDir%\Plugins\AutoHotkey\AutoHotkeyA32.exe
;		else return
;	}
;	
;	;
;
;	for i, kwarg in kwargs
;		if ( option := SubStr(kwarg, 1, (i := InStr(kwarg, "="))-1) )
;		; the RegEx check is not really needed but is done anyways to avoid
;		; accidental override of internal local var(s)
;		&& ( option ~= "i)^child|name|dir|ahk|cp$" )
;			%option% := SubStr(kwarg, i+1)
;
;	pipe := (run_file := FileExist(script)) || (name == "*") ? 0 : []
;	Loop % pipe ? 2 : 0 ; number of elements in the pipe is max of 2 or 0
;	{
;		;// Create named pipe(s), throw exception on failure
;		if (( pipe[A_Index] := DllCall(
;		(Join, Q C
;			"CreateNamedPipe"            ; http://goo.gl/3aJQg7
;			"Str",  "\\.\pipe\" . name   ; lpName
;			"UInt", 2                    ; dwOpenMode = PIPE_ACCESS_OUTBOUND
;			"UInt", 0                    ; dwPipeMode = PIPE_TYPE_BYTE
;			"UInt", 255                  ; nMaxInstances
;			"UInt", 0                    ; nOutBufferSize
;			"UInt", 0                    ; nInBufferSize
;			"Ptr",  0                    ; nDefaultTimeOut
;			"Ptr",  0                    ; lpSecurityAttributes
;		)) ) == -1) ; INVALID_HANDLE_VALUE
;			throw Exception("ExecScript() - Failed to create named pipe", -1, A_LastError)
;	}
;
;	; Command = {ahk_exe} /ErrorStdOut /CP{codepage} {file}
;	static fso := ComObjCreate("Scripting.FileSystemObject")
;	static q := Chr(34) ;// quotes("), for v1.1 and v2.0-a compatibility
;	cmd := Format("{4}{1}{4} /ErrorStdOut /CP{2} {4}{3}{4}"
;	    , fso.GetAbsolutePathName(ahk)
;	    , cp="UTF-8" ? 65001 : cp="UTF-16" ? 1200 : cp := Round(LTrim(cp, "CPcp"))
;	    , pipe ? "\\.\pipe\" . name : run_file ? script : "*", q)
;	
;	; Process and append parameters to pass to the script
;	for each, arg in args
;	{
;		i := 0
;		while (i := InStr(arg, q,, i+1)) ;// escape '"' with '\'
;			if (SubStr(arg, i-1, 1) != "\")
;				arg := SubStr(arg, 1, i-1) . "\" . SubStr(arg, i++)
;		cmd .= " " . (InStr(arg, " ") ? q . arg . q : arg)
;	}
;
;	if cwd := (dir != "" ? A_WorkingDir : "") ;// change working directory if needed
;		SetWorkingDir %dir%
;
;	static WshShell := ComObjCreate("WScript.Shell")
;	exec := (child || name == "*") ? WshShell.Exec(cmd) : WshShell.Run(cmd)
;	
;	if cwd ;// restore working directory if altered above
;		SetWorkingDir %cwd%
;	
;	if !pipe ;// file or stdin(*)
;	{
;		if !run_file ;// run stdin
;			exec.StdIn.WriteLine(script), exec.StdIn.Close()
;		return exec
;	}
;	
;	DllCall("ConnectNamedPipe", "Ptr", pipe[1], "Ptr", 0) ;// http://goo.gl/pwTnxj
;	DllCall("CloseHandle", "Ptr", pipe[1])
;	DllCall("ConnectNamedPipe", "Ptr", pipe[2], "Ptr", 0)
;
;	if !(f := FileOpen(pipe[2], "h", cp))
;		return A_LastError
;	f.Write(script) ;// write dynamic code into pipe
;	f.Close(), DllCall("CloseHandle", "Ptr", pipe[2]) ;// close pipe
;	
;	return exec
;}
ExecScript(Script,ScriptName:="",ahkfullpath:="")
{
    ;added by aldrin john olaer manalansan
	if !FileExist(ahkfullpath) or (ahkfullpath="")
	{
		if FileExist(A_AhkPath)
			ahkfullpath:=A_AhkPath
		else if FileExist(A_ScriptDir "\Plugins\AutoHotkey\AutoHotkeyU64.exe") and A_Is64bitOS and A_IsUnicode
			ahkfullpath=%A_ScriptDir%\Plugins\AutoHotkey\AutoHotkeyU64.exe
		else if FileExist(A_ScriptDir "\Plugins\AutoHotkey\AutoHotkeyU32.exe") and A_IsUnicode
			ahkfullpath=%A_ScriptDir%\Plugins\AutoHotkey\AutoHotkeyU32.exe
		else if FileExist(A_ScriptDir "\Plugins\AutoHotkey\AutoHotkeyA32.exe") and !A_IsUnicode
			ahkfullpath=%A_ScriptDir%\Plugins\AutoHotkey\AutoHotkeyA32.exe
		else return "AHK Executable File Not Found"
	}
	if (ScriptName="")
		ScriptName:="_" A_TickCount "_"
	
	shell := ComObjCreate("WScript.Shell")
    exec := shell.Exec("""" ahkfullpath """ /ErrorStdOut *")
    exec.StdIn.Write(Script)
    exec.StdIn.Close()
	return exec
}
;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~END of Extractors~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Detectors~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
itemuserdetector(filecontent)
{ ; detects what hero uses the item in npc_dota_hero_ format
	filecontent:=miscusersdetector(filecontent)
	pos1:=instr(filecontent,"""",,,2)+1
	pos2:=instr(filecontent,"""",,,3)
	return substr(filecontent,pos1,pos2-pos1)
}

miscusersdetector(filecontent) {
;miscusersdetector detects multiple hero users from an item, example: almond the frondillo pet has multiple hero users
;filecontent	-	content extracted from items_game.txt
StringGetPos, tmppos, filecontent,"used_by_heroes"
StringGetPos, tmppos1, filecontent,`r`n%A_Tab%%A_Tab%%A_Tab%}`r`n,,%tmppos%
tmplength:=tmppos1-tmppos
startpos:=tmppos+2
StringMid,itemname,filecontent,%startpos%,%tmplength%
return,itemname
}

checkdetector() {
;checkdetector will check any field that exist on the listview "itemview"
	GuiControl,-g, showitems
	if A_DefaultListView<>showitems
	{
		Gui,MainGUI:ListView,showitems
	}
	LV_Modify(0, "-check")
	if A_DefaultListView<>itemview
	{
		Gui,MainGUI:ListView,itemview
	}
	Loop % LV_GetCount()
	{
		if A_DefaultListView<>itemview
		{
			Gui,MainGUI:ListView,itemview
		}
		rowint1=%A_Index%
		loop 7
		{
			LV_GetText(col%A_Index%,rowint1,A_Index)
		}
		if A_DefaultListView<>showitems
		{
			Gui,MainGUI:ListView,showitems
		}
		Loop % LV_GetCount()
		{
			rowint=%A_Index%
			loop 7
			{
				LV_GetText(col1%A_Index%,rowint,A_Index)
			}
			if col11=%col1%
			{
				if col12=%col2%
				{
					if col13=%col3%
					{
						if col14=%col4%
						{
							if col15=%col5%
							{
								LV_Modify(A_Index,"check")
								LV_Modify(A_Index,"Col7",col7)
								Break
							}
						}
					}
				}
			}
		}
	}
	GuiControl,+gdoitems, showitems
}

visualsdetector(filecontent) {
;detects the Visual Section of the content
;filecontent	-	content extracted from items_game.txt
StringGetPos, tmppos, filecontent,`r`n%A_Tab%%A_Tab%%A_Tab%"visuals"`r`n%A_Tab%%A_Tab%%A_Tab%{
StringGetPos, tmppos1, filecontent,`r`n%A_Tab%%A_Tab%%A_Tab%},,%tmppos%
tmplength:=tmppos1-tmppos
startpos:=tmppos+1
StringMid,itemname,filecontent,%startpos%,%tmplength%
return,itemname
}

modelpathchanger(ByRef itemname,ByRef savestring,searchstring) {
;modelpathchanger will return two variables:
;itemname	-	the root location directory of the item
;savestring	-	the whole information subcontent
;required variable:
;searchstring	-	sub-content that will be searched
StringGetPos, tmppos, searchstring,"model_player"
if tmppos<0
{
	VarSetCapacity(savestring,0)
}
else
{
	StringGetPos, tmppos1, searchstring,`r`n,,%tmppos%
	stringlength:=StrLen(searchstring)
	rightpos:=stringlength-tmppos
	StringGetPos, tmppos2, searchstring,`r`n,R1,%rightpos%
	tmplength:=tmppos1-tmppos2
	startpos:=tmppos2+1
	StringMid,itemname,searchstring,%startpos%,%tmplength%
	savestring=%itemname%
	StringGetPos, tmppos, itemname,"model_player"
	StringGetPos, tmppos1, itemname,",L3,%tmppos%
	StringGetPos, tmppos2, itemname,",L2,%tmppos1%
	tmplength:=tmppos2-tmppos1-1
	startpos:=tmppos1+2
	StringMid,itemname,itemname,%startpos%,%tmplength%
}
return
}

iddetector(filecontent) {
	;iddetector will detect an ID from a specific content
	;filecontent	-	a content extracted from items_game.txt
	StringGetPos, tmppos,filecontent,"
	StringGetPos, tmppos1,filecontent,",L2,%tmppos%
	tmplength:=tmppos1-tmppos-1
	startpos:=tmppos+2
	StringMid,tmpbar,filecontent,%startpos%,%tmplength%
	return,tmpbar
}

searchstringdetector(filecontent,searchstring) {
	;~~~~~~~~~~~
	;searchstringdetector will detect the item name from a content using a searchstring
	;searchstring	-	quoted commonly("string") this is the string that will be inspected on finding offest value
	;filecontent	-	a content extracted form items_game.txt
	
	;tmppos:=InStr(filecontent,searchstring)					; - determine the offset position of the serched string
	;~~~~~~~~~~~
	
	;~~~~~~~~~~~
	;stringdetector detects the righthand side name from an offset position
	;tmppos			-	offset position
	;filecontent	-	a content extracted from items_game.txt that will be scanned
	
	;tmppos1 := InStr(filecontent,"""",,tmppos,3)				; - Search for the first boundary which is a one double quotation mark(")
	;tmppos := InStr(filecontent,"""",,tmppos,4)				; - Search for the second boundary which is a one double quotation mark(")
	;itemname := SubStr(filecontent,tmppos1+1,tmppos-tmppos1-1)	; - Extract the characters between the two boundaries
	;~~~~~~~~~~~
	
	
	if tmppos:=InStr(filecontent,searchstring)
	{
		tmppos1 := InStr(filecontent,"""",,tmppos,3),tmppos := InStr(filecontent,"""",,tmppos,4),itemname := SubStr(filecontent,tmppos1+1,tmppos-tmppos1-1)
	}
	else
	{
		itemname=Undefined
	}
	return,itemname
}

modelpathdetector(filecontent,modelloop:=0) {
	;~~~~~~~~~~~
	;modelpathdetector will extract the cosmetic item's root directory location
	;modelloop	-	the number of present model names the hero item posseses, if ommited the value will automatically be zero
	;filecontent-	content extracted from items_game.txt
	
	;tmppos:=InStr(filecontent,"""model_player" modelloop """")					; - determine the offset position of the model with respect to its index
	;~~~~~~~~~~~
	
	;~~~~~~~~~~~
	;stringdetector detects the righthand side name from an offset position
	;tmppos			-	offset position
	;filecontent	-	a content extracted from items_game.txt that will be scanned
	
	;tmppos1 := InStr(filecontent,"""",,tmppos,3)				; - Search for the first boundary which is a one double quotation mark(")
	;tmppos := InStr(filecontent,"""",,tmppos,4)				; - Search for the second boundary which is a one double quotation mark(")
	;itemname := SubStr(filecontent,tmppos1+1,tmppos-tmppos1-1)	; - Extract the characters between the two boundaries
	;~~~~~~~~~~~
	;itemname := StrReplace(itemname,"/","\")					; - Changes slash into backslash(explorer directory mode)

	if modelloop=0 ; if modelloop is zero, then don't include any index value on the searched string
	{
		VarSetCapacity(modelloop,0)
	}
	if tmppos:=InStr(filecontent,"""model_player" modelloop """")
	{
		tmppos1 := InStr(filecontent,"""",,tmppos,3),tmppos := InStr(filecontent,"""",,tmppos,4),itemname := StrReplace(SubStr(filecontent,tmppos1+1,tmppos-tmppos1-1),"/","\")
	}
	return,itemname
}

stylecountdetector(filecontent) {
;stylecountdetector counts the number of allowed styles of an item
stylefinder=%A_Tab%%A_Tab%%A_Tab%%A_Tab%"styles"`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%{
stylescount=0
if InStr(filecontent,stylefinder)>0
{
	StringGetPos, stylepos, filecontent,%stylefinder%
	StringGetPos, stylepos1, filecontent,`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%}`r`n,,%stylepos%
	stylepos2:=stylepos1-stylepos
	StringMid,stylesname,filecontent,%stylepos%,%stylepos2%
	Loop
	{
		tmpbarrier=%A_Tab%%A_Tab%%A_Tab%%A_Tab%%A_Tab%"%A_Index%"
		if InStr(stylesname,tmpbarrier)>0
		{
			stylescount+=1
		}
		Else
		{
			Break
		}
	}
}
return,stylescount
}

stylechanger(stylechecker,filecontent) {
;stylechanger will change the style of all particle effects and even the model
;stylechecker(integer)	-	the numerical value of the style
;filecontent	-	a content extracted from the items_game.txt
stylefinder=%A_Tab%%A_Tab%%A_Tab%%A_Tab%"styles"`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%{
stylescount=0
if InStr(filecontent,stylefinder)>0
{
	StringGetPos, stylepos, filecontent,%stylefinder%
	StringGetPos, stylepos1, filecontent,`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%}`r`n,,%stylepos%
	StringGetPos, stylepos2, filecontent,`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%{`r`n,,%stylepos%
	StringGetPos, stylepos, filecontent,%A_Tab%,L5,%stylepos2%
	stylepos3:=stylepos1-stylepos+1
	StringMid,stylesname,filecontent,%stylepos%,%stylepos3%
	StringGetPos, stylepos, stylesname,%A_Tab%%A_Tab%%A_Tab%%A_Tab%%A_Tab%"%stylechecker%"
	StringGetPos, stylepos1, stylesname,`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%%A_Tab%},,%stylepos%
	StringGetPos, stylepos2, stylesname,},,%stylepos1%
	stylepos2:=stylepos2-stylepos+2
	StringMid,replacestylesname,stylesname,%stylepos%,%stylepos2%
	StringReplace,filecontent,filecontent,%stylesname%,%replacestylesname%,1
	StringReplace,filecontent,filecontent,`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%%A_Tab%"style"%A_Tab%%A_Tab%"%stylechecker%",,1
	StringReplace,filecontent,filecontent,`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%%A_Tab%"style"%A_Tab%%A_Tab%"0",`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%%A_Tab%"style"%A_Tab%%A_Tab%"%stylechecker%",1
	searchstring=%replacestylesname%
	modelpathchanger(itemname,savestring,searchstring) ; savestring returns the garbage and itemname returns our target modelpath
	if savestring<>
	{
		stringreplace,filecontent,filecontent,%savestring%,,1
		replaceas=%itemname%
		searchstring=%filecontent%
		modelpathchanger(itemname,savestring,searchstring) ; savestring returns the garbage and itemname returns our target modelpath
		stringreplace,filecontent,filecontent,%itemname%,%replaceas%,1
	}
}
return,filecontent
}

newiddetector(tmpstring,newfilestring:="") {
	;newiddetector will scan an ID from items_game.txt using a specific item name
	;tmpstring	-	item name
	;newfilestring	-	items_game.txt that will be the new value of the static variable "filestring"
	
	Static filestring
	if newfilestring<> ;if the caller wants to change the value of the static variable "filestring"
	{
		filestring:=newfilestring
	}
	
	if filestring= ; the function cannot operate properly if there is no reference items_game.txt, this will check if it is blank
	{
		ifexist,%A_ScriptDir%\Library\items_game.txt
		{
			filestring:=GlobalArray["items_game.txt"] ; redefine items_game.txt reference
		}
		if filestring=
		{
			return ; terminate function if still no value
		}
	}
	
	VarSetCapacity(tmpbar,0)
	Loop
	{
		StringGetPos, tmppos, filestring,`r`n%A_Tab%%A_Tab%%A_Tab%"name"%A_Tab%%A_Tab%"%tmpstring%"`r`n,L%A_Index%
		if tmppos<0
		{
			Break
		}
		filecontent:=keyworddetector(tmppos) ;filecontent:=keyworddetector(tmppos,filestring) ; tmppos:=offset position , filestring:=items_game.txt
		if (InStr(filecontent,"`r`n			""prefab""		""")>0) or (InStr(filecontent,"`r`n			""used_by_heroes""`r`n			{`r`n")>0)
		{
			tmpbar:=iddetector(filecontent) ;filecontent := extracted content from items_game.txt
			Break
		}
		if ErrorLevel=1 ; hunt this errorlevel
		{
			Break
		}
	}
	return,tmpbar
}

keyworddetector(tmppos,newfilestring:="") {
	;keyworddetector detects an item content using an offset position at items_game.txt
	;tmppos	-	offset position(integer)
	;filestring	-	items_game.txt
	
	Static filestring
	if newfilestring<> ;if the caller wants to change the value of the static variable "filestring"
	{
		filestring:=newfilestring
	}
	
	if filestring= ; the function cannot operate properly if there is no reference items_game.txt, this will check if it is blank
	{
		ifexist,%A_ScriptDir%\Library\items_game.txt
		{
			filestring:=GlobalArray["items_game.txt"] ; redefine items_game.txt reference
		}
		if filestring=
		{
			return ; terminate function if still no value
		}
	}
	
	pos := InStr(filestring,"		}`r`n		""",,1+tmppos-StrLen(filestring))
	pos2 := InStr(filestring,"`r`n		}",,tmppos)
	filecontent := SubStr(filestring,pos,pos2-pos)
	
	;StringLen,tmp,filestring
	;StringGetPos, tmppos1, filestring,%A_Tab%%A_Tab%}`r`n%A_Tab%%A_Tab%",,%tmppos% ;"
	;rightpos:=tmp-tmppos
	;StringGetPos, tmppos2, filestring,`r`n%A_Tab%%A_Tab%}`r`n%A_Tab%%A_Tab%",R1,%rightpos% ;"
	;StringGetPos, tmppos3, filestring,%A_Tab%%A_Tab%",,%tmppos2% ;"
	;tmplength:=tmppos1-tmppos3
	;startpos:=tmppos3
	;StringMid,filecontent,filestring,%startpos%,%tmplength%
	return,filecontent
}

miscdetector(searchedfilter,tmpfind,tmpstring,newfilestring:="") {
;miscdetector detects the contents of a miscellaneous item
;tmpfind	-	item slot of the miscellaneous(eg announcer or mega-kill announcer), this will confirm if the detected content is valid
;tmpstring	-	ID of the miscellaneous
;filestring	-	reference. it can be an extracted content or items_game.txt

	Static filestring
	if newfilestring<> ;if the caller wants to change the value of the static variable "filestring"
	{
		filestring:=newfilestring
	}
	
	if filestring= ; the function cannot operate properly if there is no reference items_game.txt, this will check if it is blank
	{
		ifexist,%A_ScriptDir%\Library\items_game.txt
		{
			filestring:=GlobalArray["items_game.txt"] ; redefine items_game.txt reference
		}
		if filestring=
		{
			return ; terminate function if still no value
		}
	}

	Finder=%A_Tab%%A_Tab%}`r`n%A_Tab%%A_Tab%"%tmpstring%"`r`n%A_Tab%%A_Tab%{
	Barrier=%A_Tab%%A_Tab%}`r`n%A_Tab%%A_Tab%" ;"
	filter1=`r`n%A_Tab%%A_Tab%%A_Tab%"%searchedfilter%"%A_Tab%%A_Tab%"%tmpfind%"`r`n
	FinderLength:=StrLen(Finder)
	Loop
	{
		StringGetPos, pos, filestring,%Finder%,L%A_Index%
		if pos<0
		{
			VarSetCapacity(filecontent,0)
			Break
		}
		
		pos1:=pos+FinderLength
		StringGetPos, pos2, filestring,%Barrier%,,%pos1%
		startpos:=pos+6
		pos3:=pos2-pos
		StringMid,filecontent,filestring,%startpos%,%pos3%
		if (ErrorLevel=1) or (InStr(filecontent,filter1)>0) ; hunt this errorlevel
		{
			Break
		}
	}
	return,filecontent
}

itemdetector(tmpstring,newfilestring:="") {
	;itemdetector will detect the contents of an ID using items_game.txt
	;tmpstring	-	is the ID of the contents you want to recover
	;filestring	-	items_game.txt contents
	
	Static filestring
	if newfilestring<> ;if the caller wants to change the value of the static variable "filestring"
	{
		filestring:=newfilestring
	}
	
	if filestring= ; the function cannot operate properly if there is no reference items_game.txt, this will check if it is blank
	{
		ifexist,%A_ScriptDir%\Library\items_game.txt
		{
			filestring:=GlobalArray["items_game.txt"] ; redefine items_game.txt reference
		}
		if filestring=
		{
			return ; terminate function if still no value
		}
	}
	
	Loop
	{
		;	pos := InStr(filestring,"		}`r`n		""" tmpstring """`r`n		{",,,A_Index)	-	scans for the first pattern(starting barrier)
		;	pos2 := InStr(filestring,"`r`n		}",,pos)											-	scans for the last pattern(ending barrier)
		;	filecontent := SubStr(filestring,pos,pos2-pos)											-	extracts the specified content between two barriers
		pos := InStr(filestring,"		}`r`n		""" tmpstring """`r`n		{",,,A_Index),pos2 := InStr(filestring,"`r`n		}",,pos),filecontent := SubStr(filestring,pos,pos2-pos)
		if ((InStr(filecontent,"prefab")>0) and (InStr(filecontent,"used_by_heroes")>0)) or (ErrorLevel=1) ; hunt this errorlevel
		{
			Break
		}
		if pos<=0
		{
			VarSetCapacity(filecontent,0)
			Break
		}
	}
	
	return,filecontent
}

npcherodetector(porthero,npcheroestxtdir,newnpchero:="") {
;npcherodetector will inspect npc_heroes.txt and extract the data of a certain hero
;porthero			-	the starting offset string. it commonly needs npc_dota_hero_*****
;npcheroestxtdir	-	location of npc_heroes.txt
;newnpchero			-	incase you want to replace the variable inside npc heroes
	
	Static npchero
	if newnpchero<> ;if the caller wants to change the value of the static variable "npchero"
	{
		npchero:=newnpchero
	}
	
	if npchero= ; the function cannot operate properly if there is no reference items_game.txt, this will check if it is blank
	{
		ifexist,%npcheroestxtdir%
		{
			fileread,npchero,%npcheroestxtdir% ; redefine items_game.txt reference
		}
		if npchero=
		{
			return ; terminate function if still no value
		}
	}
	;; npchero:=GlobalArray["npc_heroes.txt"]
	;; StringGetPos, portpos, npchero,`r`n%A_Tab%"%porthero% ;"
	;; StringGetPos, portpos1, npchero,`r`n%A_Tab%},,%portpos%
	;; StringMid,porthero,npchero,% portpos+1, % portpos1-portpos-1
	
	portpos := InStr(npchero,"`r`n	""" porthero) ; detects the leftmost barrier
	portpos1 := InStr(npchero,"`r`n	}",,portpos) ; detects the rightmost barrier
	porthero := SubStr(npchero,portpos+2,portpos1-portpos+2)
	
	return porthero
}

npcitemslotsdetector(herodata,ByRef itemslotscount,includetauntandpet:=0) {
;npcitemslotsdetector will extract tbe contents of the hero's item slots
;herodata			-	the contents of an hero which will be inspected by this function
;itemslotscount		-	any variable stored here will return the number of item slots found here()
;includetauntandpet	-	if this is equal to 1, it will include the taunt slot and pet slot when counting the number of item slots that will be returned for variable "itemslotscount"

	portpos := InStr(herodata,"`r`n		""ItemSlots""`r`n") ; detects the leftmost barrier
	portpos1 := InStr(herodata,"`r`n		}",,portpos) ; detects the rightmost barrier
	itemslotscontent := SubStr(herodata,portpos+2,portpos1-portpos+3)
	itemslotscount:=0 ; starting number of slot count
	;allitemslots:=[] ; declare as an array
	loop
	{
		portpos := InStr(itemslotscontent,"""`r`n			{",,,A_Index) ; detects the leftmost barrier
		if (ErrorLevel<>1) and (portpos>0)
		{
			portpos1 := InStr(itemslotscontent,"`r`n			}",,portpos) ; detects the rightmost barrier
			slotdata:=SubStr(itemslotscontent,portpos-2,portpos1-portpos+8)	;detects the specific slot content
			slotname:=searchstringdetector(slotdata,"""SlotName""") ; detects the specific slot name
			if (slotname<>"taunt") and (slotname<>"ambient_effects")
			{
				if (slotname<>"summon") or ((slotname="summon") and (InStr(slotdata,"""npc_dota_companion""")<=0))
				{
					itemslotscount++
				}
			}
			else if includetauntandpet=1
				itemslotscount++
			
			;; tells whether the string is already a value of an element of this array
			;for index, value in allitemslots
			;{
			;	if value = %slotname%
			;	{
			;		boolean=1
			;		break
			;	}
			;	else if shit<>0
			;	{
			;		boolean=0
			;	}
			;}
			
			if A_DefaultListView<>statscalibrator
			{
				Gui, MainGUI:ListView,statscalibrator
			}
			boolean=0
			loop % LV_GetCount()
			{
				LV_GetText(value,A_Index,1)
				
				if value = %slotname%
				{
					boolean=1
					break
				}
			}
			
			;
			
			if boolean=0
			{
				;allitemslots.push(slotname) ; stores the itemslot name to the last unused element(rightmost element)
				
				if (slotname<>"taunt") and (slotname<>"ambient_effects")
					LV_Add("+Check",slotname)
				else LV_Add("-Check",slotname)
				LV_ModifyCol(1,"AutoHdr Sort")
			}
			
		}
		else
		{
			break
		}
	}
	;;construct the calibrator
	;loop % allitemslots.Length()
	;{
	;	if A_DefaultListView<>statscalibrator
	;	{
	;		Gui, MainGUI:ListView,statscalibrator
	;	}
	;	if (allitemslots[A_Index]<>"taunt") and (allitemslots[A_Index]<>"ambient_effects")
	;		LV_Add("+Check",allitemslots[A_Index])
	;	else LV_Add("-Check",allitemslots[A_Index])
	;}
	;LV_ModifyCol(1,"AutoHdr Sort")
	;;
	
	return itemslotscontent
}

refreshnpcitemslotsdetector(herodata,ByRef itemslotscount) {
;npcitemslotsdetector will extract tbe contents of the hero's item slots
;herodata			-	the contents of an hero which will be inspected by this function
;itemslotscount		-	any variable stored here will return the number of item slots found here()

	portpos := InStr(herodata,"`r`n		""ItemSlots""`r`n") ; detects the leftmost barrier
	portpos1 := InStr(herodata,"`r`n		}",,portpos) ; detects the rightmost barrier
	itemslotscontent := SubStr(herodata,portpos+2,portpos1-portpos+3)
	itemslotscount:=0 ; starting number of slot count
	;allitemslots:=[] ; declare as an array
	loop
	{
		portpos := InStr(itemslotscontent,"""`r`n			{",,,A_Index) ; detects the leftmost barrier
		if (ErrorLevel<>1) and (portpos>0)
		{
			portpos1 := InStr(itemslotscontent,"`r`n			}",,portpos) ; detects the rightmost barrier
			slotdata:=SubStr(itemslotscontent,portpos-2,portpos1-portpos+8)	;detects the specific slot content
			slotname:=searchstringdetector(slotdata,"""SlotName""") ; detects the specific slot name
			
			if (slotname<>"summon") or ((slotname="summon") and (InStr(slotdata,"""npc_dota_companion""")<=0))
			{
				if A_DefaultListView<>statscalibrator
				{
					Gui, MainGUI:ListView,statscalibrator
				}
				loop % LV_GetCount()
				{
					 if LV_GetNext(A_Index-1,"Checked")=A_Index ; if this row was checked
					 {
						LV_GetText(value,A_Index,1)
						if value=%slotname% ; if they both slot name matched, means it existed as referenced
							itemslotscount++
						
					 }
				}
			}
			
		}
		else
		{
			break
		}
	}
	
	return itemslotscontent
}
;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~End of Detectors~~~~~~~~~~~~~~~~~~~~~~~~~~~

lvautosize:
loop % LV_GetCount("Column")
{
	LV_ModifyCol(A_Index,"AutoHdr")
}
return

invdelete:
Gui, MainGUI:Default
if A_DefaultListView<>invlv
{
	Gui, MainGUI:ListView, invlv
}
gosub,deleterow
return

deleterow:
Gui,MainGUI:+Disabled
GuiControl, MainGUI:-Redraw,%A_DefaultListView%
invrownumber = 0
Loop
{
    invrownumber := LV_GetNext(invrownumber - 1)
    if not invrownumber
        break
    LV_Delete(invrownumber)
}
GoSub,lvautosize
GuiControl, MainGUI:+Redraw,%A_DefaultListView%
Gui,MainGUI:-Disabled
return

invlv:
if A_GuiEvent = DoubleClick
{
	Gui, MainGUI:Default
	if A_DefaultListView<>invlv
	{
		Gui, MainGUI:ListView, invlv
	}
	LV_GetText(mapinjectfrom, A_EventInfo,1)
	LV_GetText(mapinjectto, A_EventInfo,2)
	if mapinjectfrom=Resource ID
	{
		return
	}
	else if mapinjectto=Injected ID
	{
		return
	}
	GuiControl,Text,injectfrom,%mapinjectfrom%
	GuiControl,Text,injectto,%mapinjectto%
	Gui,MainGUI:Submit,NoHide
}
else if A_GuiEvent = RightClick
{
	Gui, MainGUI:Default
	if A_DefaultListView<>invlv
	{
		Gui, MainGUI:ListView, invlv
	}
	LV_GetText(stylescount,A_EventInfo,5)
	LV_GetText(countcheck,A_EventInfo,6)
	if stylescount>%countcheck%
	{
		LV_Modify(A_EventInfo,"Select" "Col6",,,,,,countcheck+1)
	}
	else
	{
		LV_Modify(A_EventInfo,"Select" "Col6",,,,,,"0")
	}
}
return

invccabout:
Gui, aboutgui:+ownerMainGUI
Gui,MainGUI:+Disabled
Gui, aboutgui:+Resize +MinSize
Gui, aboutgui:Add, Tab2,x0 y0 h450 w500 vtababout, About|Limitations|What's New|Fact|Tutorials|Credits
Gui,aboutgui:Add,Edit,x0 y20 h400 w500 ReadOnly vtext35,Version %version%`n`nAJOM's Dota 2 MOD Master is a "code analyzing tool" which targets present "ID" and copies its contents`, thus replacing the other target "ID's" contents simultaneously. Since manual "copy/paste" method on items_game.txt(accourding to my experience) is hard enough`,this tool is best and can sacrifice less effort on your time.`n`nOne of the best reasons why I(Aldrin John Olaer Manalansan) created this tool is that:`n->Imagine every released "patch" of DOTA2`, they add new codes inside "items_game.txt" so that they can register its "use". Also`,you might not notice`, they change some existed "ID's Contents" into something new`, without you ever knowing.`n->Generates a "Modified Clone" of "items_game.txt" from the "Library" Folder where all the desired code are injected.
Gui, aboutgui:Tab,2
Gui,aboutgui:Add,Edit,x0 y20 h400 w500 ReadOnly vtext44,
(
This Tool gives a bright help for MODDING DOTA2 and is very handy compared to manual MODDING, but there will always be Limitations that this Injector(Until now) Cannot Fix.Current Issues that exist(7.25 patch):

*This Tool needs to ReRun and ReInject all Item Sets every New Update/Patch with newly arrived items. It is because "items_game.txt" which is the script inside the MOD needs to be Reupdated/Repatched, the injector's work is to ReUpdate the Script to be compatible with the newly arrived items listed at the new "items_game.txt". IF THIS INSTRUCTION IS NOT FOLLOWED, YOU WILL ENCOUNTER WHEN LAUNCHING DOTA2 "ERROR PARSING SCRIPT" WHICH WILL IMMEDIATELY CRASH YOUR DOTA2 AND WILL REMAIN UNPLAYABLE UNTIL YOU EITHER "REMOVE THE MOD FROM YOUR DOTA2" OR "RELAUNCH THE TOOL AND REINJECT ALL ITEM SETS". Take Responsibility on the Risks!!!

*Bristleback's "Piston Impaler" item does not stack with "Mace of the Wrathrunner(morning-star like)" item. This is due to the unhandled process of bristleback's "piston impaler animation" vs bristleback's "morning-star animation".

*When playing "Online" Mode, some item skin parts for heroes do not show if "it has no default cosmetic item". In other words, this following posibilities will occur:
-Ancient Apparition's "Shattering Blast Crown" "Head" item does not show up because "there is no default head item attached to Ancient Apparition".
-Tinker's "Boots of Travel" "Misc" item does not show up because "there is no default misc item attached to Tinker".

This problem is common on "Modding by Scripting Method" but the MOD perfectly works on "offline/LAN mode".

*Cosmetic items that "the model's item animation was substituted into the default model animation" does not function properly as expected, Example:
-The animation of Legion Commander's "Blades of Voth Domosh" functions as single wield type animation (wields only one sword).
-Techies "Swine of the Sunken Gallery Set's" third member(which is Spoon) does not walk properly.
-Witch Doctor's "Bonkers the Mad's" Monkey was not moving properly but instead was touching witch doctor's Butt.
)
Gui, aboutgui:Tab,3
Gui,aboutgui:Add,Edit,x0 y20 h400 w500 ReadOnly vtext36,
(
v2.5.4
*Fixed a Bug where all .vmdl files are not flagged as "compiled", resulting all units to have statued animation.
*Fixed a Bug when the tool wants you to determe "dota 2 beta location", it does not fetch the selected location

v2.5.3
*Fixed a Bug that Library files sometimes does not extract. and get fetched.

v2.5.2
*Improved Dotnet Detection

v2.5.1
*Fixed a bug where a Command Prompt(cmd) sometimes pops up.
*Recallibrated "Maximum Threads", last time it wait for all "n" number of threads to close, now it makes sure that only "n" number of threads run always

v2.5.0
*SPEEDY VERSION. Advisable to migrate on this version.
*Database Version 1.5 changed the previous v1 database version. This Database version is faster than the previous database version... But still Version 2(experimental) is still unbeatable when it comes to saving/preloading speed.
*Added "Maximum Threads" at "Advanced Section". This will limit how many simultaneous threads that can be used by DOTA2 MOD Master to extract model,particle effect files.
*Some bug fixes.
)
Gui, aboutgui:Tab,4
Gui,aboutgui:Add,Edit,x0 y20 h400 w500 vtext37 ReadOnly,
(
*Right-Click an item to change "Styles"(if it has an available alternative style).

*At "Handy Injection>Hero Items Selection" Section,every Hero can ONLY have ONE ITEM PER ITEM SLOT. Adding a "Check" Mark on an item will REMOVE THE OTHER CHECK MARK ON AN ITEM WITH THE SAME ITEM SLOT(eg. juggernaut's bladeform legacy is an Head Item slot, it will deselect any item that are Head Item Slot Like Mask of a Thousand Faces).

*On every Dropdownlist(eg. The Custom Items Location Path Found at the General Section... The gameinfo.gi Location Path found at the Advanced Section), to clear the control just left click the dropdownlist and left click the location path. This will clear the location path and disable its future controls.

*To Manually Patch gameinfo.gi using the injector, go to "advanced>patch gameinfo.gi". Clicking this button will Activate the MOD(pak01_dir.vpk) found at "%dota2dir%\" Folder.

*It is good that "use miscellaneous on future injection" Feature at "Miscellaneous" Section is "TURNED OFF" if you do not use any feature on that section. Because every start, this Tool will need to preload all miscellaneous assets which will consume much time

*"AUTO-SHUTNIK METHOD" is a very important feature of this Tool,it was built for users who dont know how to "Manually MOD DOTA2".

*Turning Off "AUTO-SHUTNIK METHOD" will Generate a "pak01_dir" folder at the "Generated MOD" Folder found on the same folder of this Tool. This is HELPFUL for users who wants to MANUALLY MOD DOTA2

*Turning ON "Low-Processor Mode" at "Advanced" Section will command this Tool not to consume alot of RAM when "Injecting items", executing only ONE COMMAND PROMPT to execute the Extraction of Items through their specific locations. BUT AS PENALTY, it will CONSUME ALOT OF TIME for the Injection to Finish!!! So if you are "Injecting 400 items"... I appoximate each items will be extracted after "5 seconds", so 400 x 5 is equal to 2000 seconds(33 minutes)

*"Save Settings" button on the bottom left does NOT SAVE DATALISTS,it only saves "directories" which you selected and checkboxes that are not inside a "DATALIST". If you want to save a Datalist. Use "Save DataBase List" instead.

*"Save DataBase List" at "Hero Items Selection" and "Used Items Database" from Handy Injection Section do the same thing.

*"Save DataBase List" at the "General" Section is different on "Save DataBase List" for "Handy Injection". In other words, it only saves the datalist PRESENT ON THAT SECTION PLUS ALL Miscellaneous DATALIST(if enabled).

*"Migration" Feature only prioritize items with "prefab=default_item". In other words, it does not support "terrain,weather,hud,loadingscreen,ect"

*At "Search" Section,You can press "Enter/Return" Key and it will do the same job pressing "Search for(keyword)" button.

*Pressing "Search for(keyword)" Button(Or Enter/Return) with the same "Keyword" you have searched last time will move to the next occurence... Until there is no match found`, it will go back to the very first occurence.

*The "ERROR LOG" at "Advanced" Section reports certain coincidence that is rarely different from what the injector has scanned before the last launch. This happens when a new update comes out with newly added cosmetic items, those items are registered at the "items_game.txt" that have unique ID's that not present on the earlier patches. But sometimes, they are REGISTERED AT AN EXISTED ID... While the OLD REGISTERED item on that ID that was REPLACED by this newly arrived item`,was MOVED INTO ANOTHER UNIQUE ID!!! So this Tool will able to detect those coincidence WHEN YOU HAVE A DATABASE.

*Expect that when an "ITEM was Announced" at the "ERROR LOG",it will be UNCHECKED at either "Handy Injection" section or "General" Section, in other words it will be unused. You need to "recheck" it again on that section to "Activate" it again.

*This Tool detects the DOTA2 Directory by pairing a combination pattern... It scans all Folder inside the "steamapps\common" then scans if the picked folder has "game\dota" subfolder inside.

*The Injector needs 150MB of RAM when making its Operation. If your computer is very weak to handle this amount of memory, then please do not use this injector and Throw this Tool at your Recycle Bin!
)
Gui, aboutgui:Tab,5
Gui,aboutgui:Add, Link,vtext39,*General Section: <a href="https://www.youtube.com/watch?v=N8POaZ2nXbA&t=25s">https://www.youtube.com/watch?v=N8POaZ2nXbA&t=25s</a>
Gui,aboutgui:Add, Link,vtext40,*Handy Injection Section: <a href="https://www.youtube.com/watch?v=-BETnaBBLME&t=25s">https://www.youtube.com/watch?v=-BETnaBBLME&t=25s</a>
Gui,aboutgui:Add, Link,vtext41,*Miscellaneous Section: <a href="https://www.youtube.com/watch?v=y9HYHBtBYXs&t=834s">https://www.youtube.com/watch?v=y9HYHBtBYXs&t=834s</a>
Gui,aboutgui:Add, Link,vtext50,*External Files: <a href="https://www.youtube.com/watch?v=eG2XRCj7Sy0&t=365s">https://www.youtube.com/watch?v=eG2XRCj7Sy0&t=365s</a>
Gui,aboutgui:Add, Link,vtext33,*Create your Own Database: <a href="https://www.youtube.com/watch?v=kC1-2UtXp_U">https://www.youtube.com/watch?v=kC1-2UtXp_U</a>
Gui,aboutgui:Add, Link,vtext34,*Edit a Database: <a href="https://www.youtube.com/watch?v=wF2DnfrgWkg">https://www.youtube.com/watch?v=wF2DnfrgWkg</a>
Gui,aboutgui:Add, Link,vtext42,*ERROR! Items_game.txt is missing!: <a href="https://www.youtube.com/watch?v=l4w2fT_lY10&t=3s">https://www.youtube.com/watch?v=l4w2fT_lY10&t=3s</a>
Gui, aboutgui:Tab,6
Gui,aboutgui:Add, Link,vtext53,*<a href="https://www.autohotkey.com/boards/">AutoHotkey Community</a>
Gui,aboutgui:Add, Link,vtext54,*<a href="https://github.com/SteamDatabase/ValveResourceFormat">xPaw's Valve's Source 2 resource file format Decompiler</a>
Gui,aboutgui:Add, Link,vtext55,*<a href="http://nemesis.thewavelength.net/index.php?p=35">Nem's HLLib</a>
Gui,aboutgui:Add, Link,vtext56,*<a href="http://gnuwin32.sourceforge.net/packages/unzip.htm">Unzip by Info-Zip</a>
Gui,aboutgui:Add, Link,vtext57,*<a href="https://dota2modss.blogspot.com/2016/05/how-to-install-mods-dota-2-reborn-with.html">VPKCreator by Steam</a>
Gui, aboutgui:Tab
Gui, aboutgui:Add, Button, vtext43 x230 y420, OK
Gui,aboutgui:Show,h450 w500,About AJOM's Dota 2 MOD Master
return

aboutguiButtonOK:
aboutguiGuiClose:
aboutguiGuiEscape:
Gui,MainGUI:-Disabled
Gui,aboutgui:Destroy
return

k_MenuExit:
MainGUIGuiClose:
gosub,savetab
if updatewassuccessful=1
	ifexist,%A_ScriptDir%\Plugins\Unzip\master.zip
		gosub,updatemigrator
ExitApp
return

savetab:
Gui,MainGUI:Submit,NoHide
tabparam=tablist,intablist,intablist1,intablist2
tabparam1=choosetab,inchoosetab,inchoosetab1,inchoosetab2
tabparam2=OuterTab,%innertabparam%
loop,Parse,tabparam,`,
{
	intparam=%A_Index%
	loop,parse,%A_LoopField%,|
	{
		save=%A_LoopField%
		intparam1=%A_Index%
		loop,parse,tabparam2,`,
		{
			if (save=%A_LoopField%) and (intparam=A_Index)
			{
				loop,Parse,tabparam1,`,
				{
					if intparam=%A_Index%
					{
						FileSetAttrib,-R,%A_ScriptDir%\Settings.aldrin_dota2mod
						IniWrite,%intparam1%,%A_ScriptDir%\Settings.aldrin_dota2mod,Edits,%A_LoopField%
						FileSetAttrib,+R,%A_ScriptDir%\Settings.aldrin_dota2mod
					}
				}
			}
		}
	}
}
return

invbrowse:
Gui MainGUI:+OwnDialogs
Gui,MainGUI:Submit,NoHide
FileSelectFile,invfile,3,,items_game.txt,items_game.txt
checker:=SubStr(invfile,-13,14)
If checker=items_game.txt
{
	GuiControl,Text,invdirview,%invfile%||
}
return

databrowse:
Gui MainGUI:+OwnDialogs
gosub,leakdestroyer
FileSelectFile,invfile,3,,.aldrin_dota2db,*.aldrin_dota2db
If SubStr(invfile,-14,15)=.aldrin_dota2db
{
	GuiControl,Text,datadirview,%invfile%||
	Gui,MainGUI:Submit,NoHide
	Gui, MainGUI:Default
	Gui, MainGUI:+Disabled 
	if A_DefaultListView<>invlv
	{
		Gui, MainGUI:ListView, invlv
	}
	LV_ClearAll()
	VarSetCapacity(maperrorshow,0)
	GuiControl,Text,errorshow,
	FileRead,FileData,%invfile%
	VarWrite(,FileData) ; remember the contents of the variable and store to "static Var"
	VarRead(,FileData) ; remember the contents of the variable and store to "static Var" that is inspected by varread
	GoSub,datareload
	if usemiscon=1
	{
		reloadmisc(invfile) ; ;Scans the database then put a checkmark on each miscellaneous it uses
	}
	
	tmpr:=VarWrite(,"GetVar")
	if (FileData!=tmpr) and (tmpr!="") ; renew the database
	{
		FileSetAttrib,-R,%datadirview%
		FileDelete,%datadirview%
		FileAppend,%tmpr%,%datadirview%  ;"VarWrite( ,"GetVar")" function returns the text that will be stored in the file choosed by user, the first parameter must be omitted or blank
		FileSetAttrib,+RH,%datadirview%
	}
	
	if soundon=1
	{
		SoundPlay,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\Sound\loaddatacomplete.wav
	}
	Gui,MainGUI:Submit,NoHide
	GuiControl,MainGUI:Text,searchnofound,%defaultshoutout%
	GuiControl,MainGUI:Show,searchnofound
	if errorshow<>
	{
		msgbox,16,ERROR DETECTED!,Preloading Database Complete! But There are ERRORS Detected and the Injector Distinguished them All. Check the "Advance" Section to view the ERROR Report and How the Injector Dealt them.
	}
	Gui, MainGUI:-Disabled 
}
gosub,leakdestroyer
return

datasave:
gosub,leakdestroyer
Gui, MainGUI:Submit, NoHide
Gui, MainGUI:Default
if A_DefaultListView<>invlv
{
	Gui, MainGUI:ListView, invlv
}
GuiControl, MainGUI:-Redraw, invlv
if LV_GetCount()=0
{
	GuiControl,MainGUI:Text,searchnofound,%defaultshoutout%
	GuiControl,MainGUI:Show,searchnofound
	gosub,hideprogress
	
	return
}
Gui, MainGUI:-Disabled 
;FileSelectFile,invfile,S24,,.aldrin_dota2db,*.aldrin_dota2db

;;; SaveFile Returns two index on an object:
;;; File			-	the inputted filename
;;; FileTypeIndex	-	the chosen Filter(Files of type dropdownlist of the explorer gui)... This will Return the number of row of the selected filetype extension
MyObject := SaveFile( [0, "Name your Database and Specify where to Save"]    ; [owner, title/prompt]
             , ""    ; RootDir\Filename
             , {"General Database Version 1.5": "*.aldrin_dota2db"} ; Filter
			 , 2	 ; Chosen Row at Filter Dropdownlist. Take note that the arrangement IS SORTED FIRST at the beggining, so after the arrangement of filter was sorted it will next choose the "2nd" row.
             , ""    ; CustomPlaces
             , 2)    ; Options ( 2 = FOS_OVERWRITEPROMPT )
invfile := MyObject.File

if invfile<>
{
	VarWrite( ) ; blanks Function Static "Var" variable! Always start Writing in a blank variable, avoiding Rewritings (Faster) 
	;if MyObject.FileTypeIndex=1
	;{
		Gui,MainGUI:Show,NA
		adder:=1000/LV_GetCount()
		progress=0
		gosub,showprogress
		If SubStr(invfile,-14,15)<>.aldrin_dota2db
		{
			invfile=%invfile%.aldrin_dota2db
		}
		IfExist,%invfile%
		{
			FileSetAttrib,-R,%invfile%
			FileDelete, %invfile%
		}
		;FileAppend,,%invfile%
		Loop % LV_GetCount()
		{
			LV_GetText(tmp,A_Index,1)
			VarWrite("ResourceID" A_Index,tmp)	;VarWrite(Key := "", Value := "") ; Saves the Database Version for future version detection
			;IniWrite, %tmp%, %invfile%, Edits, ResourceID%A_Index%
			
			LV_GetText(tmp,A_Index,2)
			VarWrite("IDInjected" A_Index,tmp)	;VarWrite(Key := "", Value := "") ; Saves the Database Version for future version detection
			;IniWrite, %tmp%, %invfile%, Edits, IDInjected%A_Index%
			
			LV_GetText(tmp,A_Index,3)
			VarWrite("ResourceIDName" A_Index,tmp)	;VarWrite(Key := "", Value := "") ; Saves the Database Version for future version detection
			;IniWrite, %tmp%, %invfile%, Edits, ResourceIDName%A_Index%
			
			LV_GetText(tmp,A_Index,4)
			VarWrite("IDInjectedName" A_Index,tmp)	;VarWrite(Key := "", Value := "") ; Saves the Database Version for future version detection
			;IniWrite, %tmp%, %invfile%, Edits, IDInjectedName%A_Index%
			
			LV_GetText(tmp,A_Index,6)
			VarWrite("ActiveStyle" A_Index,tmp)	;VarWrite(Key := "", Value := "") ; Saves the Database Version for future version detection
			;IniWrite, %tmp%, %invfile%, Edits, ActiveStyle%A_Index%
			
			if ( A_Index = LV_GetNext(A_Index-1,"Checked"))
			{
				VarWrite("ResourceID" A_Index "Enabled","+")	;VarWrite(Key := "", Value := "") ; Saves the Database Version for future version detection
				;IniWrite,+, %invfile%, Edits, ResourceID%A_Index%Enabled
			}
			else
			{
				VarWrite("ResourceID" A_Index "Enabled","-")	;VarWrite(Key := "", Value := "") ; Saves the Database Version for future version detection
				;IniWrite,-, %invfile%, Edits, ResourceID%A_Index%Enabled
			}
			
			progress+=adder
			GuiControl,MainGUI:, MyProgress,%progress%
		}
		gosub,hideprogress
		
		VarWrite("RegisteredDirectory",LV_GetCount())	;VarWrite(Key := "", Value := "") ; Saves the Database Version for future version detection
		;IniWrite, % LV_GetCount(), %invfile%, Edits, RegisteredDirectory
		
		if usemiscon=1
		{
			GoSub,savemisc
		}
		VarWrite("@DataBaseVersion!","1.5")	;VarWrite(Key := "", Value := "") ; Saves the Database Version for future version detection
		FileAppend,% VarWrite( , "GetVar"),%invfile%  ;"VarWrite( ,"GetVar")" function returns the text that will be stored in the file choosed by user, the first parameter must be omitted or blank
		;FileSetAttrib,+R,%invfile% ; protect the setting file from noobs
	;}
	if soundon=1
	{
		SoundPlay,%A_Temp%\AJOM Innovations\DOTA2 MOD Master\Sound\savedatacomplete.wav
	}
}
GuiControl,MainGUI:Text,searchnofound,%defaultshoutout%
GuiControl,MainGUI:Show,searchnofound
GuiControl, MainGUI:+Redraw, invlv
Gui, MainGUI:-Disabled 
gosub,leakdestroyer
return

buttonsearch:
Gui,MainGUI:Submit,NoHide
if searchbar<>
{
	ifnotexist,%A_ScriptDir%\Library\items_game.txt
	{
		msgbox,16,Error!!!,"%A_ScriptDir%\Library\items_game.txt"`n`nIs Missing!!! Make sure to add the original "items_game.txt" at "%A_ScriptDir%\Library" Folder.`n`nIf you dont have an Idea how to get the original "items_game.txt" use "GCFScape.exe" or "Valve's Resource Viewer" application to access "Pak01_dir.vpk". Inside the VPK Archive`,Hit "Ctrl+F"(Find) and search for "items_game.txt". If successfully found`, extract it(items_game.txt) at "%A_ScriptDir%\Library\" Folder.
		return
	}
	filestring:=GlobalArray["items_game.txt"]
	StringLen, filelength, filestring
	sfinder=`r`n%A_Tab%%A_Tab%}`r`n%A_Tab%%A_Tab%" ;"
	Loop
	{
		if searchbarsaver=%searchbar%
		{
			if A_Index<=%searchnext%
			{
				continue
			}
		}
		else
		{
			searchnext=1
		}
		StringGetPos, spos, filestring,%searchbar%,L%A_Index%
		rightpos:=filelength-spos
		StringGetPos, spos1, filestring,%sfinder%,,%spos%
		StringGetPos, spos2, filestring,%sfinder%,R1,%rightpos%
		startpos:=spos2+8
		spos3:=spos1-spos2
		StringMid,filecontent,filestring,%startpos%,%spos3%
		if InStr(filecontent,"prefab")>0
		{
			if searchbarsaver=%searchbar%
			{
				if oldfilecontent<>%filecontent%
				{
					oldfilecontent=%filecontent%
					searchnext=%A_Index%
					Break
				}
				else
				{
					oldfilecontent=%filecontent%
				}
			}
			else
			{
				oldfilecontent=%filecontent%
				Break
			}
		}
		else
		{
			VarSetCapacity(filecontent,0)
		}
		if ErrorLevel=1 ; hunt this errorlevel
		{
			GuiControl,+cRed, searchnofound
			if searchbarsaver=%searchbar%
			{
				GuiControl,Text, searchnofound,No Matched Item Found this Time!
				searchnext=0
			}
			else
			{
				GuiControl,Text, searchnofound,No Matched Item Found!
				searchnext=0
			}
			sleep 1000
			GuiControl,+cDefault, searchnofound
			GuiControl,MainGUI:Text,searchnofound,%defaultshoutout%
			GuiControl,MainGUI:Show,searchnofound
			return
		}
	}
	searchbarsaver=%searchbar%
	if filecontent<>
	{
		param1=namebar|prefabbar|itemslotbar|modelpathbar|heroesbar
		param2="name"|"prefab"|"item_slot"|"model_player"|"used_by_heroes"
		loop,parse,param2,|
		{
			StringGetPos, tmppos,filecontent,%A_LoopField%
			StringGetPos, tmppos1,filecontent,",L3,%tmppos%
			StringGetPos, tmppos2,filecontent,",L2,%tmppos1%
			tmplength:=tmppos2-tmppos1-1
			startpos:=tmppos1+2
			StringMid,tmpbar,filecontent,%startpos%,%tmplength%
			integer=%A_Index%
			loop,parse,param1,|
			{
				if integer=%A_Index%
				{
					if (tmpbar="") or (tmpbar="name")
						tmpbar=Undefined
					GuiControl,Text,%A_LoopField%,%tmpbar%
					Break
				}
			}
		}
		StringReplace,filecontent,filecontent,`r`n%A_Tab%%A_Tab%,`r`n,1
		StringTrimLeft, filecontent, filecontent, 2
		tmpbar:=iddetector(filecontent) ;filecontent := extracted content from items_game.txt
		GuiControl,Text,idbar,%tmpbar%
		GuiControl,Text,searchshow,%filecontent%
	}
}
return

;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Functions~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; =================================================================================
; Function: AutoXYWH
;   Move and resize control automatically when GUI resizes.
; Parameters:
;   DimSize - Can be one or more of x/y/w/h  optional followed by a fraction
;             add a '*' to DimSize to 'MoveDraw' the controls rather then just 'Move', this is recommended for Groupboxes
;   cList   - variadic list of ControlIDs
;             ControlID can be a control HWND, associated variable name, ClassNN or displayed text.
;             The later (displayed text) is possible but not recommend since not very reliable 
; Examples:
;   AutoXYWH("xy", "Btn1", "Btn2")
;   AutoXYWH("w0.5 h 0.75", hEdit, "displayed text", "vLabel", "Button1")
;   AutoXYWH("*w0.5 h 0.75", hGroupbox1, "GrbChoices")
; ---------------------------------------------------------------------------------
; Version: 2015-5-29 / Added 'reset' option (by tmplinshi)
;          2014-7-03 / toralf
;          2014-1-2  / tmplinshi
; requires AHK version : 1.1.13.01+
; =================================================================================
AutoXYWH(DimSize,cList*)
{       ; http://ahkscript.org/boards/viewtopic.php?t=1079
	static cInfo := {}
 
	If (DimSize = "reset")
		Return cInfo := {}

	For i, ctrl in cList
	{
		if IsObject(ctrl)
		{
			For i, value in ctrl
			{
				ctrlID := A_Gui ":" value
				If ( cInfo[ctrlID].x = "" )
				{
					GuiControlGet, i, %A_Gui%:Pos, %value%
					MMD := InStr(DimSize, "*") ? "MoveDraw" : "Move"
					fx := fy := fw := fh := 0
					For i, dim in (a := StrSplit(RegExReplace(DimSize, "i)[^xywh]")))
						If !RegExMatch(DimSize, "i)" dim "\s*\K[\d.-]+", f%dim%)
							f%dim% := 1
					cInfo[ctrlID] := { x:ix, fx:fx, y:iy, fy:fy, w:iw, fw:fw, h:ih, fh:fh, gw:A_GuiWidth, gh:A_GuiHeight, a:a , m:MMD}
				}
				Else If ( cInfo[ctrlID].a.1)
				{
					dgx := dgw := A_GuiWidth  - cInfo[ctrlID].gw  , dgy := dgh := A_GuiHeight - cInfo[ctrlID].gh
					For i, dim in cInfo[ctrlID]["a"]
						Options .= dim (dg%dim% * cInfo[ctrlID]["f" dim] + cInfo[ctrlID][dim]) A_Space
					GuiControl, % A_Gui ":" cInfo[ctrlID].m , % value, % Options
				}
			}
		}
		else
		{
			ctrlID := A_Gui ":" ctrl
			If ( cInfo[ctrlID].x = "" )
			{
				GuiControlGet, i, %A_Gui%:Pos, %ctrl%
				MMD := InStr(DimSize, "*") ? "MoveDraw" : "Move"
				fx := fy := fw := fh := 0
				For i, dim in (a := StrSplit(RegExReplace(DimSize, "i)[^xywh]")))
					If !RegExMatch(DimSize, "i)" dim "\s*\K[\d.-]+", f%dim%)
						f%dim% := 1
				cInfo[ctrlID] := { x:ix, fx:fx, y:iy, fy:fy, w:iw, fw:fw, h:ih, fh:fh, gw:A_GuiWidth, gh:A_GuiHeight, a:a , m:MMD}
			}
			Else If ( cInfo[ctrlID].a.1)
			{
				dgx := dgw := A_GuiWidth  - cInfo[ctrlID].gw  , dgy := dgh := A_GuiHeight - cInfo[ctrlID].gh
				For i, dim in cInfo[ctrlID]["a"]
					Options .= dim (dg%dim% * cInfo[ctrlID]["f" dim] + cInfo[ctrlID][dim]) A_Space
				GuiControl, % A_Gui ":" cInfo[ctrlID].m , % ctrl, % Options
			}
		}
	}
}
;Anchor(i, a := "", r := true) {
;    static c, cs := 12, cx := 255, cl := 0, g, gs := 8, gl := 0, gpi, gw, gh, z := 0, k := 0xffff, ptr
;    if z = 0
;        VarSetCapacity(g, gs * 99, 0), VarSetCapacity(c, cs * cx, 0), ptr := A_PtrSize ? "Ptr" : "UInt", z := true
;    if !WinExist("ahk_id" . i) {
;        GuiControlGet t, Hwnd, %i%
;        if ErrorLevel = 0
;            i := t
;        else ControlGet i, Hwnd,, %i%
;    }
;    VarSetCapacity(gi, 68, 0), DllCall("GetWindowInfo", "UInt", gp := DllCall("GetParent", "UInt", i), ptr, &gi)
;        , giw := NumGet(gi, 28, "Int") - NumGet(gi, 20, "Int"), gih := NumGet(gi, 32, "Int") - NumGet(gi, 24, "Int")
;    if (gp != gpi) {
;        gpi := gp
;        loop %gl%
;            if NumGet(g, cb := gs * (A_Index - 1), "UInt") == gp {
;                gw := NumGet(g, cb + 4, "Short"), gh := NumGet(g, cb + 6, "Short"), gf := 1
;                break
;            }
;        if !gf
;            NumPut(gp, g, gl, "UInt"), NumPut(gw := giw, g, gl + 4, "Short"), NumPut(gh := gih, g, gl + 6, "Short"), gl += gs
;    }
;    ControlGetPos dx, dy, dw, dh,, ahk_id %i%
;    loop %cl%
;        if NumGet(c, cb := cs * (A_Index - 1), "UInt") == i {
;            if (a = "") {
;                cf := 1
;                break
;            }
;            giw -= gw, gih -= gh, as := 1, dx := NumGet(c, cb + 4, "Short"), dy := NumGet(c, cb + 6, "Short")
;                , cw := dw, dw := NumGet(c, cb + 8, "Short"), ch := dh, dh := NumGet(c, cb + 10, "Short")
;            loop Parse, a, xywh
;                if A_Index > 1
;                    av := SubStr(a, as, 1), as += 1 + StrLen(A_LoopField)
;                        , d%av% += (InStr("yh", av) ? gih : giw) * (A_LoopField + 0 ? A_LoopField : 1)
;            DllCall("SetWindowPos", "UInt", i, "UInt", 0, "Int", dx, "Int", dy
;                , "Int", InStr(a, "w") ? dw : cw, "Int", InStr(a, "h") ? dh : ch, "Int", 4)
;            if r != 0
;                DllCall("RedrawWindow", "UInt", i, "UInt", 0, "UInt", 0, "UInt", 0x0101) ; RDW_UPDATENOW | RDW_INVALIDATE
;            return
;        }
;    if cf != 1
;        cb := cl, cl += cs
;    bx := NumGet(gi, 48, "UInt"), by := NumGet(gi, 16, "Int") - NumGet(gi, 8, "Int") - gih - NumGet(gi, 52, "UInt")
;    if cf = 1
;        dw -= giw - gw, dh -= gih - gh
;    NumPut(i, c, cb, "UInt"), NumPut(dx - bx, c, cb + 4, "Short"), NumPut(dy - by, c, cb + 6, "Short")
;        , NumPut(dw, c, cb + 8, "Short"), NumPut(dh, c, cb + 10, "Short")
;    return true
;}

SetBtnTxtColor(HWND, TxtColor) {
   Static HTML := {BLACK: "000000", GRAY: "808080", SILVER: "C0C0C0", WHITE: "FFFFFF", MAROON: "800000"
                , PURPLE: "800080", FUCHSIA: "FF00FF", RED: "FF0000", GREEN:  "008000", OLIVE:  "808000"
                , YELLOW: "FFFF00", LIME: "00FF00", NAVY: "000080", TEAL: "008080", AQUA: "00FFFF", BLUE: "0000FF", GOLD: "D4AF37", BRONZE: "8C7853"}
   Static BS_CHECKBOX := 0x2, BS_RADIOBUTTON := 0x4, BS_GROUPBOX := 0x7, BS_AUTORADIOBUTTON := 0x9
        , BS_LEFT := 0x100, BS_RIGHT := 0x200, BS_CENTER := 0x300, BS_TOP := 0x400, BS_BOTTOM := 0x800
        , BS_VCENTER := 0xC00, BS_BITMAP := 0x0080, SA_LEFT := 0x0, SA_CENTER := 0x1, SA_RIGHT := 0x2
        , WM_GETFONT := 0x31, BCM_SETIMAGELIST := 0x1602, IMAGE_BITMAP := 0x0, BITSPIXEL := 0xC
        , RCBUTTONS := BS_CHECKBOX | BS_RADIOBUTTON | BS_AUTORADIOBUTTON
        , BUTTON_IMAGELIST_ALIGN_LEFT := 0, BUTTON_IMAGELIST_ALIGN_RIGHT := 1, BUTTON_IMAGELIST_ALIGN_CENTER := 4
   ; -------------------------------------------------------------------------------------------------------------------
   ErrorLevel := ""
   GDIPDll := DllCall("Kernel32.dll\LoadLibrary", "Str", "Gdiplus.dll", "Ptr")
   VarSetCapacity(SI, 24, 0)
   Numput(1, SI)
   DllCall("Gdiplus.dll\GdiplusStartup", "PtrP", GDIPToken, "Ptr", &SI, "Ptr", 0)
   If (!GDIPToken) {
       ErrorLevel := "GDIPlus could not be started!`n`nSetBtnTxtColor won't work!"
       Return False
   }
   If !DllCall("User32.dll\IsWindow", "Ptr", HWND) {
      GoSub, CreateImageButton_GDIPShutdown
      ErrorLevel := "Invalid parameter HWND!"
      Return False
   }
   WinGetClass, BtnClass, ahk_id %HWND%
   ControlGet, BtnStyle, Style, , , ahk_id %HWND%
   If (BtnClass != "Button") || ((BtnStyle & 0xF ^ BS_GROUPBOX) = 0) || ((BtnStyle & RCBUTTONS) > 1) {
      GoSub, CreateImageButton_GDIPShutdown
      ErrorLevel := "You can use SetBtnTxtColor only for PushButtons!"
      Return False
   }
   PFONT := 0
   DC := DllCall("User32.dll\GetDC", "Ptr", HWND, "Ptr")
   BPP := DllCall("Gdi32.dll\GetDeviceCaps", "Ptr", DC, "Int", BITSPIXEL)
   HFONT := DllCall("User32.dll\SendMessage", "Ptr", HWND, "UInt", WM_GETFONT, "Ptr", 0, "Ptr", 0, "Ptr")
   DllCall("Gdi32.dll\SelectObject", "Ptr", DC, "Ptr", HFONT)
   DllCall("Gdiplus.dll\GdipCreateFontFromDC", "Ptr", DC, "PtrP", PFONT)
   DllCall("User32.dll\ReleaseDC", "Ptr", HWND, "Ptr", DC)
   If !(PFONT) {
      GoSub, CreateImageButton_GDIPShutdown
      ErrorLevel := "Couldn't get button's font!"
      Return False
   }
   VarSetCapacity(RECT, 16, 0)
   If !(DllCall("User32.dll\GetClientRect", "Ptr", HWND, "Ptr", &RECT)) {
      GoSub, CreateImageButton_GDIPShutdown
      ErrorLevel := "Couldn't get button's rectangle!"
      Return False
   }
   W := NumGet(RECT,  8, "Int"), H := NumGet(RECT, 12, "Int")
   BtnCaption := ""
   Len := DllCall("User32.dll\GetWindowTextLength", "Ptr", HWND) + 1
   If (Len > 1) {
      VarSetCapacity(BtnCaption, Len * (A_IsUnicode ? 2 : 1), 0)
      If !(DllCall("User32.dll\GetWindowText", "Ptr", HWND, "Str", BtnCaption, "Int", Len)) {
         GoSub, CreateImageButton_GDIPShutdown
         ErrorLevel := "Couldn't get button's caption!"
         Return False
      }
      VarSetCapacity(BtnCaption, -1)
   } Else {
      GoSub, CreateImageButton_GDIPShutdown
      ErrorLevel := "Couldn't get button's caption!"
      Return False
   }
   If HTML.HasKey(TxtColor)
      TxtColor := HTML[TxtColor]
   DllCall("Gdiplus.dll\GdipCreateBitmapFromScan0", "Int", W, "Int", H, "Int", 0
         , "UInt", 0x26200A, "Ptr", 0, "PtrP", PBITMAP)
   DllCall("Gdiplus.dll\GdipGetImageGraphicsContext", "Ptr", PBITMAP, "PtrP", PGRAPHICS)
   DllCall("Gdiplus.dll\GdipStringFormatGetGenericTypographic", "PtrP", PFORMAT)
   HALIGN := (BtnStyle & BS_CENTER) = BS_CENTER ? SA_CENTER : (BtnStyle & BS_CENTER) = BS_RIGHT ? SA_RIGHT
           : (BtnStyle & BS_CENTER) = BS_Left ? SA_LEFT : SA_CENTER
   DllCall("Gdiplus.dll\GdipSetStringFormatAlign", "Ptr", PFORMAT, "Int", HALIGN)
   VALIGN := (BtnStyle & BS_VCENTER) = BS_TOP ? 0 : (BtnStyle & BS_VCENTER) = BS_BOTTOM ? 2 : 1
   DllCall("Gdiplus.dll\GdipSetStringFormatLineAlign", "Ptr", PFORMAT, "Int", VALIGN)
   DllCall("Gdiplus.dll\GdipSetTextRenderingHint", "Ptr", PGRAPHICS, "Int", 3)
   NumPut(4, RECT, 0, "Float"), NumPut(2, RECT, 4, "Float")
   NumPut(W - 8, RECT, 8, "Float"), NumPut(H - 4, RECT, 12, "Float")
   DllCall("Gdiplus.dll\GdipCreateSolidFill", "UInt", "0xFF" . TxtColor, "PtrP", PBRUSH)
   DllCall("Gdiplus.dll\GdipDrawString", "Ptr", PGRAPHICS, "WStr", BtnCaption, "Int", -1, "Ptr", PFONT, "Ptr", &RECT
         , "Ptr", PFORMAT, "Ptr", PBRUSH)
   DllCall("Gdiplus.dll\GdipCreateHBITMAPFromBitmap", "Ptr", PBITMAP, "PtrP", HBITMAP, "UInt", 0X00FFFFFF)
   DllCall("Gdiplus.dll\GdipDisposeImage", "Ptr", PBITMAP)
   DllCall("Gdiplus.dll\GdipDeleteBrush", "Ptr", PBRUSH)
   DllCall("Gdiplus.dll\GdipDeleteStringFormat", "Ptr", PFORMAT)
   DllCall("Gdiplus.dll\GdipDeleteGraphics", "Ptr", PGRAPHICS)
   DllCall("Gdiplus.dll\GdipDeleteFont", "Ptr", PFONT)
   HIL := DllCall("Comctl32.dll\ImageList_Create", "UInt", W, "UInt", H, "UInt", BPP, "Int", 1, "Int", 0, "Ptr")
   DllCall("Comctl32.dll\ImageList_Add", "Ptr", HIL, "Ptr", HBITMAP, "Ptr", 0)
   VarSetCapacity(BIL, 20 + A_PtrSize, 0)
   NumPut(HIL, BIL, 0, "Ptr"), Numput(BUTTON_IMAGELIST_ALIGN_CENTER, BIL, A_PtrSize + 16, "UInt")
   GuiControl, , %HWND%
   SendMessage, BCM_SETIMAGELIST, 0, 0, , ahk_id %HWND%
   SendMessage, BCM_SETIMAGELIST, 0, &BIL, , ahk_id %HWND%
   GoSub, CreateImageButton_FreeBitmaps
   GoSub, CreateImageButton_GDIPShutdown
   Return True
   ; -------------------------------------------------------------------------------------------------------------------
   CreateImageButton_FreeBitmaps:
      DllCall("Gdi32.dll\DeleteObject", "Ptr", HBITMAP)
   Return    
   ; -------------------------------------------------------------------------------------------------------------------
   CreateImageButton_GDIPShutdown:
      DllCall("Gdiplus.dll\GdiplusShutdown", "Ptr", GDIPToken)
      DllCall("Kernel32.dll\FreeLibrary", "Ptr", GDIPDll)
   Return
}

LV_MoveRow(moveup = true) {
	; Original by diebagger (Guest) from:
	; http://de.autohotkey.com/forum/viewtopic.php?p=58526#58526
	; Slightly Modifyed by Obi-Wahn
	If moveup not in 1,0
		Return	; If direction not up or down (true or false)
	while x := LV_GetNext(x)	; Get selected lines
		i := A_Index, i%i% := x
	If (!i) || ((i1 < 2) && moveup) || ((i%i% = LV_GetCount()) && !moveup)
		Return	; Break Function if: nothing selected, (first selected < 2 AND moveup = true) [header bug]
				; OR (last selected = LV_GetCount() AND moveup = false) [delete bug]
	cc := LV_GetCount("Col"), fr := LV_GetNext(0, "Focused"), d := moveup ? -1 : 1
	; Count Columns, Query Line Number of next selected, set direction math.
	Loop, %i% {	; Loop selected lines
		r := moveup ? A_Index : i - A_Index + 1, ro := i%r%, rn := ro + d
		; Calculate row up or down, ro (current row), rn (target row)
		Loop, %cc% {	; Loop through header count
			LV_GetText(to, ro, A_Index), LV_GetText(tn, rn, A_Index)
			; Query Text from Current and Targetrow
			LV_Modify(rn, "Col" A_Index, to), LV_Modify(ro, "Col" A_Index, tn)
			; Modify Rows (switch text)
		}
		if ro = % LV_GetNext(ro-1, "Checked")
			ckn=Check
		else
			ckn=-Check
		if rn = % LV_GetNext(rn-1, "Checked")
			cko=Check
		else
			cko=-Check
		LV_Modify(ro, "-select -focus " cko), LV_Modify(rn, "select vis " ckn)
		If (ro = fr)
			LV_Modify(rn, "Focus")
	}
}

;=======================================================================================
;
; Function:			Eval
; Description:		Evaluate Expressions in Strings.
; Return value:		An array (object) with the result of each expression.
;
; Author:			Pulover [Rodolfo U. Batista]
; Credits:			ExprEval() by Uberi
;
;=======================================================================================
;
; Parameters:
;
;	$x:				The input string to be evaluated. You can enter multiple expressions
;						separated by commas (inside the string).
;	_CustomVars:	An optional Associative Array object containing variables names
;					  as keys and values to replace them.
;					For example, setting it to {A_Index: A_Index} inside a loop will replace
;						occurrences of A_Index with the correct value for the iteration.
;	_Init:			Used internally for the recursive calls. If TRUE it resets the static
;						object _Objects, which holds objects references to be restored.
;
;=======================================================================================
Eval($x, _CustomVars := "", _Init := true)
{
	Static _Objects
	_Elements := {}
	If (_Init)
		_Objects := {}
	
	; Strip off comments
	$x := RegExReplace($x, "U)/\*.*\*/"), $x := RegExReplace($x, "U)\s;.*(\v|$)")
	
	; Replace brackets, braces, parenthesis and literal strings
	
	While (RegExMatch($x, "sU)"".*""", _String))
		_Elements["&_String" A_Index "_&"] := _String
	,	$x := RegExReplace($x, "sU)"".*""", "&_String" A_Index "_&",, 1)
	While (RegExMatch($x, "\[([^\[\]]++|(?R))*\]", _Bracket))
		_Elements["&_Bracket" A_Index "_&"] := _Bracket
	,	$x := RegExReplace($x, "\[([^\[\]]++|(?R))*\]", "&_Bracket" A_Index "_&",, 1)
	While (RegExMatch($x, "\{[^\{\}]++\}", _Brace))
		_Elements["&_Brace" A_Index "_&"] := _Brace
	,	$x := RegExReplace($x, "\{[^\{\}]++\}", "&_Brace" A_Index "_&",, 1)
	While (RegExMatch($x, "\(([^()]++|(?R))*\)", _Parent))
		_Elements["&_Parent" A_Index "_&"] := _Parent
	,	$x := RegExReplace($x, "\(([^()]++|(?R))*\)", "&_Parent" A_Index "_&",, 1)
	
	; Split multiple expressions
	$z := StrSplit($x, ",", " `t")
	
	For $i, $v in $z
	{
		; Check for Ternary expression and evaluate
		If (RegExMatch($z[$i], "([^\?:=]+?)\?([^\?:]+?):(.*)", _Match))
		{
			Loop, 3
			{
				$o := A_Index, _Match%$o% := Trim(_Match%$o%)
			,	_Match%$o% := RestoreElements(_Match%$o%, _Elements)
			}
			EvalResult := Eval(_Match1, _CustomVars, false)
		,	$y := EvalResult[1]
			If ($y)
			{
				EvalResult := Eval(_Match2, _CustomVars, false)
			,	$y := StrJoin(EvalResult,, true, false)
			,	ObjName := RegExReplace(_Match2, "\W", "_")
				If (IsObject($y))
					_Objects[ObjName] := $y
				$z[$i] := StrReplace($z[$i], _Match, IsObject($y) ? """<~#" ObjName "#~>""" : $y)
			}
			Else
			{
				EvalResult := Eval(_Match3, _CustomVars, false)
			,	$y := StrJoin(EvalResult,, true, false)
			,	ObjName := RegExReplace(_Match3, "\W", "_")
				If (IsObject($y))
					_Objects[ObjName] := $y
				$z[$i] := StrReplace($z[$i], _Match, IsObject($y) ? """<~#" ObjName "#~>""" : $y)
			}
		}
		
		_Pos := 1
		; Check for Object calls
		While (RegExMatch($z[$i], "([\w%]+)(\.|&_Bracket|&_Parent\d+_&)[\w\.&%]+(.*)", _Match, _Pos))
		{
			AssignParse(_Match, VarName, Oper, VarValue)
			If (Oper != "")
			{
				VarValue := RestoreElements(VarValue, _Elements)
			,	EvalResult := Eval(VarValue, _CustomVars, false)
			,	VarValue := StrJoin(EvalResult)
				If (!IsObject(VarValue))
					VarValue := RegExReplace(VarValue, """{2,2}", """")
			}
			Else
				_Match := StrReplace(_Match, _Match3), VarName := _Match

			VarName := RestoreElements(VarName, _Elements)
			
			If _Match1 is Number
			{
				_Pos += StrLen(_Match1)
				continue
			}
			
			$y := ParseObjects(VarName, _CustomVars, Oper, VarValue)
		,	ObjName := RegExReplace(_Match, "\W", "_")
			
			If (IsObject($y))
				_Objects[ObjName] := $y
			Else If $y is not Number
			{
				$y := """" StrReplace($y, """", """""") """"
			,	HidString := "&_String" (ObjCount(_Elements) + 1) "_&"
			,	_Elements[HidString] := $y
			,	$y := HidString
			}
			$z[$i] := StrReplace($z[$i], _Match, IsObject($y) ? """<~#" ObjName "#~>""" : $y,, 1)
		}
		
		; Assign Arrays
		While (RegExMatch($z[$i], "&_Bracket\d+_&", $pd))
		{
			$z[$i] := StrReplace($z[$i], $pd, _Elements[$pd],, 1)
		,	RegExMatch($z[$i], "\[(.*)\]", _Match)
		,	_Match1 := RestoreElements(_Match1, _Elements)
		,	$y := Eval(_Match1, _CustomVars, false)
		,	ObjName := RegExReplace(_Match, "\W", "_")
		,	_Objects[ObjName] := $y
		,	$z[$i] := StrReplace($z[$i], _Match, """<~#" ObjName "#~>""")
		}
		
		; Assign Associative Arrays
		While (RegExMatch($z[$i], "&_Brace\d+_&", $pd))
		{
			$y := {}, o_Elements := {}
		,	$o := _Elements[$pd]
		,	$o := RestoreElements($o, _Elements)
		,	$o := SubStr($o, 2, -1)
			While (RegExMatch($o, "sU)"".*""", _String%A_Index%))
				o_Elements["&_String" A_Index "_&"] := _String%A_Index%
			,	$o := RegExReplace($o, "sU)"".*""", "&_String" A_Index "_&", "", 1)
			While (RegExMatch($o, "\[([^\[\]]++|(?R))*\]", _Bracket))
				o_Elements["&_Bracket" A_Index "_&"] := _Bracket
			,	$o := RegExReplace($o, "\[([^\[\]]++|(?R))*\]", "&_Bracket" A_Index "_&",, 1)
			While (RegExMatch($o, "\{[^\{\}]++\}", _Brace))
				o_Elements["&_Brace" A_Index "_&"] := _Brace
			,	$o := RegExReplace($o, "\{[^\{\}]++\}", "&_Brace" A_Index "_&",, 1)
			While (RegExMatch($o, "\(([^()]++|(?R))*\)", _Parent))
				o_Elements["&_Parent" A_Index "_&"] := _Parent
			,	$o := RegExReplace($o, "\(([^()]++|(?R))*\)", "&_Parent" A_Index "_&",, 1)
			Loop, Parse, $o, `,, %A_Space%%A_Tab%
			{
				$o := StrSplit(A_LoopField, ":", " `t")
			,	$o.1 := RestoreElements($o.1, o_Elements)
			,	$o.2 := RestoreElements($o.2, o_Elements)
			,	EvalResult := Eval($o.2, _CustomVars, false)
			,	$o.1 := Trim($o.1, """")
			,	$y[$o.1] := EvalResult[1]
			}
			ObjName := RegExReplace(_Match, "\W", "_")
		,	_Objects[ObjName] := $y
		,	$z[$i] := StrReplace($z[$i], $pd, """<~#" ObjName "#~>""")
		}
		
		; Restore and evaluate any remaining parenthesis
		While (RegExMatch($z[$i], "&_Parent\d+_&", $pd))
		{
			_oMatch := StrSplit(_Elements[$pd], ",", " `t()")
		,	_Match := RegExReplace(_Elements[$pd], "\((.*)\)", "$1")
		,	_Match := RestoreElements(_Match, _Elements)
		,	EvalResult := Eval(_Match, _CustomVars, false)
		,	RepString := "("
			For _i, _v in EvalResult
			{
				ObjName := RegExReplace($pd . _i, "\W", "_")
				If (IsObject(_v))
					_Objects[ObjName] := _v
				Else If _v is not Number
				{
					If (_oMatch[_i] != "")
					{
						_v := """" _v """"
					,	HidString := "&_String" (ObjCount(_Elements) + 1) "_&"
					,	_Elements[HidString] := _v
					,	_v := HidString
					}
				}
				RepString .= (IsObject(_v) ? """<~#" ObjName "#~>""" : _v) ", "
			}
			RepString := RTrim(RepString, ", ") ")"
		,	$z[$i] := StrReplace($z[$i], $pd, RepString,, 1)
		}
		
		; Check whether the whole string is an object
		$y := $z[$i]
		Try
		{
			If (_CustomVars.HasKey($y))
			{
				If (IsObject(_CustomVars[$y]))
				{
					ObjName := RegExReplace($y, "\W", "_")
				,	_Objects[ObjName] := _CustomVars[$y].Clone()
				,	$z[$i] := """<~#" ObjName "#~>"""
				}
			}
			Else If (IsObject(%$y%))
			{
				ObjName := RegExReplace($y, "\W", "_")
			,	_Objects[ObjName] := %$y%.Clone()
			,	$z[$i] := """<~#" ObjName "#~>"""
			}
		}
		
		; Check for Functions
		While (RegExMatch($z[$i], "s)([\w%]+)\((.*?)\)", _Match))
		{
			_Match1 := (RegExMatch(_Match1, "^%(\S+)%$", $pd)) ? %$pd1% : _Match1
		,	_Match2 := RestoreElements(_Match2, _Elements)
		,	_Params := Eval(_Match2, _CustomVars)
		,	$y := %_Match1%(_Params*)
		,	ObjName := RegExReplace(_Match, "\W", "_")
			If (IsObject($y))
				_Objects[ObjName] := $y
			Else If $y is not Number
			{
				$y := """" $y """"
			,	HidString := "&_String" (ObjCount(_Elements) + 1) "_&"
			,	_Elements[HidString] := $y
			,	$y := HidString
			}
			$z[$i] := StrReplace($z[$i], _Match, IsObject($y) ? """<~#" ObjName "#~>""" : $y,, 1)
		}
		
		; Dereference variables in percent signs
		While (RegExMatch($z[$i], "U)%(\S+)%", _Match))
			EvalResult := Eval(_Match1, _CustomVars, false)
		,	$z[$i] := StrReplace($z[$i], _Match, EvalResult[1])
		
		; ExprEval() cannot parse Unicode strings, so the "real" strings are "hidden" from ExprCompile() and restored later
		$z[$i] := RestoreElements($z[$i], _Elements)
	,	__Elements := {}
		While (RegExMatch($z[$i], "sU)""(.*)""", _String))
			__Elements["&_String" A_Index "_&"] := _String1
		,	$z[$i] := RegExReplace($z[$i], "sU)"".*""", "&_String" A_Index "_&",, 1)
		$z[$i] := RegExReplace($z[$i], "&_String\d+_&", """$0""")
		
		; Add concatenate operator after strings where necessary
		While (RegExMatch($z[$i], "(""&_String\d+_&""\s+)([^\d\.,\s:\?])"))
			$z[$i] := RegExReplace($z[$i], "(""&_String\d+_&""\s+)([^\d\.,\s:\?])", "$1. $2")
		
		; Evaluate parsed expression with ExprEval()
		ExprInit()
	,	CompiledExpression := ExprCompile($z[$i])
	,	$Result := ExprEval(CompiledExpression, _CustomVars, _Objects, __Elements)
	,	$Result := StrSplit($Result, Chr(1))
		
		; Restore object references
		For _i, _v in $Result
		{
			If (RegExMatch(_v, "^<~#(.*)#~>$", $pd))
				$Result[_i] := _Objects[$pd1]
		}
		
		$z[$i] := StrJoin($Result,, false, _Init)
	}
	
	; If returning to the original call, remove missing expressions from the array
	If (_Init)
	{
		$x := StrSplit($x, ",", " `t")
		For _i, _v in $x
		{
			If (_v = "")
				$z.Delete(_i)
		}
	}
	
	return $z
}

ParseObjects(v_String, _CustomVars := "", o_Oper := "", o_Value := "")
{
	Static _needle := "([\w%]+\.?|\(([^()]++|(?R))*\)\.?|\[([^\[\]]++|(?R))*\]\.?)"
	
	l_Matches := [], _Pos := 1
	While (_Pos := RegExMatch(v_String, _needle, l_Found, _Pos))
		l_Matches.Push(RegExMatch(RTrim(l_Found, "."), "^%(\S+)%$", $pd) ? %$pd1% : RTrim(l_Found, "."))
	,	_Pos += StrLen(l_Found)
	v_Obj := l_Matches[1]
	If (_CustomVars.HasKey(v_Obj))
		_ArrayObject := _CustomVars[v_Obj]
	Else
		Try _ArrayObject := %v_Obj%
	For $i, $v in l_Matches
	{
		If (RegExMatch($v, "^\((.*)\)$"))
			continue
		If (RegExMatch($v, "^\[(.*)\]$", l_Found))
			_Key := Eval(l_Found1, _CustomVars, false)
		Else
			_Key := [$v]
		$n := l_Matches[$i + 1]
		If (RegExMatch($n, "^\((.*)\)$", l_Found))
		{
			_Key := _Key[1]
		,	_Params := Eval(l_Found1, _CustomVars, false)
			
			Try
			{
				If ($i = 1)
					_ArrayObject := %_Key%(_Params*)
				Else
					_ArrayObject := _ArrayObject[_Key](_Params*)
			}
			Catch e
			{
				If (InStr(e.Message, "0x800A03EC"))
				{
					; Workaround for strange bug in some Excel methods
					For _i, _v in _Params
						_Params[_i] := " " _v
				
					If ($i = 1)
						_ArrayObject := %_Key%(_Params*)
					Else
						_ArrayObject := _ArrayObject[_Key](_Params*)
				}
				Else
					Throw e
			}
		}
		Else If (($i = l_Matches.Length()) && (o_Value != ""))
		{
			Try
			{
				If (o_Oper = ":=")
					_ArrayObject := _ArrayObject[_Key*] := o_Value ? o_Value : false
				Else If (o_Oper = "+=")
					_ArrayObject := _ArrayObject[_Key*] += o_Value ? o_Value : false
				Else If (o_Oper = "-=")
					_ArrayObject := _ArrayObject[_Key*] -= o_Value ? o_Value : false
				Else If (o_Oper = "*=")
					_ArrayObject := _ArrayObject[_Key*] *= o_Value ? o_Value : false
				Else If (o_Oper = "/=")
					_ArrayObject := _ArrayObject[_Key*] /= o_Value ? o_Value : false
				Else If (o_Oper = "//=")
					_ArrayObject := _ArrayObject[_Key*] //= o_Value ? o_Value : false
				Else If (o_Oper = ".=")
					_ArrayObject := _ArrayObject[_Key*] .= o_Value ? o_Value : false
				Else If (o_Oper = "|=")
					_ArrayObject := _ArrayObject[_Key*] |= o_Value ? o_Value : false
				Else If (o_Oper = "&=")
					_ArrayObject := _ArrayObject[_Key*] &= o_Value ? o_Value : false
				Else If (o_Oper = "^=")
					_ArrayObject := _ArrayObject[_Key*] ^= o_Value ? o_Value : false
				Else If (o_Oper = ">>=")
					_ArrayObject := _ArrayObject[_Key*] >>= o_Value ? o_Value : false
				Else If (o_Oper = "<<=")
					_ArrayObject := _ArrayObject[_Key*] <<= o_Value ? o_Value : false
			}
		}
		Else If ($i > 1)
			_ArrayObject := _ArrayObject[_Key*]
	}
	return _ArrayObject
}

RestoreElements(_String, _Elements)
{
	While (RegExMatch(_String, "&_\w+_&", $pd))
		_String := StrReplace(_String, $pd, _Elements[$pd])
	return _String
}

AssignParse(String, ByRef VarName, ByRef Oper, ByRef VarValue)
{
	RegExMatch(String, "(.*?)(:=|\+=|-=|\*=|/=|//=|\.=|\|=|&=|\^=|>>=|<<=)(?=([^""]*""[^""]*"")*[^""]*$)(.*)", Out)
,	VarName := Trim(Out1), Oper := Out2, VarValue := Trim(Out4)
}

StrJoin(InputArray, JChr := "", Quote := false, Init := true)
{
	For i, v in InputArray
	{
		If (IsObject(v))
			return v
		If v is not Number
		{
			If (!Init)
				v := RegExReplace(v, """{1,2}", """""")
			If (Quote)
				v := """" v """"
		}
		JoinedStr .= v . JChr
	}
	If (JChr != "")
		JoinedStr := SubStr(JoinedStr, 1, -(StrLen(JChr)))
	return JoinedStr
}

ObjCount(Obj)
{
	return NumGet(&Obj + 4 * A_PtrSize)
}

;##################################################
; Author: Uberi
; Modified by: Pulover
; http://autohotkey.com/board/topic/64167-expreval-evaluate-expressions/
;##################################################
ExprInit()
{
	global
	Exprot:="`n:= 0 R 2`n+= 0 R 2`n-= 0 R 2`n*= 0 R 2`n/= 0 R 2`n//= 0 R 2`n.= 0 R 2`n|= 0 R 2`n&= 0 R 2`n^= 0 R 2`n>>= 0 R 2`n<<= 0 R 2`n|| 3 L 2`n&& 4 L 2`n\! 5 R 1`n= 6 L 2`n== 6 L 2`n<> 6 L 2`n!= 6 L 2`n> 7 L 2`n< 7 L 2`n>= 7 L 2`n<= 7 L 2`n\. 8 L 2`n& 9 L 2`n^ 9 L 2`n| 9 L 2`n<< 10 L 2`n>> 10 L 2`n+ 11 L 2`n- 11 L 2`n* 12 L 2`n/ 12 L 2`n// 12 L 2`n\- 13 R 1`n! 13 R 1`n~ 13 R 1`n\& 13 R 1`n\* 13 R 1`n** 14 R 2`n\++ 15 R 1`n\-- 15 R 1`n++ 15 L 1`n-- 15 L 1`n. 16 L 2`n`% 17 R 1`n",Exprol:=SubStr(RegExReplace(Exprot,"iS) \d+ [LR] \d+\n","`n"),2,-1)
	Sort,Exprol,FExprols
}

ExprCompile(e)
{
	e:=Exprt(e)
	Loop,Parse,e,% Chr(1)
	{
		lf:=A_LoopField,tt:=SubStr(lf,1,1),to:=SubStr(lf,2)
		If tt=f
		Exprp1(s,lf)
		Else If lf=,
		{
			While,s<>""&&Exprp3(s)<>"("
			Exprp1(ou,Exprp2(s))
		}
		Else If tt=o
		{
			While,SubStr(so:=Exprp3(s),1,1)="o"
			{
				ta:=Expras(to),tp:=Exprpr(to),sop:=Exprpr(SubStr(so,2))
				If ((ta="L"&&tp>sop)||(ta="R"&&tp>=sop))
				Break
				Exprp1(ou,Exprp2(s))
			}
			Exprp1(s,lf)
		}
		Else If lf=(
		Exprp1(s,"(")
		Else If lf=)
		{
			While,Exprp3(s)<>"("
			{
				If s=
				Return
				Exprp1(ou,Exprp2(s))
			}
			Exprp2(s)
			If (SubStr(Exprp3(s),1,1)="f")
			Exprp1(ou,Exprp2(s))
		}
		Else Exprp1(ou,lf)
	}
	While,s<>""
	{
		t1:=Exprp2(s)
		If t1 In (,)
		Return
		Exprp1(ou,t1)
	}
	Return,ou
}

ExprEval(e,lp,eo,el)
{
	c1:=Chr(1)
	Loop,Parse,e,%c1%
	{
		lf:=A_LoopField,tt:=SubStr(lf,1,1),t:=SubStr(lf,2)
		While (RegExMatch(lf,"&_String\d+_&",rm))
		lf:=StrReplace(lf,rm,el[rm])
		If tt In l,v
		lf:=Exprp1(s,lf)
		Else{
			If tt=f
			t1:=InStr(t," "),a:=SubStr(t,1,t1-1),t:=SubStr(t,t1+1)
			Else a:=Exprac(t)
			Exprp1(s,Exprap(t,s,a,lp,eo))
		}
	}
	
	Loop,Parse,s,%c1%
	{
		lf:=A_LoopField
		If (SubStr(lf,1,1)="v")
		t1:=SubStr(lf,2),r.=(lp.HasKey(t1) ? lp[t1] : %t1%) . c1
		Else r.=SubStr(lf,2) . c1
	}
	Return,SubStr(r,1,-1)
}

Exprap(o,ByRef s,ac,lp,eo)
{
	local i,t1,a1,a2,a3,a4,a5,a6,a1v,a2v,a3v,a4v,a5v,a6v,a7v,a8v,a9v
	Loop,%ac%
	i:=ac-(A_Index-1),t1:=Exprp2(s),a%i%:=SubStr(t1,2),(SubStr(t1,1,1)="v")?(a%i%v:=1)
	Loop, 10
	{
		If (RegExMatch(a%A_Index%,"^<~#(.*)#~>$",rm))
		a%A_Index%:=eo[rm1],a%A_Index%v:=0
		Else If (lp.HasKey(a%A_Index%))
		a%A_Index%:=lp[a%A_Index%],a%A_Index%v:=0
	}
	If o=++
	Return,"l" . %a1%++
	If o=--
	Return,"l" . %a1%--
	If o=\++
	Return,"l" . ++%a1%
	If o=\--
	Return,"l" . --%a1%
	If o=`%
	Return,"v" . %a1%
	If o=!
	Return,"l" . !(a1v ? %a1%:a1)
	If o=\!
	Return,"l" . (a1v ? %a1%:a1)
	If o=~
	Return,"l" . ~(a1v ? %a1%:a1)
	If o=**
	Return,"l" . ((a1v ? %a1%:a1)**(a2v ? %a2%:a2))
	If o=*
	Return,"l" . ((a1v ? %a1%:a1)*(a2v ? %a2%:a2))
	If o=\*
	Return,"l" . *(a1v ? %a1%:a1)
	If o=/
	Return,"l" . ((a1v ? %a1%:a1)/(a2v ? %a2%:a2))
	If o=//
	Return,"l" . ((a1v ? %a1%:a1)//(a2v ? %a2%:a2))
	If o=+
	Return,"l" . ((a1v ? %a1%:a1)+(a2v ? %a2%:a2))
	If o=-
	Return,"l" . ((a1v ? %a1%:a1)-(a2v ? %a2%:a2))
	If o=\-
	Return,"l" . -(a1v ? %a1%:a1)
	If o=<<
	Return,"l" . ((a1v ? %a1%:a1)<<(a2v ? %a2%:a2))
	If o=>>
	Return,"l" . ((a1v ? %a1%:a1)>>(a2v ? %a2%:a2))
	If o=&
	Return,"l" . ((a1v ? %a1%:a1)&(a2v ? %a2%:a2))
	If o=\&
	Return,"l" . &(a1v ? %a1%:a1)
	If o=^
	Return,"l" . ((a1v ? %a1%:a1)^(a2v ? %a2%:a2))
	If o=|
	Return,"l" . ((a1v ? %a1%:a1)|(a2v ? %a2%:a2))
	If o=\.
	Return,"l" . ((a1v ? %a1%:a1) . (a2v ? %a2%:a2))
	If o=.
	Return,"v" . a1
	If o=<
	Return,"l" . ((a1v ? %a1%:a1)<(a2v ? %a2%:a2))
	If o=>
	Return,"l" . ((a1v ? %a1%:a1)>(a2v ? %a2%:a2))
	If o==
	Return,"l" . ((a1v ? %a1%:a1)=(a2v ? %a2%:a2))
	If o===
	Return,"l" . ((a1v ? %a1%:a1)==(a2v ? %a2%:a2))
	If o=<>
	Return,"l" . ((a1v ? %a1%:a1)<>(a2v ? %a2%:a2))
	If o=!=
	Return,"l" . ((a1v ? %a1%:a1)!=(a2v ? %a2%:a2))
	If o=>=
	Return,"l" . ((a1v ? %a1%:a1)>=(a2v ? %a2%:a2))
	If o=<=
	Return,"l" . ((a1v ? %a1%:a1)<=(a2v ? %a2%:a2))
	If o=&&
	Return,"l" . ((a1v ? %a1%:a1)&&(a2v ? %a2%:a2))
	If o=||
	Return,"l" . ((a1v ? %a1%:a1)||(a2v ? %a2%:a2))
	If o=:=
	{
		%a1%:=(a2v ? %a2%:a2)
		Return,"v" . a1
	}
	If o=+=
	{
		%a1%+=(a2v ? %a2%:a2)
		Return,"v" . a1
	}
	If o=-=
	{
		%a1%-=(a2v ? %a2%:a2)
		Return,"v" . a1
	}
	If o=*=
	{
		%a1%*=(a2v ? %a2%:a2)
		Return,"v" . a1
	}
	If o=/=
	{
		%a1%/=(a2v ? %a2%:a2)
		Return,"v" . a1
	}
	If o=//=
	{
		%a1%//=(a2v ? %a2%:a2)
		Return,"v" . a1
	}
	If o=.=
	{
		%a1%.=(a2v ? %a2%:a2)
		Return,"v" . a1
	}
	If o=|=
	{
		%a1%|=(a2v ? %a2%:a2)
		Return,"v" . a1
	}
	If o=&=
	{
		%a1%&=(a2v ? %a2%:a2)
		Return,"v" . a1
	}
	If o=^=
	{
		%a1%^=(a2v ? %a2%:a2)
		Return,"v" . a1
	}
	If o=>>=
	{
		%a1%>>=(a2v ? %a2%:a2)
		Return,"v" . a1
	}
	If o=<<=
	{
		%a1%<<=(a2v ? %a2%:a2)
		Return,"v" . a1
	}
	If ac=0
	Return,"l" . %o%()
	If ac=1
	Return,"l" . %o%(a1v ? %a1%:a1)
	If ac=2
	Return,"l" . %o%((a1v ? %a1%:a1),(a2v ? %a2%:a2))
	If ac=3
	Return,"l" . %o%((a1v ? %a1%:a1),(a2v ? %a2%:a2),(a3v ? %a3%:a3))
	If ac=4
	Return,"l" . %o%((a1v ? %a1%:a1),(a2v ? %a2%:a2),(a3v ? %a3%:a3),(a4v ? %a4%:a4))
	If ac=5
	Return,"l" . %o%((a1v ? %a1%:a1),(a2v ? %a2%:a2),(a3v ? %a3%:a3),(a4v ? %a4%:a4),(a5v ? %a5%:a5))
	If ac=6
	Return,"l" . %o%((a1v ? %a1%:a1),(a2v ? %a2%:a2),(a3v ? %a3%:a3),(a4v ? %a4%:a4),(a5v ? %a5%:a5),(a6v ? %a6%:a6))
	If ac=7
	Return,"l" . %o%((a1v ? %a1%:a1),(a2v ? %a2%:a2),(a3v ? %a3%:a3),(a4v ? %a4%:a4),(a5v ? %a5%:a5),(a6v ? %a6%:a6),(a7v ? %a7%:a7))
	If ac=8
	Return,"l" . %o%((a1v ? %a1%:a1),(a2v ? %a2%:a2),(a3v ? %a3%:a3),(a4v ? %a4%:a4),(a5v ? %a5%:a5),(a6v ? %a6%:a6),(a7v ? %a7%:a7),(a8v ? %a8%:a8))
	If ac=9
	Return,"l" . %o%((a1v ? %a1%:a1),(a2v ? %a2%:a2),(a3v ? %a3%:a3),(a4v ? %a4%:a4),(a5v ? %a5%:a5),(a6v ? %a6%:a6),(a7v ? %a7%:a7),(a8v ? %a8%:a8),(a9v ? %a9%:a9))
	If ac=10
	Return,"l" . %o%((a1v ? %a1%:a1),(a2v ? %a2%:a2),(a3v ? %a3%:a3),(a4v ? %a4%:a4),(a5v ? %a5%:a5),(a6v ? %a6%:a6),(a7v ? %a7%:a7),(a8v ? %a8%:a8),(a9v ? %a9%:a9),(a10v ? %a10%:a10))
}

Exprt(e)
{
	global Exprol
	c1:=Chr(1),f:=1,f1:=1
	While,(f:=RegExMatch(e,"S)""(?:[^""]|"""")*""",m,f))
	{
		t1:=SubStr(m,2,-1)
	,	t1:=StrReplace(t1,"""""","""")
	,	t1:=StrReplace(t1,"'","'27")
	,	t1:=StrReplace(t1,"````",c1)
	,	t1:=StrReplace(t1,"``n","`n")
	,	t1:=StrReplace(t1,"``r","`r")
	,	t1:=StrReplace(t1,"``b","`b")
	,	t1:=StrReplace(t1,"``t","`t")
	,	t1:=StrReplace(t1,"``v","`v")
	,	t1:=StrReplace(t1,"``a","`a")
	,	t1:=StrReplace(t1,"``f","`f")
	,	t1:=StrReplace(t1,c1,"``")
		SetFormat,IntegerFast,Hex
		While,RegExMatch(t1,"iS)[^\w']",c)
		t1:=StrReplace(t1,c,"'" . SubStr("0" . SubStr(Asc(c),3),-1))
		SetFormat,IntegerFast,D
		e1.=SubStr(e,f1,f-f1) . c1 . "l" . t1 . c1,f+=StrLen(m),f1:=f
	}
	e1.=SubStr(e,f1),e:=InStr(e1,"""")? "":e1,e1:="",e:=RegExReplace(e,"S)/\*.*?\*/|[ \t]`;.*?(?=\r|\n|$)")
,	e:=StrReplace(e,"`t"," ")
,	e:=RegExReplace(e,"S)([\w#@\$] +|\) *)(?=" . Chr(1) . "*[\w#@\$\(])","$1 . ")
,	e:=StrReplace(e," . ","\.")
,	e:=StrReplace(e," ")
,	f:=1,f1:=1
	While,(f:=RegExMatch(e,"iS)(^|[^\w#@\$\.'])(0x[0-9a-fA-F]+|\d+(?:\.\d+)?|\.\d+)(?=[^\d\.]|$)",m,f))
	{
		If ((m1="\") && (RegExMatch(m2,"\.\d+")))
		m1:="",m2:=SubStr(m2,2)
		m2+=0
		m2:=StrReplace(m2,".","'2E",,1)
		e1.=SubStr(e,f1,f-f1) . m1 . c1 . "n" . m2 . c1,f+=StrLen(m),f1:=f
	}
	e:=e1 . SubStr(e,f1),e1:="",e:=RegExReplace(e,"S)(^|\(|[^" . c1 . "-])-" . c1 . "n","$1" . c1 . "n'2D")
,	e:=StrReplace(e,c1 "n",c1 "l")
,	e:=RegExReplace(e,"\\\.(\d+)\.(\d+)",c1 . "l$1'2E$2" . c1)
,	e:=RegExReplace(RegExReplace(e,"S)(%[\w#@\$]{1,253})%","$1"),"S)(?:^|[^\w#@\$'" . c1 . "])\K[\w#@\$]{1,253}(?=[^\(\w#@\$]|$)",c1 . "v$0" . c1),f:=1,f1:=1
	While,(f:=RegExMatch(e,"S)(^|[^\w#@\$'])([\w#@\$]{1,253})(?=\()",m,f))
	{
		t1:=f+StrLen(m)
		If (SubStr(e,t1+1,1)=")")
		ac=0
		Else
		{
			If !Exprmlb(e,t1,fa)
			Return
			fa:=StrReplace(fa,"`,","`,",c)
			ac:=c+1
		}
		e1.=SubStr(e,f1,f-f1) . m1 . c1 . "f" . ac . "'20" . m2 . c1,f+=StrLen(m),f1:=f
	}
	e:=e1 . SubStr(e,f1),e1:=""
,	e:=StrReplace(e,"\." c1 "vNot" c1 "\.","!")
,	e:=StrReplace(e,"\." c1 "vAnd" c1 "\.","&&")
,	e:=StrReplace(e,"\." c1 "vOr" c1 "\.","||")
,	e:=StrReplace(e,c1 "vNot" c1 "\.","!")
,	e:=StrReplace(e,c1 "vAnd" c1 "\.","&&")
,	e:=StrReplace(e,c1 "vOr" c1 "\.","||")
,	e:=RegExReplace(e,"S)(^|[^" . c1 . "\)-])-" . c1 . "(?=[lvf])","$1\-" . c1)
,	e:=RegExReplace(e,"S)(^|[^" . c1 . "\)&])&" . c1 . "(?=[lvf])","$1\&" . c1)
,	e:=RegExReplace(e,"S)(^|[^" . c1 . "\)\*])\*" . c1 . "(?=[lvf])","$1\*" . c1)
,	e:=RegExReplace(e,"S)(^|[^" . c1 . "\)])(\+\+|--)" . c1 . "(?=[lvf])","$1\$2" . c1)
,	t1:=RegExReplace(Exprol,"S)[\\\.\*\?\+\[\{\|\(\)\^\$]","\$0")
,	t1:=StrReplace(t1,"`n","|")
,	e:=RegExReplace(e,"S)" . t1,c1 . "o$0" . c1)
,	e:=StrReplace(e,"`,",c1 "`," c1)
,	e:=StrReplace(e,"(",c1 "(" c1)
,	e:=StrReplace(e,")",c1 ")" c1)
,	e:=StrReplace(e,c1 . c1,c1)
	If RegExMatch(e,"S)" . c1 . "[^lvfo\(\),\n]")
	Return
	e:=SubStr(e,2,-1),f:=0
	While,(f:=InStr(e,"'",False,f + 1))
	{
		If ((t1:=SubStr(e,f+1,2))<>27)
		e:=StrReplace(e,"'" t1,Chr("0x" . t1))
	}
	e:=StrReplace(e,"'27","'")
	Return,e
}

Exprols(o1,o2)
{
	Return,StrLen(o2)-StrLen(o1)
}

Exprpr(o)
{
	global Exprot
	t:=InStr(Exprot,"`n" . o . " ")+StrLen(o)+2
	Return,SubStr(Exprot,t,InStr(Exprot," ",0,t)-t)
}

Expras(o)
{
	global Exprot
	Return,SubStr(Exprot,InStr(Exprot," ",0,InStr(Exprot,"`n" . o . " ")+StrLen(o)+2)+1,1)
}

Exprac(o)
{
	global Exprot
	Return,SubStr(Exprot,InStr(Exprot,"`n",0,InStr(Exprot,"`n" . o . " ")+1)-1,1)
}

Exprmlb(ByRef s,p,ByRef o="",b="(",e=")")
{
	t:=SubStr(s,p),bc:=0,VarSetCapacity(o,StrLen(t))
	If (SubStr(t,1,1)<>b)
	Return,0
	Loop,Parse,t
	{
		lf:=A_LoopField
		If lf=%b%
		bc++
		Else If lf=%e%
		{
			bc--
			If bc=0
			Return,p
		}
		Else If bc=1
		o.=lf
		p++
	}
	Return,0
}

Exprp1(ByRef dl,d)
{
	dl.=((dl="")? "":Chr(1)) . d
}

Exprp2(ByRef dl)
{
	t:=InStr(dl,Chr(1),0,0),t ?(t1:=SubStr(dl,t+1),dl:=SubStr(dl,1,t-1)):(t1:=dl,dl:="")
	Return,t1
}

Exprp3(ByRef dl)
{
	Return,SubStr(dl,InStr(dl,Chr(1),0,0)+1)
}

;;;;end of EVAL

VarWrite(Key := "", Value := "")		;_____________ VarWrite (Function) __________________
{
Static Var	;"Static" variables are always implicitly "local", but differ from "locals" variables because their values are remembered between calls.

	if Key =	;if "Key" is blank
	{
		if Value = GetVar
			return, Var ; return the content of var to the caller
		else
		{
			Var = %Value% ; set the new contents of var content, used for having a predefined varead generated database file
			return
		}
	}

Value := RegExReplace(Value, "#","##")	;replace any "#" to "##" (Ensures that no String\Character is enclosed by "##")
Value := RegExReplace(Value, "`r`n","#L#")	;replace any New Line "`r`n" to "#L#" (these replacements will be the only String\Character enclosed by "##") 

	If RegExMatch(Var, "m)^" Key "=""(.*)""" , Matched) 	;"m)" Search for a line \ "^" that starts by \ "Key" the string choosed by user \ followed by =" string \ (.*)"" match any string until last " character is found in that line
	{					;All the match wil be stored in "Matched" variable \ the match inside first "( )" will be stored in "Matched1" \ the match inside second "( )" will be stored in "Matched2", and so on ...
	if (Matched1 == Value)				;first " treats second " as literal character \ "= =" case sensitive (a is not A)
	return					;return if the value to be rewritten is the same as the "key" value (Faster this way)

	Value := RegExReplace(Value, "\$", "$$$$")	;replace any "$" to "$$" (necessary because "$" is a special character in RegExReplace 3rd parameter)
					;"\" treats "$" as literal character  -  "$$$$" the first "$" treats the second "$" as literal character, so, "$$$$" = "$$" literal string in RegExReplace 3rd parameter

	Var := RegExReplace(Var, "m)(^" Key "=).*", "$1""" Value """")	;[""], first " treats second " as literal character, so, """" means that there is a literal " character between two Special " characers 
	}						;"$1", in this case, it's a backreference to (^" Key "=) \ $2 would be  a backreference to the second ( ) \ $3 for the 3rd ( ) \ and so on ...
	else						;".*" match any string (the rest of the string left) of that line
	Var = %Var%`r`n%Key%="%Value%"			;"value", the value specified by user
}


VarRead(Key := "", Variable := "")	;_______________ VarRead (Function) by V for Vendetta________________
{
Static Var	;"Static" variables are always implicitly "local", but differ from "locals" variables because their values are remembered between calls.

	if Key =	;if "Key" is blank
	{
	Var = %Variable%
	return
	}

RegExMatch(Var, "m)^" Key "=""(.*)""" , Matched)
					;"m)" Search for a line \ "^" that starts by \ "Key" the string choosed by user \ followed by  =" string
					;(.*)"" match any string until last " character from that line is found
					;All the match wil be stored in "Matched" variable
					;the match inside first "( )" will be stored in "Matched1"
					;the match inside second "( )" will be stored in "Matched2", and so on ...
					;first " treats second " as literal character

Matched1 := RegExReplace(Matched1, "##(*SKIP)(*F)|#L#", "`r`n")	;replace any "#L#" to "`r`n" (any "##" will be skipped)
Matched1 := RegExReplace(Matched1, "##", "#")		;replace any "##" to "#" (necessary because "VarWrite( )" Function replaces any "#" to "##")

return, Matched1
}

WM_MOUSEMOVE(registercontrol:="",registermessage:="") ; by Alpha Bravo ; modified by aldrinjohnom
{
	static CurrControl, PrevControl, messageofcontrol ; , _TT  ; _TT is kept blank for use by the ToolTip command below.
	
	if ((registercontrol!=0) and (registercontrol!="")) or IsObject(registercontrol) ; if a control is being registered
	{
		if !IsObject(messageofcontrol) ; if multiple controls has the same message(is an array)
			messageofcontrol:=[] ; initialize that the messagecontrol is an array
		
		if IsObject(registercontrol)
		{
			for index,value in registercontrol
			{
				messageofcontrol[value]:=registermessage
			}
		}
		else messageofcontrol[registercontrol]:=registermessage ; saves the message of a control
		return
	}
    CurrControl := A_GuiControl
    If (CurrControl <> PrevControl and not InStr(CurrControl, " "))
    {
        ToolTip  ; Turn off any previous tooltip.
		;msgbox % messageofcontrol[%CurrControl%]
		;msgbox % messageofcontrol[CurrControl]
        SetTimer, DisplayToolTip, 1
        PrevControl := CurrControl
    }
    return

    DisplayToolTip:
    SetTimer, DisplayToolTip, Off
    ToolTip % messageofcontrol[CurrControl]  ; call the messageofcontrol array with element named %currcontrol%
    return

    RemoveToolTip:
    SetTimer, RemoveToolTip, Off
    ToolTip
    return
}

	;tested in Autohotkey 32 bit unicode

	;"ListView" control treats charcaters such as "space", "tab", "`r" (carriage return), "`n" (linefeed), "`r`n" (new lines) as invisible characters
	;The characters are there, but they are invisibles from "ListView" control
	;if saved to a ".txt" file for example, these characters can be seen\detected, such as "space", "tab", "`r`n" (new lines), etc, etc

	;"Separator" parameter from "ListViewSave( )" and "ListViewLoad( )" functions can be any character (Except "#" character)
	;"#" is used to Save and Load special characters ("S", "R" and "N") \ "#S#" = "Separator" character \ "#R#" = `r (carriage return) \ "#N#" = `n (linefeed)
	;"$", though no bugs was found while testing "$" as "Separator" character, "$" is not recommended to be used as such, because it is a special character in "RegExReplace" third parameter and  "ListViewLoad( )" function does not escape it with another "$" character!
ListViewSave(BeginningMessage:="",Separator := "	")	;_________________ ListView Save (Function) __________________
{
	;Default BeginningMessage is "Blank"! This argument will allow this function to "add" an extra message at the beginning of the text. DO NOT GO OVERBOARD SPECIFYING THIS FIELD EVERY CALL, calling this function with this field ONCE IS ALREADY ENOUGH because this function will remember it all the time
	; To Remove the Comment on Beginning Message, put variable A_Space
	
	;Default "Separator" is "Tab" Character \ "Separator" can be any character except "#" \ Avoid using "$" as "Separator" because it is a special character in "RegExReplace" third parameter!
	
	Static ExtraMessage	;"Static" variables are always implicitly "local", but differ from "locals" variables because their values are remembered between calls.
	if BeginningMessage=%A_Space%
	{
		ExtraMessage=
	}
	else if BeginningMessage<>
	{
		ExtraMessage:=BeginningMessage
	}
	TableText.=ExtraMessage ; If an ExtraMessage is present, the starting line of the database will have an extra message
	

TotalColumns := LV_GetCount("Column")	;"LV_GetCount("Column")" retrieves total columns in the listview control

	
	;;; I just added this for ajom purposes, if you want to reuse this func on your own script remove these lines
	adder:=1000/(LV_GetCount()+1) ;;; +1 adds the header on the counting
	progress=0
	gosub,showprogress
	;;;;;
	
	loop, % LV_GetCount( ) + 1	;"LV_GetCount( )" retrieves listview total rows \ "+1" plus the listview Columns "Header" row
	{
	RowNumber := a_index - 1

	if RowNumber > 0	;"0" is the Columns Header Row (not necessary to add "`r`n" before this row)
	TableText .= "`r`n"

		loop, %TotalColumns%
		{
		LV_GetText(TempText, RowNumber, a_index)		;"TempText", variable to store value from a given Cell
							;"RowNumber", "0" gets text from columns "Header" Row  
							;"a_index" is the column number

		TempText := RegExReplace(TempText, "#", "##")		;ensures that no character\string is enclosed by "##"
		TempText := RegExReplace(TempText, "\Q" Separator, "#S#")	;replace any "Separator" character with "#S#" string - "\Q" treats any RegEx Special characters at its right as literal characters (except "\E" special string)
		TempText := RegExReplace(TempText, "\r", "#R#")		;"\r" represents "carriage return" character (replace any "`r" with "#R#")
		TempText := RegExReplace(TempText, "\n", "#N#")		;"\n" represents "linefeed" character (replace any "`n" with "#N#")
	
		if a_index = 1
		TableText .= TempText
		else
		TableText .= Separator TempText
		}
		
	;;;; delete this also its for ajom purposes
	progress+=adder
	GuiControl,MainGUI:, MyProgress,%progress%
	;;;;;
	}

TableText .= "`r`nEnd >`r`r`r`r`r`r`r`r`r`r< End`r`n`r`n"		;"End >`r`r`r`r`r`r`r`r`r`r< End" indicates the "End" of ListView contents (Extra texts, like "Keys = Values" can be added below)
																;since any "`r" (carriage return) is saved as "#R#", it is not possible to find any "`r`r`r`r`r`r`r`r`r`r" string above this line

;;;; ajom purpose you can delete this also
gosub,hideprogress
;;;;

return, TableText
}


ListViewLoad(FileText:="",BeginningMessage:="", ColOptions := "AutoHdr", RowOptions := "", Separator := "	")	;__________________ ListView Load (Function) _____________________
{
	;Default BeginningMessage is "Blank"! This argument will allow this function to detect what the "ListViewSave" Extra Added. This value will replace any occurence on the "FileText" with a blank value later. DO NOT GO OVERBOARD SPECIFYING THIS FIELD EVERY CALL, calling this function with this field ONCE IS ALREADY ENOUGH because this function will remember it all the time
	;Default "Separator" is "Tab" Character \ "Separator" can be any character except "#" \ Avoid using "$" as "Separator" because it is a special character in "RegExReplace" third parameter!
	;Default "ColOptions" is "50", which is the columns width \ Others options such as sort type can be specified, for example: "50 Integer" or "Auto Integer" or "100 Text Logical", etc, etc ... I Changed it to AutoHdr because I added custom function to it
	;Default "RowOptions" is "Blank"! Row options such as "Check", "Select" or "Check Select", etc, etc can be specified! (Probably not necessary, but added this parameter anyway)
	;The function returns all the text below "End >`r`r`r`r`r`r`r`r`r`r< End" line! If the returned text contains "Key = Values" contents, "VarRead( )" function can be used to read the Keys values!
	
	Static ExtraMessage	;"Static" variables are always implicitly "local", but differ from "locals" variables because their values are remembered between calls.
	if BeginningMessage=%A_Space%
	{
		ExtraMessage=
	}
	else if BeginningMessage<>
	{
		ExtraMessage:=BeginningMessage
	}
	if FileText=
	{
		return
	}

LV_ClearAll("")	;delete all rows and columns

	if ExtraMessage<> ; if begginingmessage has a value/set by the user
	{
		FileText := StrReplace(FileText,ExtraMessage,"") ; change all begginingmessage into a blank value so that it will not interefere with further operation
	}
		LV_Delete()
	Loop, Parse, FileText, `n, `r	;"`n" is the Delimiter \ any "`r" will be excluded from the beginning and end of each substring (remove any extra "`r" character added while saving)
	{
		if (A_LoopField == "End >`r`r`r`r`r`r`r`r`r`r< End")	;"= =" is case-sensitive \ since any "`r" (carriage return) is saved as "#R#", if "`r`r`r`r`r`r`r`r`r`r" string is found indicates the end of lisview contents
		{
			RegExMatch(FileText, "s)End >`r`r`r`r`r`r`r`r`r`r< End(.*)", ExtraText)		;"s)" allows "." to match "`r`n" newlines too \ "ExtraText" contains all the match found \ "ExtraText1" contains the match from the first "( )" \ "ExtraText2" contains the match from the second "( )" \ and so on ...
			if ColOptions=AutoHdr
			{
				Loop %NextCol%
				{
					LV_ModifyCol(A_Index,"AutoHdr")
					
				}
			}
			return, ExtraText1	;The function returns all the text below the first "End >`r`r`r`r`r`r`r`r`r`r< End" line\string found 
		}
		
		RowNumber := a_index - 1
		TextArray:=[] ; declare TextArray as an array
		loop,parse,% Trim(A_LoopField,Separator),%Separator%
		{	;"s)" option allows "." to match "`r`n" newlines too \ "?", prevents skipping all the string at once between the first "#" and last "#" character! 
			;TempText := RegExReplace(A_LoopField, "s)#S#|#.*?#(*SKIP)(*F)", Separator)		;skip any "# 0 or more characters #", but, any "#S#" shall be replaced with "Separator" character
			;TempText := RegExReplace(TempText, "s)#R#|#.*?#(*SKIP)(*F)", "`r")		;skip any "# 0 or more characters #", but, any "#R#" shall be replaced with "carriage return" character (`r)
			;TempText := RegExReplace(TempText, "s)#N#|#.*?#(*SKIP)(*F)", "`n")		;skip any "# 0 or more characters #", but, any "#N#" shall be replaced with "linefeed" character (`n)
			;TempText := RegExReplace(TempText, "##", "#")							;remove any extra "#" character added while saving
			if RowNumber = 0
			{
				NextCol++ ; counts how many rows there is on the final listview contents
				LV_InsertCol(NextCol, ColOptions, A_LoopField)	;"NextCol" the new column is added to the end of the list (to the right of the last column)
				;LV_InsertCol(NextCol, ColOptions, TempText)	;"NextCol" the new column is added to the end of the list (to the right of the last column)
			}													;"TempText" is the column Title \ "ColOptions" specify columns options such as "width", "sort type", etc, etc, ...
			else
			{
				TextArray.Push(A_LoopField) ; save the content to the array
				;LV_Modify( RowNumber, "Col" a_index " " RowOptions, TempText)	;Fill ListView Control Cells \ "TempText" is the Cell Value
																				;"RowOptions", specify row options such as "Select", "Check" or "Select Check", etc, etc (propably not necessary, but added it anyway)
			}
		}
		if RowNumber != 0
			LV_Add(,TextArray*) ; add a row with a field of elements inside an array "TextArray" as variadic
	}
}

DirExist(DirName)
{
    loop Files, % DirName, D
        return A_LoopFileAttrib
}

/*
    Displays a standard dialog that allows the user to save a file.
    Parámetros:
    Parameters:
        Owner / Title:
            The identifier of the window that owns this dialog. This value can be zero.
            An Array with the identifier of the owner window and the title. If the title is an empty string, it is set to the default.
        FileName:
            The path to the file or directory selected by default. If you specify a directory, it must end with a backslash.
        Filter:
            Specify a file filter. You must specify an object, each key represents the description and the value the file types.
            To specify the filter selected by default, add the "`n" character to the value.
		FileTypeIndex:
			Specify the Chosen Row at Filter Dropdownlist. Defaults to first row
			Take note that the filter dropdownlist will first sort the lists in alphanumerical order before the dropdownlist will choose the row...
        CustomPlaces:
            Specify an Array with the custom directories that will be displayed in the left pane. Missing directories will be omitted.
            To specify the location in the list, specify an Array with the directory and its location (0 = Lower, 1 = Upper).
        Options:
            Determina el comportamiento del diálogo. Este parámetro debe ser uno o más de los siguientes valores.
                0x00000002  (FOS_OVERWRITEPROMPT) = When saving a file, prompt before overwriting an existing file of the same name.
                0x00000004  (FOS_STRICTFILETYPES) = Only allow the user to choose a file that has one of the file name extensions specified through Filter.
                0x00040000 (FOS_HIDEPINNEDPLACES) = Hide items shown by default in the view's navigation pane.
                0x10000000  (FOS_FORCESHOWHIDDEN) = Include hidden and system items.
                0x02000000  (FOS_DONTADDTORECENT) = Do not add the item being opened or saved to the recent documents list (SHAddToRecentDocs).
            You can check all available values at https://msdn.microsoft.com/en-us/library/windows/desktop/dn457282(v=vs.85).aspx.
    Return:
        Returns 0 if the user canceled the dialog, otherwise returns the path of the selected file.
*/
SaveFile(Owner, FileName := "", Filter := "", FileTypeIndex := 1, CustomPlaces := "", Options := 0x6)
{
    ; IFileSaveDialog interface
    ; https://msdn.microsoft.com/en-us/library/windows/desktop/bb775688(v=vs.85).aspx
    local IFileSaveDialog := ComObjCreate("{C0B4E2F3-BA21-4773-8DBA-335EC946EB8B}", "{84BCCD23-5FDE-4CDB-AEA4-AF64B83D78AB}")
        ,           Title := IsObject(Owner) ? Owner[2] . "" : ""
        ,           Flags := Options     ; FILEOPENDIALOGOPTIONS enumeration (https://msdn.microsoft.com/en-us/library/windows/desktop/dn457282(v=vs.85).aspx)
        ,      IShellItem := PIDL := 0   ; PIDL recibe la dirección de memoria a la estructura ITEMIDLIST que debe ser liberada con la función CoTaskMemFree
        ,             Obj := {}, foo := bar := ""
        ,       Directory := FileName
    Owner := IsObject(Owner) ? Owner[1] : (WinExist("ahk_id" . Owner) ? Owner : 0)
    Filter := IsObject(Filter) ? Filter : {"All files": "*.*"}


    if ( FileName != "" )
    {
        if ( InStr(FileName, "\") )
        {
            if !( FileName ~= "\\$" )    ; si «FileName» termina con "\" se trata de una carpeta
            {
                local File := ""
                SplitPath FileName, File, Directory
                ; IFileDialog::SetFileName
                ; https://msdn.microsoft.com/en-us/library/windows/desktop/bb775974(v=vs.85).aspx
                DllCall(NumGet(NumGet(IFileSaveDialog+0)+15*A_PtrSize), "UPtr", IFileSaveDialog, "UPtr", &File)
            }
            
            while ( InStr(Directory,"\") && !DirExist(Directory) )                   ; si el directorio no existe buscamos directorios superiores
                Directory := SubStr(Directory, 1, InStr(Directory, "\",, -1) - 1)    ; recupera el directorio superior
            if ( DirExist(Directory) )
            {
                DllCall("Shell32.dll\SHParseDisplayName", "UPtr", &Directory, "Ptr", 0, "UPtrP", PIDL, "UInt", 0, "UInt", 0)
                DllCall("Shell32.dll\SHCreateShellItem", "Ptr", 0, "Ptr", 0, "UPtr", PIDL, "UPtrP", IShellItem)
                ObjRawSet(Obj, IShellItem, PIDL)
                ; IFileDialog::SetFolder method
                ; https://msdn.microsoft.com/en-us/library/windows/desktop/bb761828(v=vs.85).aspx
                DllCall(NumGet(NumGet(IFileSaveDialog+0)+12*A_PtrSize), "Ptr", IFileSaveDialog, "UPtr", IShellItem)
            }
        }
        else    ; si «FileName» es únicamente el nombre de un archivo
            DllCall(NumGet(NumGet(IFileSaveDialog+0)+15*A_PtrSize), "UPtr", IFileSaveDialog, "UPtr", &FileName)
    }


    ; COMDLG_FILTERSPEC structure
    ; https://msdn.microsoft.com/en-us/library/windows/desktop/bb773221(v=vs.85).aspx
    local Description := "", FileTypes := "" ; , FileTypeIndex := 1
    ObjSetCapacity(Obj, "COMDLG_FILTERSPEC", 2*Filter.Count() * A_PtrSize)
    for Description, FileTypes in Filter
    {
        FileTypeIndex := InStr(FileTypes,"`n") ? A_Index : FileTypeIndex
        ObjRawSet(Obj, "#" . A_Index, Trim(Description)), ObjRawSet(Obj, "@" . A_Index, Trim(StrReplace(FileTypes,"`n")))
        NumPut(ObjGetAddress(Obj,"#" . A_Index), ObjGetAddress(Obj,"COMDLG_FILTERSPEC") + A_PtrSize * 2*(A_Index-1))        ; COMDLG_FILTERSPEC.pszName
        NumPut(ObjGetAddress(Obj,"@" . A_Index), ObjGetAddress(Obj,"COMDLG_FILTERSPEC") + A_PtrSize * (2*(A_Index-1)+1))    ; COMDLG_FILTERSPEC.pszSpec
    }

    ; IFileDialog::SetFileTypes method
    ; https://msdn.microsoft.com/en-us/library/windows/desktop/bb775980(v=vs.85).aspx
    DllCall(NumGet(NumGet(IFileSaveDialog+0)+4*A_PtrSize), "UPtr", IFileSaveDialog, "UInt", Filter.Count(), "UPtr", ObjGetAddress(Obj,"COMDLG_FILTERSPEC"))

    ; IFileDialog::SetFileTypeIndex method
    ; https://msdn.microsoft.com/en-us/library/windows/desktop/bb775978(v=vs.85).aspx
    DllCall(NumGet(NumGet(IFileSaveDialog+0)+5*A_PtrSize), "UPtr", IFileSaveDialog, "UInt", FileTypeIndex)


    if ( IsObject(CustomPlaces := IsObject(CustomPlaces) || CustomPlaces == "" ? CustomPlaces : [CustomPlaces]) )
    {
        local Directory := ""
        for foo, Directory in CustomPlaces    ; foo = index
        {
            foo := IsObject(Directory) ? Directory[2] : 0    ; FDAP enumeration (https://msdn.microsoft.com/en-us/library/windows/desktop/bb762502(v=vs.85).aspx)
            if ( DirExist(Directory := IsObject(Directory) ? Directory[1] : Directory) )
            {
                DllCall("Shell32.dll\SHParseDisplayName", "UPtr", &Directory, "Ptr", 0, "UPtrP", PIDL, "UInt", 0, "UInt", 0)
                DllCall("Shell32.dll\SHCreateShellItem", "Ptr", 0, "Ptr", 0, "UPtr", PIDL, "UPtrP", IShellItem)
                ObjRawSet(Obj, IShellItem, PIDL)
                ; IFileDialog::AddPlace method
                ; https://msdn.microsoft.com/en-us/library/windows/desktop/bb775946(v=vs.85).aspx
                DllCall(NumGet(NumGet(IFileSaveDialog+0)+21*A_PtrSize), "UPtr", IFileSaveDialog, "UPtr", IShellItem, "UInt", foo)
            }
        }
    }


    ; IFileDialog::SetTitle method
    ; https://msdn.microsoft.com/en-us/library/windows/desktop/bb761834(v=vs.85).aspx
    DllCall(NumGet(NumGet(IFileSaveDialog+0)+17*A_PtrSize), "UPtr", IFileSaveDialog, "UPtr", Title == "" ? 0 : &Title)

    ; IFileDialog::SetOptions method
    ; https://msdn.microsoft.com/en-us/library/windows/desktop/bb761832(v=vs.85).aspx
    DllCall(NumGet(NumGet(IFileSaveDialog+0)+9*A_PtrSize), "UPtr", IFileSaveDialog, "UInt", Flags)


    ; IModalWindow::Show method
    ; https://msdn.microsoft.com/en-us/library/windows/desktop/bb761688(v=vs.85).aspx
    local Result := FALSE
    if ( !DllCall(NumGet(NumGet(IFileSaveDialog+0)+3*A_PtrSize), "UPtr", IFileSaveDialog, "Ptr", Owner, "UInt") )
    {
        ; IFileDialog::GetFileTypeIndex method
        ; https://msdn.microsoft.com/es-es/bb775958
        DllCall(NumGet(NumGet(IFileSaveDialog+0)+6*A_PtrSize), "UPtr", IFileSaveDialog, "UIntP", FileTypeIndex)

        ; IFileDialog::GetResult method
        ; https://msdn.microsoft.com/en-us/library/windows/desktop/bb775964(v=vs.85).aspx
        if ( !DllCall(NumGet(NumGet(IFileSaveDialog+0)+20*A_PtrSize), "UPtr", IFileSaveDialog, "UPtrP", IShellItem) )
        {
            VarSetCapacity(Result, 32767 * 2, 0)
            DllCall("Shell32.dll\SHGetIDListFromObject", "UPtr", IShellItem, "UPtrP", PIDL)
            DllCall("Shell32.dll\SHGetPathFromIDListEx", "UPtr", PIDL, "Str", Result, "UInt", 32767, "UInt", 0)
            ObjRawSet(Obj, IShellItem, PIDL)
        }
    }


    for foo, bar in Obj      ; foo = IShellItem interface (ptr)  |  bar = PIDL structure (ptr)
        if foo is integer    ; IShellItem?
            ObjRelease(foo), DllCall("Ole32.dll\CoTaskMemFree", "UPtr", bar)
    ObjRelease(IFileSaveDialog)

    return Result ? {File: Result, FileTypeIndex: FileTypeIndex} : FALSE
} ; https://github.com/flipeador/AutoHotkey/blob/master/Lib/dlg/SaveFile.ahk

; ----------------------------------------------------------------------------------------------------------------------
; Advanced Library for ListViews
; by Dadepp
; Version 1.1 (minor bugfixes)
; Version 1.1b (minor bugfixes, Unicode and 64bit compatible, requires AHK 1.1+) by toralf and just me
; http://www.autohotkey.com/forum/viewtopic.php?t=43242
; http://www.autohotkey.com/board/topic/39778-lva-color-individual-cells-of-a-listview-and-more/
; ----------------------------------------------------------------------------------------------------------------------
;
; Warning:    This uses the OnNotify Message handler. If you already have an
;             OnNotify handler please merge these two lines into your script:
;
;  If LVA_HwndInfo(NumGet(lParam + 0),2)
;    return LVA_OnNotifyProg(wParam, lParam, msg, hwnd)
;
;             If this is not done, the coloring can not take place!
;             If there is NO OnNotify handler in the script, please set one by using:
;
;  OnMessage("0x4E", "LVA_OnNotify")
;
; ----------------------------------------------------------------------------------------------------------------------
; Notes:
;             A Color Reference inside these functions are the same as with AHK itself:
;             Either the name of one of the 16 Standart Colors
;             (http://www.autohotkey.com/docs/commands/Progress.htm#colors)
;             or an RGB color reference such as 0x0000FF (the 0x is optional).
;             So if a color reference is to be used these are all equal:
;             red = rEd = Red = 0xFF0000 = 0xfF0000 = FF0000 = ff0000 = fF0000
;
;             All row and column numbers are 1-Based indexes !!
; ----------------------------------------------------------------------------------------------------------------------
;
; List of functions the User may call:
;
; ----------------------------------------------------------------------------------------------------------------------
;
; LVA_OnNotify(wParam, lParam, msg, hwnd)
;
; The OnNotify handler that can be used, if no OnNotify handler is already in place
; Please dont use otherwise! Only for use with "OnMessage("0x4E", "LVA_OnNotify")"
;
; ----------------------------------------------------------------------------------------------------------------------
;
; LVA_ListViewAdd(LVvar, Options="")
;
; Makes it possible to color Cells/Rows/Columns/etc... inside the ListView.
; If this is NOT used, every other functions wont work!
; Params:
; LVvar       The associated control Variable (the name of the variable,
;             NOT the handle to the control!). Must be inside Quotationmarks ""
;
; Options     A Space delimited list of one or more of the following:
;             "AR"/"+AR"  Sets the Alternating Row Coloring to active
;             "-AR"       Removes the Alternating Row Coloring
;             "RB"        Followed by a Color Reference to set the Background Color
;                         for the alternating rows!
;             "RF"        Same as "RB" except that it controls the Text Color
;             "AC"/"+AC"  Sets the Alternating Column Coloring to active
;             "-AC"       Removes the Alternating Column Coloring
;             "CB"        Followed by a Color Reference to set the Background Color
;                         for the alternating Columns!
;             "CF"        Same as "CB" except that it controls the Text Color
;             The standard values are:
;             "-AR RB0xEFEFEF RF0x000000 -AC CB0xEFEFEF CF0x000000"
;
;
; ----------------------------------------------------------------------------------------------------------------------
;
; LVA_ListViewModify(LVvar, Options)
;
; A way to modify the Options set with LVA_ListViewAdd().
; Params:
; LVvar       The name of the associated control's variable.
;
; Options     The same as in LVA_ListViewAdd()
;
; ----------------------------------------------------------------------------------------------------------------------
;
; LVA_Refresh(LVvar)
;
; A helper function to force a ListView to ReDraw itself
; (Works only with ListViews Specified with LVA_ListViewAdd() !)
;
; ----------------------------------------------------------------------------------------------------------------------
;
; LVA_SetProgressBar(LVvar, Row, Col, cInfo="")
;
; Allows the use of a ProgressBar inside a specific Cell.
; Call without the cInfo param to remove a ProgressBar from the ListView
; Params:
; LVvar       The name of the associated control's variable.
;
; Row         The number of the row to be used
;
; Col         The number of the column to be used
;
; cInfo       A Space delimited list of one or more of the following:
;             "R"       Followed by a number sets the range of the ProgressBar
;             "B"       Followed by a Color Reference to set the Background Color
;             "S"       Followed by a Color Reference to set the Starting Color
;             "E"       Followed by a Color Reference to set the Ending Color
;                       (if not used the Ending Color will be the same as the
;                       Starting Color)
;             "Smooth"  Use this Option to create a different acting ProgressBar
;             The standard values are: "R100 B0xFFFFFF S0x000080"
;
; ----------------------------------------------------------------------------------------------------------------------
;
; LVA_Progress(Name, Row, Col, pProgress)
;
; If a ProgressBar has been set with LVA_SetProgressBar() then this sets the
; current value of this specific ProgressBar. (This repaints the ProgressBar,
; and ONLY the ProgressBar!)
; Params:
; LVvar       The name of the associated control's variable.
;
; Row         The number of the row to be used
;
; Col         The number of the column to be used
;
; cProgress   The new value. If it exceeds the Range set for this ProgressBar,
;             the maximum allowed Range is used instead!
;
; ----------------------------------------------------------------------------------------------------------------------
;
; LVA_SetCell(Name, Row, Col, cBGCol="", cFGCol="")
;
; Sets the Color to a specific Cell. To remove a Color, use the function
; without the "cBGCol" and "cFGCol" params! If one param is empty then
; the other one will be automaticly filled with the standard values for this
; specific ListView (these infos will be determined internally!)
; Params:
; LVvar       The name of the associated control's variable.
;
; Row         The number of the row to be used
;
; Col         The number of the column to be used
;
; cBGCol      The Color Reference for the Cells BackGround
;
; cFGCol      The Color Reference for the Cells Text
;
; Note:       Setting Row or Col to 0 will affect the whole Row/Column.
;             The order of priority for the cells color goes:
;             if specific the use this
;             else if column has color
;             else if row has color
;             else if is an alternating column and bool is set
;             else if is an alternating row and bool is set
;             else standard colors
;
; ----------------------------------------------------------------------------------------------------------------------
; LVA_EraseAllCells(Name)
;
; Resets ALL Color/ProgressBar Informations, for the complete ListView
; (Use with caution!)
;
; LVvar       The name of the associated control's variable.
;
; ----------------------------------------------------------------------------------------------------------------------
;
; The Following Functions CAN BE USED even on ListViews not specified with
; LVA_ListViewAdd()
;
; ----------------------------------------------------------------------------------------------------------------------
; LVA_GetCellNum(Switch=0, LVvar="")
;
; A function to retrieve Cell-Information (Row/Column) from the cell under
; the Mouse Pointer!
; Params:
;
; Switch      If set to 0 and LVvar set to the ListView in question, it
;             retrieves the informations and stores the internally!
;             Afterwards the LVvar param is no longer needed, and these
;             infos can be requested with the following:
;             (Note: These values will still hold the values from when it was
;             used with Switch set to 0 even if the MousePosition changed!)
;             1  or "Row"     Returns the row-number
;             2  or "Col"     Returns the Column-number
;             -1 or "Row-1"   Returns the row-number (0-Based Index)
;             -2 or "Row-2"   Returns the Column-number (0-Based Index)
;             "Rows"          Returns the total number of Rows
;             "Cols"          Returns the total number of Columns
;
;             The following values for Switch are special, since with them
;             the Cell-Information wont be evaluated (and changed !!).
;             But the LVvar param is needed again !!
;             "GetRows"       Returns the total number of Rows
;             "GetCols"       Returns the total number of Columns
;
; LVvar       The name of the associated control's variable.
;             Can also be a Handle !!
;
; ----------------------------------------------------------------------------------------------------------------------
;
; LVA_SetSubItemImage(LVvar, Row, Col, iNum)
;
; A helper function to set an Image to any Cell. An ImageList MUST be
; associated with that ListView, and the ListView MUST have "+LV0x2" set inside
; its Style Options.
; (Note: Using a number < 1 for Row is the Same as using 1.
;        Using 1 for Col , is the same as using: LV_Modify(Row, "Icon" . iNum) !)
; Params:
; LVvar       The name of the associated control's variable.
;
; Row         The number of the row to be used
;
; Col         The number of the column to be used
;
; iNum        The number of the ImageList-Icon to be used
;
; ======================================================================================================================
; Public functions, for use look at the docu above!
; ======================================================================================================================
LVA_OnNotify(wParam, lParam, msg, hwnd) {
  Critical, 500
  If LVA_HwndInfo(NumGet(lParam + 0, "Ptr"), 2)
    Return LVA_OnNotifyProg(wParam, lParam, msg, hwnd)
}
; ----------------------------------------------------------------------------------------------------------------------
LVA_ListViewAdd(LVvar, Options:= "") {
  tmp := LVA_HwndInfo(LVvar, 1)
  tmp2 :=LVA_HwndInfo(0, -2, tmp)
  LVA_Info("SetARowBool", LVvar,0,0,false)
  LVA_Info("SetARowColB", LVvar,0,0,"0xEFEFEF")
  LVA_Info("SetARowColF", LVvar,0,0,"0x000000")
  LVA_Info("SetAColBool", LVvar,0,0,false)
  LVA_Info("SetAColColB", LVvar,0,0,"0xEFEFEF")
  LVA_Info("SetAColColF", LVvar,0,0,"0x000000")
  SendMessage, 4096,0,0,, ahk_id %tmp2%
  LVA_Info("SetStdColorBG", LVvar,0,0,ErrorLevel)
  SendMessage, 4131,0,0,, ahk_id %tmp2%
  LVA_Info("SetStdColorFG", LVvar,0,0,ErrorLevel)
  LVA_ListViewModify(LVvar, Options)
  LVA_Refresh(LVvar)
}
; ----------------------------------------------------------------------------------------------------------------------
LVA_ListViewModify(LVvar, Options)
{
  Loop, Parse, Options, %A_Space%
  {
    If (A_LoopField = "+AR")||(A_LoopField = "AR")
      LVA_Info("SetARowBool", LVvar,0,0,true)
    If (A_LoopField = "-AR")
      LVA_Info("SetARowBool", LVvar,0,0,false)
    If (A_LoopField = "+AC")||(A_LoopField = "AC")
      LVA_Info("SetAColBool", LVvar,0,0,true)
    If (A_LoopField = "-AC")
      LVA_Info("SetAColBool", LVvar,0,0,false)
    cmd := SubStr(A_LoopField,1,2)
    If (cmd = "RB")
      LVA_Info("SetARowColB", LVvar,0,0, LVA_VerifyColor(SubStr(A_LoopField, 3)))
    If (cmd = "RF")
      LVA_Info("SetARowColF", LVvar,0,0, LVA_VerifyColor(SubStr(A_LoopField, 3)))
    If (cmd = "CB")
      LVA_Info("SetAColColB", LVvar,0,0, LVA_VerifyColor(SubStr(A_LoopField, 3)))
    If (cmd = "CF")
      LVA_Info("SetAColColF", LVvar,0,0, LVA_VerifyColor(SubStr(A_LoopField, 3)))
  }
}
; ----------------------------------------------------------------------------------------------------------------------
LVA_Refresh(LVvar)
{
  tmp := LVA_HwndInfo(LVvar,0,2)
  WinSet, Redraw,, ahk_id %tmp%
}
; ----------------------------------------------------------------------------------------------------------------------
LVA_SetProgressBar(LVvar, Row, Col, cInfo := "")
{
  If (cInfo = "")
  {
    LVA_Info("SetPB", LVvar, Row, Col, false)
    lva_Refresh(LVvar)
    Return
  }
  LVA_Info("SetPB", LVvar, Row, Col, true)
  LVA_Info("SetProgress", LVvar, Row, Col, 0)
  LVA_Info("SetPBR", LVvar, Row, Col, 100)
  LVA_Info("SetPCB", LVvar, Row, Col, "0x00FFFFFF")
  LVA_Info("SetPCS", LVvar, Row, Col, "0x000080")
  Loop, Parse, cInfo, %A_Space%
  {
    cmd := SubStr(A_LoopField,1,1)
    If (A_LoopField = "Smooth")
      LVA_Info("SetPB", LVvar, Row, Col, 2)
    Else If (cmd = "R")
      LVA_Info("SetPBR", LVvar, Row, Col, SubStr(A_LoopField, 2))
    Else If (cmd = "B")
      LVA_Info("SetPCB", LVvar, Row, Col, LVA_VerifyColor(SubStr(A_LoopField, 2),1))
    Else If (cmd = "S")
      LVA_Info("SetPCS", LVvar, Row, Col, LVA_VerifyColor(SubStr(A_LoopField, 2), 2))
    Else If (cmd = "E")
      LVA_Info("SetPCE", LVvar, Row, Col, LVA_VerifyColor(SubStr(A_LoopField, 2), 2))
  }
  If (LVA_Info("GetPCE", LVvar, Row, Col) = "")
    LVA_Info("SetPCE", LVvar, Row, Col, LVA_Info("GetPCS", LVvar, Row, Col))
}
; ----------------------------------------------------------------------------------------------------------------------
LVA_Progress(Name, Row, Col, pProgress)
{
  LVA_Info("SetProgress", LVA_HwndInfo(Name), Row, Col, pProgress)
  LVA_DrawProgress(Row, Col, LVA_HwndInfo(Name,0,2))
}
; ----------------------------------------------------------------------------------------------------------------------
LVA_SetCell(Name, Row, Col, cBGCol := "", cFGCol := "")
{
  If ((cBGCol = "")&&(cFGCol = ""))
  {
    LVA_Info("SetCol", Name, Row, Col, false)
    Return
  }
  If (cBGCol <> "")
    LVA_Info("SetCellColorBG", Name, Row, Col, LVA_VerifyColor(cBGCol))
  If (cFGCol <> "")
    LVA_Info("SetCellColorFG", Name, Row, Col, LVA_VerifyColor(cFGCol))
  If (cFont <> "")
    LVA_Info("SetCellFont", Name, Row, Col, cFont)
  LVA_Info("SetCol", Name, Row, Col, true)
}
; ----------------------------------------------------------------------------------------------------------------------
LVA_EraseAllCells(Name)
{
  LVA_Info(0, Name)
}
; ----------------------------------------------------------------------------------------------------------------------
LVA_GetCellNum(Switch=0, LVvar := "")
{
  Static LastResR, LastResC, LastColCount, LastRowCount, LastLVvar
  If ((Switch = 1)||(Switch = "Row"))
    Return LastResR
  Else If ((Switch = 2)||(Switch = "Col"))
    Return LastResC
  Else If ((Switch = -1)||(Switch = "Row-1"))
    Return LastResR-1
  Else If ((Switch = -2)||(Switch = "Col-1"))
    Return LastResC-1
  Else If (Switch = "Rows")
    Return LastRowCount
  Else If (Switch = "Cols")
    Return LastColCount
  If (LVvar = "")
    LVvar := LastLVvar
  Else
    LastLVvar := LVvar
  If LVvar is not Integer
    GuiControlGet, hLV, Hwnd, %LVvar%
  Else
    hLV := LVvar
  SendMessage, 4100,0,0,, ahk_id %hLV%
  RowCount := ErrorLevel
  If (Switch = "GetRows")
    Return RowCount
  SendMessage, 4127,0,0,, ahk_id %hLV%
  hHeader := ErrorLevel
  SendMessage, 4608,0,0,, ahk_id %hHeader%
  ColCount := ErrorLevel
  If (Switch = "GetCols")
    Return ColCount
  LastRowCount := RowCount
  LastColCount := ColCount
  VarSetCapacity(spt, 8, 0)
  VarSetCapacity(pt, 8, 0)
  DllCall("GetCursorPos", "Ptr", &spt)
  NumPut(NumGet(spt, 0, "Int"), pt, 0, "Int")
  NumPut(NumGet(spt, 4, "Int"), pt, 4, "Int")
  DllCall("ScreenToClient", "Ptr", hLV, "Ptr", &pt)
  VarSetCapacity(LVHitTest, 24, 0)
  NumPut(NumGet(pt, 0, "Int"), LVHitTest, 0)
  NumPut(NumGet(pt, 4, "Int"), LVHitTest, 4)
  SendMessage, 4153, 0, &LVHitTest,, ahk_id %hLV%
  LastResR := NumGet(LVHitTest, 12, "Int")+1
  If (LastResR > RowCount)
    LastResR := 0
  LastResC := NumGet(LVHitTest, 16, "Int")+1
  If ((LastResC > ColCount)||(LastResR = 0))
    LastResC := 0
  Return
}
; ----------------------------------------------------------------------------------------------------------------------
LVA_SetSubItemImage(LVvar, Row, Col, iNum)
{ ; modified by toralf
  Static LVM_SETITEM := A_IsUnicode ? 0x104C : 0x1006 ; LVM_SETITEMW : LVM_SETITEMA
  Static LVITEMSize := 48 + (A_PtrSize * 3)
  Static OffImage := 20 + (A_PtrSize * 2)
  GuiControlGet, hLV, Hwnd, %LVvar%
  VarSetCapacity(LVItem, LVITEMSize, 0)
  Row := (Row < 1) ? 1 : Row
  Col := (Col < 1) ? 1 : Col
  NumPut(2, LVItem, 0, "UInt")
  NumPut(Row-1, LVItem, 4, "Int")
  NumPut(Col-1, LVItem, 8, "Int")
  NumPut(iNum-1, LVItem, OffImage, "Int")
  SendMessage, % LVM_SETITEM, 0, &LVItem,, ahk_id %hLV%
}
; ======================================================================================================================
; Private Functions! Please use only If u know what your doing
; ======================================================================================================================
LVA_VerifyColor(cColor, Switch := 0)
{
  If cColor is not Integer
  {
    If (cColor = "Black")
      cColor := (Switch = 1) ? "FFFFFF" : "010101"
    Else If (cColor = "White")
      cColor := (Switch = 1) ? "010101" : "FFFFFF"
    Else If (cColor = "Silver")
      cColor := "C0C0C0"
    Else If (cColor = "Gray")
      cColor := "808080"
    Else If (cColor = "Maroon")
      cColor := "800000"
    Else If (cColor = "Red")
      cColor := "FF0000"
    Else If (cColor = "Purple")
      cColor := "800080"
    Else If (cColor = "Fuchsia")
      cColor := "FF00FF"
    Else If (cColor = "Green")
      cColor := "008000"
    Else If (cColor = "Lime")
      cColor := "00FF00"
    Else If (cColor = "Olive")
      cColor := "808000"
    Else If (cColor = "Yellow")
      cColor := "FFFF00"
    Else If (cColor = "Navy")
      cColor := "000080"
    Else If (cColor = "Blue")
      cColor := "0000FF"
    Else If (cColor = "Teal")
      cColor := "008080"
    Else If (cColor = "Aqua")
      cColor := "00FFFF"
  }
  If (SubStr(cColor,1,2) = "0x")
    cColor := SubStr(cColor, 3)
  If ((Switch = 1)&&(SubStr(cColor,1,2) = "00"))
    cColor := SubStr(cColor, 3)
  If (StrLen(cColor) <> 6)
    Return "0xFFFFFF"
  If (Switch = 1)
    Return "0x00" . SubStr(cColor,5,2) . SubStr(cColor,3,2) . SubStr(cColor,1,2)
  If (Switch = 0)
    Return "0x" . SubStr(cColor,5,2) . SubStr(cColor,3,2) . SubStr(cColor,1,2)
  Else
    Return "0x" . cColor
}
; ----------------------------------------------------------------------------------------------------------------------
LVA_DrawProgressGetStatus(Switch, Row := 0, Col := 0, Name := "")
{
  Static BGCol, SColR, SColG, SColB, EColR, EColG, EColB, pProgressMax, pProgress, pProgressType
  If !Switch
  {
    BGCol := LVA_Info("GetPCB", Name, Row, Col)
    SCol := LVA_Info("GetPCS", Name, Row, Col)
    ECol := LVA_Info("GetPCE", Name, Row, Col)
    pProgressMax := LVA_Info("GetPBR", Name, Row, Col)
    pProgress := LVA_Info("GetProgress", Name, Row, Col)
    SColR := "0x" . SubStr(SCol, 3, 2) . "00"
    SColG := "0x" . SubStr(SCol, 5, 2) . "00"
    SColB := "0x" . SubStr(SCol, 7, 2) . "00"
    EColR := "0x" . SubStr(ECol, 3, 2) . "00"
    EColG := "0x" . SubStr(ECol, 5, 2) . "00"
    EColB := "0x" . SubStr(ECol, 7, 2) . "00"
    pProgressType := LVA_Info("GetPB", Name, Row, Col)
  }
  If (Switch = 1)
    Return BGCol
  Else If (Switch = 2)
    Return SColR
  Else If (Switch = 3)
    Return SColG
  Else If (Switch = 4)
    Return SColB
  Else If (Switch = 5)
    Return EColR
  Else If (Switch = 6)
    Return EColG
  Else If (Switch = 7)
    Return EColB
  Else If (Switch = 8)
  {
    max := col-row
    If (pProgress > pProgressMax)
      Return max
    res := Ceil((max / 100) * (Round(pProgress / (pProgressMax / 100))))
    If res > max
      Return max
    Else
      Return res
  }
  Else If (Switch = 9)
    Return pProgressType
}
; ----------------------------------------------------------------------------------------------------------------------
LVA_GetStatusColor(Switch, Row := 0, Col := 0, LVvar := 0)
{
  Static cFGCol, cBGCol
  If (Switch = -1)
  {
    Return cFGCol
  }
  Else If (Switch = -2)
  {
    Return cBGCol
  }
  Else If (switch = 0)
  {
    If LVA_Info("GetCol", LVvar, 0, Col)
    {
      cBGCol := LVA_Info("GetCellColorBG", LVvar, 0, Col)
      If !cBGCol
        cBGCol := LVA_Info("GetStdColorBG", LVvar)
      cFGCol := LVA_Info("GetCellColorFG", LVvar, 0, Col)
      If !cFGCol
        cFGCol := LVA_Info("GetStdColorFG", LVvar)
    }
    Else If LVA_Info("GetCol", LVvar, Row)
    {
      cBGCol := LVA_Info("GetCellColorBG", LVvar, Row)
      If !cBGCol
        cBGCol := LVA_Info("GetStdColorBG", LVvar)
      cFGCol := LVA_Info("GetCellColorFG", LVvar, Row)
      If !cFGCol
        cFGCol := LVA_Info("GetStdColorFG", LVvar)
    }
    Else If (LVA_Info("GetAColBool", LVvar))&&(mod(Col, 2) = 0)
    {
      cBGCol := LVA_Info("GetAColColB", LVvar)
      cFGCol := LVA_Info("GetAColColF", LVvar)
    }
    Else If (LVA_Info("GetARowBool", LVvar))&&(mod(Row, 2) = 0)
    {
      cBGCol := LVA_Info("GetARowColB", LVvar)
      cFGCol := LVA_Info("GetARowColF", LVvar)
    }
    Else
    {
      cBGCol := LVA_Info("GetStdColorBG", LVvar)
      cFGCol := LVA_Info("GetStdColorFG", LVvar)
    }
  }
  Else If (switch = 1)
  {
    cBGCol := LVA_Info("GetCellColorBG", LVvar, Row, Col)
    If !cBGCol
      If (LVA_Info("GetAColBool", LVvar))&&(mod(Col, 2) = 0)
        cBGCol := LVA_Info("GetAColColB", LVvar)
      Else If (LVA_Info("GetARowBool", LVvar))&&(mod(Row, 2) = 0)
        cBGCol := LVA_Info("GetARowColB", LVvar)
      Else
        cBGCol := LVA_Info("GetStdColorBG", LVvar)
    cFGCol := LVA_Info("GetCellColorFG", LVvar, Row, Col)
    If !cFGCol
      If (LVA_Info("GetAColBool", LVvar))&&(mod(Col, 2) = 0)
        cFGCol := LVA_Info("GetAColColF", LVvar)
      Else If (LVA_Info("GetARowBool", LVvar))&&(mod(Row, 2) = 0)
        cFGCol := LVA_Info("GetARowColF", LVvar)
      Else
        cFGCol := LVA_Info("GetStdColorFG", LVvar)
  }
}
; ----------------------------------------------------------------------------------------------------------------------
LVA_HwndInfo(hwnd, switch := 0, data := 1)
{
  Static
  Local tmp, found
  If ((switch = 0)||(switch = 2))
  {
    If hwnd is Integer
      hwnd := hwnd+0

    found := false
    Loop, %LVCount%
    {
      tmp := A_Index
      Loop, 3
      {
        If (LVA_hWndInfo_%tmp%_%A_Index% = hwnd)
        {
          found := true
          break
        }
      }
      If found
        break
    }
    If !found
      Return ""
    Else
    {
      If (switch = 0)
        Return LVA_hWndInfo_%tmp%_%data%
      Else If (switch = 2)
        Return true
    }
  }
  Else If (switch = -1)
    Return LVA_hWndInfo_%data%_1
  Else If (switch = -2)
    Return LVA_hWndInfo_%data%_2
  Else If (switch = -3)
    Return LVA_hWndInfo_%data%_3
  Else If (switch = 1)
  {
    If !LVCount
      LVCount := 1
    Else
      LVCount++
    LVA_hWndInfo_%LVCount%_1 := hwnd
    GuiControlGet, tmp, Hwnd, %hwnd%
    LVA_hWndInfo_%LVCount%_2 := tmp+0
    SendMessage, 4127,0,0,, ahk_id %tmp%
    LVA_hWndInfo_%LVCount%_3 := ErrorLevel+0
    Return LVCount
  }
}
; ----------------------------------------------------------------------------------------------------------------------
LVA_OnNotifyProg(wParam, lParam, msg, hwnd)
{
  Critical, 500
  hHandle := NumGet(lParam + 0, "Ptr")
  NotifyMsg := NumGet(lParam + 0, A_PtrSize * 2, "Int")
  If ((NotifyMsg == -307)||(NotifyMsg == -327))
    LVA_Refresh(hHandle)
  Else If (NotifyMsg == -12)
  {
    Row := NumGet(lParam + 16, A_PtrSize * 5, "UPtr") +1
    Col := NumGet(lParam + 24, A_PtrSize * 8, "Int") +1
    st := NumGet(lParam + 0, A_PtrSize * 3, "UInt")
    If st = 1
      Return, 0x20
    Else If (st == 0x10001)
      Return, 0x20
    Else If (st == 0x30001)
    {
      LVvar := LVA_HwndInfo(hHandle)
      CellType := LVA_Info("GetCellType", LVvar, Row, Col)
      If (CellType = 0)
      {
        LVA_GetStatusColor(0, Row, Col, LVvar)
        NumPut(LVA_GetStatusColor(-1), lParam + 16, A_PtrSize * 8, "UInt")
        NumPut(LVA_GetStatusColor(-2), lParam + 20, A_PtrSize * 8, "UInt")
      }
      Else If (CellType = 1)
      {
        LVA_GetStatusColor(1, Row, Col, LVvar)
        NumPut(LVA_GetStatusColor(-1), lParam + 16, A_PtrSize * 8, "UInt")
        NumPut(LVA_GetStatusColor(-2), lParam + 20, A_PtrSize * 8, "UInt")
      }
      Else If (CellType = 2)
      {
        LVA_DrawProgress(Row, Col, hHandle)
        Return 0x4
      }
      Else If (CellType = 3)
      {
;        lva_DrawMultiImage(Row, Col, hHandle)
        Return 0x4
      }
    }
  }
}
; ----------------------------------------------------------------------------------------------------------------------
LVA_DrawProgress(Row, Col, hHandle)
{
  If !LVA_Info("GetPB", LVA_HwndInfo(hHandle,0,1), Row, Col)
    Return
  VarSetCapacity(pRect, 16, 0)
  NumPut(0, pRect, 0, "UInt")
  NumPut(Col-1, pRect, 4, "UInt")
  SendMessage, 4152, Row-1, &pRect,, ahk_id %hHandle%
  pLeft := NumGet(pRect, 0, "UInt") > 0x7FFFFFFF ? -(~NumGet(pRect, 0, "UInt")) - 1 : NumGet(pRect, 0, "UInt")
  pTop := NumGet(pRect, 4, "UInt") > 0x7FFFFFFF ? -(~NumGet(pRect, 4, "UInt")) - 1 : NumGet(pRect, 4, "UInt")
  pRight := NumGet(pRect, 8, "UInt") > 0x7FFFFFFF ? -(~NumGet(pRect, 8, "UInt")) - 1 : NumGet(pRect, 8, "UInt")
  pBottom := NumGet(pRect, 12, "UInt") > 0x7FFFFFFF ? -(~NumGet(pRect, 12, "UInt")) - 1 : NumGet(pRect, 12, "UInt")
  If ((pRight < 0)||(pBottom < 0))
    Return
  VarSetCapacity(pRect2, 16, 0)
  SendMessage, 4135,0,0,, ahk_id %hHandle%
  SendMessage, 4152, ErrorLevel, &pRect2,, ahk_id %hHandle%
  If (pTop < NumGet(pRect2, 4, "UInt"))
    Return
  LVA_DrawProgressGetStatus(0, Row, Col, LVA_HwndInfo(hHandle))
  hDC := DllCall("GetDC", "Ptr", hHandle, "UPtr")
  If (pLeft < 0)
    pWidth := NumGet(pRect, 8, "UInt") + -pLeft-3
  Else
    pWidth := NumGet(pRect, 8, "UInt") - NumGet(pRect, 0, "UInt")-3
  pHeight := NumGet(pRect, 12, "UInt") - NumGet(pRect, 4, "UInt")-3
  mDC := DllCall("CreateCompatibleDC", "Ptr", hDC, "UPtr")
  mBitmap := DllCall("CreateCompatibleBitmap", "Ptr", hDC, "Int", pWidth, "Int", pHeight, "UPtr")
  DllCall("SelectObject", "Ptr", mDC, "Ptr", mBitmap)
  VarSetCapacity(pVertex, 32, 0)
  NumPut(1, pVertex, 0, "Int")
  NumPut(1, pVertex, 4, "Int")
  NumPut(LVA_DrawProgressGetStatus(2), pVertex, 8, "Ushort")
  NumPut(LVA_DrawProgressGetStatus(3), pVertex, 10, "Ushort")
  NumPut(LVA_DrawProgressGetStatus(4), pVertex, 12, "Ushort")
  NumPut(0x0000, pVertex, 14, "Ushort")
  ProgLen := LVA_DrawProgressGetStatus(8, 1, pWidth-1)
  If (LVA_DrawProgressGetStatus(9) = 1)
    NumPut(1+ProgLen, pVertex, 16, "Int")
  Else
    NumPut(pWidth-1, pVertex, 16, "Int")
  NumPut(pHeight-1, pVertex, 20, "Int")
  NumPut(LVA_DrawProgressGetStatus(5), pVertex, 24, "Ushort")
  NumPut(LVA_DrawProgressGetStatus(6), pVertex, 26, "Ushort")
  NumPut(LVA_DrawProgressGetStatus(7), pVertex, 28, "Ushort")
  NumPut(0x0000, pVertex, 30, "Ushort")
  VarSetCapacity(gRect, 8, 0)
  NumPut(0, gRect, 0, "UInt")
  NumPut(1, gRect, 4, "UInt")
  DllCall("msimg32\GradientFill", "Ptr", mDC, "Ptr", &pVertex, "Int", 2, "Ptr", &gRect, "Int", 1, "UInt", 0x0)
  NumPut(ProgLen+1, pRect2, 0, "UInt")
  NumPut(1, pRect2, 4, "UInt")
  NumPut(pWidth-1, pRect2, 8, "UInt")
  NumPut(pHeight-1, pRect2, 12, "UInt")
  hBrush := DllCall("Gdi32\CreateSolidBrush", "UInt", LVA_DrawProgressGetStatus(1), "UPtr")
  DllCall("FillRect", "Ptr", mDC, "Ptr", &pRect2, "Ptr", hBrush)
  DllCall("Gdi32\DeleteObject", "Ptr", hBrush)
  If (pLeft < 0)
    DllCall("Gdi32\BitBlt", "Ptr",  hDC
                          , "UInt", NumGet(pRect, 0, "UInt")-pLeft-1
                          , "UInt", NumGet(pRect, 4, "UInt")+1
                          , "UInt", NumGet(pRect, 8, "UInt")
                          , "UInt", NumGet(pRect, 12, "UInt")-1
                          , "Ptr",  mDC
                          , "UInt", -pLeft-3
                          , "UInt", 0
                          , "UInt", 0xCC0020)
  Else
    DllCall("Gdi32\BitBlt", "Ptr",  hDC
                          , "UInt", NumGet(pRect, 0, "UInt")+2
                          , "UInt", NumGet(pRect, 4, "UInt")+1
                          , "UInt", NumGet(pRect, 8, "UInt")
                          , "UInt", NumGet(pRect, 12, "UInt")-1
                          , "Ptr",  mDC
                          , "UInt", 0
                          , "UInt", 0
                          , "UInt", 0xCC0020)
  DllCall("DeleteDC", "Ptr", mDC)
  DllCall("ReleaseDC", "Ptr", hHandle, "Ptr", hDC)
}
; ----------------------------------------------------------------------------------------------------------------------
LVA_Info(Switch, Name, Row := 0, Col := 0, Data := 0)
{
  Static
  If (Switch = 0)
  {
    Loop, % LVA_GetCellNum("GetRows", Name)
    {
      lRow := A_Index
      If LVA_InfoArray_%Name%_%lRow%_0_HasCellColor
        LVA_InfoArray_%Name%_%lRow%_0_HasCellColor := ""
      Loop, % LVA_GetCellNum("GetCols", Name)
      {
        If LVA_InfoArray_%Name%_%lRow%_%A_Index%_HasProgressBar
          LVA_InfoArray_%Name%_%lRow%_%A_Index%_HasProgressBar := ""
        If LVA_InfoArray_%Name%_%lRow%_%A_Index%_HasMultiImage
          LVA_InfoArray_%Name%_%lRow%_%A_Index%_HasMultiImage := ""
        If LVA_InfoArray_%Name%_%lRow%_%A_Index%_HasCellColor
          LVA_InfoArray_%Name%_%lRow%_%A_Index%_HasCellColor := ""
        If LVA_InfoArray_%Name%_0_%A_Index%_HasCellColor
          LVA_InfoArray_%Name%_0_%A_Index%_HasCellColor := ""
      }
    }
    Return
  }
  Else If (Switch = "GetStdColorBG")
    Return LVA_InfoArray_%Name%_BGColor
  Else If (Switch = "GetStdColorFG")
    Return LVA_InfoArray_%Name%_FGColor
  Else If (Switch = "GetCellColorBG")
    Return LVA_InfoArray_%Name%_%Row%_%Col%_BGColor
  Else If (Switch = "GetCellColorFG")
    Return LVA_InfoArray_%Name%_%Row%_%Col%_FGColor
  Else If (Switch = "GetCellType")
  {
    If LVA_InfoArray_%Name%_%Row%_%Col%_HasCellColor
      Return 1
    Else If LVA_InfoArray_%Name%_%Row%_%Col%_HasProgressBar
      Return 2
    Else If LVA_InfoArray_%Name%_%Row%_%Col%_HasMultiImage
      Return 3
    Else
      Return 0
  }
  Else If (Switch = "GetPB")
    Return LVA_InfoArray_%Name%_%Row%_%Col%_HasProgressBar
  Else If (Switch = "GetProgress")
    Return LVA_InfoArray_%Name%_%Row%_%Col%_ProgressBarProgress
  Else If (Switch = "GetPBR")
    Return LVA_InfoArray_%Name%_%Row%_%Col%_ProgressBarRange
  Else If (Switch = "GetPCB")
    Return LVA_InfoArray_%Name%_%Row%_%Col%_ProgressBarBckCol
  Else If (Switch = "GetPCS")
    Return LVA_InfoArray_%Name%_%Row%_%Col%_ProgressBarSCol
  Else If (Switch = "GetPCE")
    Return LVA_InfoArray_%Name%_%Row%_%Col%_ProgressBarECol
  Else If (Switch = "GetMI")
    Return LVA_InfoArray_%Name%_%Row%_%Col%_HasMultiImage
  Else If (Switch = "GetCol")
    Return LVA_InfoArray_%Name%_%Row%_%Col%_HasCellColor
  Else If (Switch = "GetARowBool")
    Return LVA_InfoArray_%Name%_ARowColor_Alternate
  Else If (Switch = "GetARowColB")
    Return LVA_InfoArray_%Name%_ARowColor_BColor
  Else If (Switch = "GetARowColF")
    Return LVA_InfoArray_%Name%_ARowColor_FColor
  Else If (Switch = "GetAColBool")
    Return LVA_InfoArray_%Name%_AColColor_Alternate
  Else If (Switch = "GetAColColB")
    Return LVA_InfoArray_%Name%_AColColor_BColor
  Else If (Switch = "GetAColColF")
    Return LVA_InfoArray_%Name%_AColColor_FColor
  Else If (Switch = "SetStdColorBG")
    LVA_InfoArray_%Name%_BGColor := Data
  Else If (Switch = "SetStdColorFG")
    LVA_InfoArray_%Name%_FGColor := Data
  Else If (Switch = "SetCellColorBG")
    LVA_InfoArray_%Name%_%Row%_%Col%_BGColor := Data
  Else If (Switch = "SetCellColorFG")
    LVA_InfoArray_%Name%_%Row%_%Col%_FGColor := Data
  Else If (Switch = "SetPB")
    LVA_InfoArray_%Name%_%Row%_%Col%_HasProgressBar := Data
  Else If (Switch = "SetProgress")
    LVA_InfoArray_%Name%_%Row%_%Col%_ProgressBarProgress := Data
  Else If (Switch = "SetPBR")
    LVA_InfoArray_%Name%_%Row%_%Col%_ProgressBarRange := Data
  Else If (Switch = "SetPCB")
    LVA_InfoArray_%Name%_%Row%_%Col%_ProgressBarBckCol := Data
  Else If (Switch = "SetPCS")
    LVA_InfoArray_%Name%_%Row%_%Col%_ProgressBarSCol := Data
  Else If (Switch = "SetPCE")
    LVA_InfoArray_%Name%_%Row%_%Col%_ProgressBarECol := Data
  Else If (Switch = "SetMI")
    LVA_InfoArray_%Name%_%Row%_%Col%_HasMultiImage := Data
  Else If (Switch = "SetCol")
    LVA_InfoArray_%Name%_%Row%_%Col%_HasCellColor := Data
  Else If (Switch = "SetARowBool")
    LVA_InfoArray_%Name%_ARowColor_Alternate := Data
  Else If (Switch = "SetARowColB")
    LVA_InfoArray_%Name%_ARowColor_BColor := Data
  Else If (Switch = "SetARowColF")
    LVA_InfoArray_%Name%_ARowColor_FColor := Data
  Else If (Switch = "SetAColBool")
    LVA_InfoArray_%Name%_AColColor_Alternate := Data
  Else If (Switch = "SetAColColB")
    LVA_InfoArray_%Name%_AColColor_BColor := Data
  Else If (Switch = "SetAColColF")
    LVA_InfoArray_%Name%_AColColor_FColor := Data
}
;~~~~End of LVA~~~~

;~~~~~AutoUpdate by Aldrin John O. Manalansan~~~~~
versionchecker(version)
{
	if A_IsCompiled
	{
		ToolTip,DOTA2 MOD Master:`nChecking for New Version,0,0
		UrlDownloadToFile,https://raw.githubusercontent.com/Aldrin-John-Olaer-Manalansan/DOTA-2-MOD-Master/master/Version.ini,%A_ScriptDir%\Plugins\Unzip\Version.ini
		if ErrorLevel
			return
		IniRead,webversion,%A_ScriptDir%\Plugins\Unzip\Version.ini,Version,appversion,%A_Space%
		if (webversion<>"") and (webversion<>A_Space) and (webversion>version)
		{
			msgbox,262180,New Version Available!,
(
DOTA2 MOD Master v%webversion% is now available to be downloaded, Would you like to migrate to the latest version?

Tip: You can Disable Automatic-Updates at "Advanced" Section.
)
			IfMsgBox Yes
				SetTimer,updateversion,1000
		}
		;FileDelete,%A_ScriptDir%\Plugins\Unzip\Version.ini
	}
}

updateversion:
ToolTip,DOTA2 MOD Master:`nDownloading New Version's Files,0,0
if DownloadFileURL([["https://github.com/Aldrin-John-Olaer-Manalansan/DOTA-2-MOD-Master/archive/master.zip",A_ScriptDir "\Plugins\Unzip\master.zip","DOTA2 MOD Master v" webversion]],3)[1]
	return
updatewassuccessful=1
updatefiles:
ifexist,%A_ScriptDir%\Plugins\Unzip\master.zip
{
	msgbox,262148,Update/Migration COMPLETE!,Latest Version of DOTA2 MOD Master has been successfully Installed, would you like to reload this program for this version to take effect?
	IfMsgBox Yes
	{
		gosub,updatemigrator
		if ErrorLevel=ERROR
			goto,updatefiles
		ExitApp
	}
	SetTimer,updateversion,Off
}
return

updatemigrator:
temp=
(join&
unzip.exe -o -qq master.zip "DOTA-2-MOD-Master-master/AJOM Innovations/AJOM's DOTA2 MOD Master/*"
xcopy "%A_ScriptDir%\Plugins\Unzip\DOTA-2-MOD-Master-master\AJOM Innovations\AJOM's DOTA2 MOD Master" "%A_ScriptDir%" /r /y /c /i /q /s
RD /S /Q "%A_ScriptDir%\Plugins\Unzip\DOTA-2-MOD-Master-master"
del /f /q "%A_ScriptDir%\Plugins\Unzip\master.zip"
"%A_ScriptFullPath%"
)
temp:=StrReplace(temp,"\","/")
run,%temp%,%A_ScriptDir%\Plugins\Unzip,Hide UseErrorLevel
return
;~~~~~end of AutoUpdate~~~~~


;~~~~~ CLEAN VARIABLES Function ~~~~~
cleanvars(matchingvalue:="!@#$^&*ClEaNaLl*&^$#@!")
/*
BY AJOM

REQUIRES LEXIKOS's ListGlobalVars() function for this function to work

cleanvars is used to clean the memory saved variables containing a content "matchingvalue"

eg.
cleanvars("") will clean all variables that are blank
cleanvars("jabawakee") will clean all variables with content of jabawakee
cleanvars(anyvar) will clean all variables with a content equat to the variable "anyvar"
cleanvars() will clean all variables! NO MERCY!
*/
{
	text :=	RegExReplace(ListGlobalVars(),"`am)\[.*$")	 ; remove the additional text for each var
	Loop,parse,text,`n,`r	 ; parse the list of var names[/color]
	{
		if	(A_LoopField="") or regexmatch(A_LoopField,"[^a-z A-Z0-9_]")
			continue
		else if A_LoopField is number
			continue
		else
		{
			if (matchingvalue="!@#$^&*ClEaNaLl*&^$#@!") or (%A_LoopField%=matchingvalue)
			{
				VarSetCapacity(%A_LoopField%, 0)	 ; clean baby, clean[/color]
				;msgbox %A_LoopField%
			}
		}
	}
}
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;~~~~~ an alternative for Listvars, returns the listvar contents
ListGlobalVars() ; By Lexikos
{
    static hwndEdit, pSFW, pSW, bkpSFW, bkpSW
    
    if !hwndEdit
    {
        dhw := A_DetectHiddenWindows
        DetectHiddenWindows, On
        Process, Exist
        ControlGet, hwndEdit, Hwnd,, Edit1, ahk_class AutoHotkey ahk_pid %ErrorLevel%
        DetectHiddenWindows, %dhw%
        
        astr := A_IsUnicode ? "astr":"str"
        ptr := A_PtrSize=8 ? "ptr":"uint"
        hmod := DllCall("GetModuleHandle", "str", "user32.dll", ptr)
        pSFW := DllCall("GetProcAddress", ptr, hmod, astr, "SetForegroundWindow", ptr)
        pSW := DllCall("GetProcAddress", ptr, hmod, astr, "ShowWindow", ptr)
        DllCall("VirtualProtect", ptr, pSFW, ptr, 8, "uint", 0x40, "uint*", 0)
        DllCall("VirtualProtect", ptr, pSW, ptr, 8, "uint", 0x40, "uint*", 0)
        bkpSFW := NumGet(pSFW+0, 0, "int64")
        bkpSW := NumGet(pSW+0, 0, "int64")
    }

    if (A_PtrSize=8) {
        NumPut(0x0000C300000001B8, pSFW+0, 0, "int64")  ; return TRUE
        NumPut(0x0000C300000001B8, pSW+0, 0, "int64")   ; return TRUE
    } else {
        NumPut(0x0004C200000001B8, pSFW+0, 0, "int64")  ; return TRUE
        NumPut(0x0008C200000001B8, pSW+0, 0, "int64")   ; return TRUE
    }
    
    ListVars
    
    NumPut(bkpSFW, pSFW+0, 0, "int64")
    NumPut(bkpSW, pSW+0, 0, "int64")
    
    ControlGetText, text,, ahk_id %hwndEdit%

    RegExMatch(text, "sm)(?<=^Global Variables \(alphabetical\)`r`n-{50}`r`n).*", text)
    return text
}
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

DownloadFileURL(UrlToFile,attempcount:=1, Overwrite := True, UseProgressBar := True) ; by aldrin
;UrlToFile must be a 2D Array
;usage	UrlToFile:=[[URL1,SaveFileAs1],[URL2,SaveFileAsn],[URLi,SaveFileAsn]]	; multiple instances
;		UrlToFile:=[[URL1,SaveFileAs1]]											; single instance

;UrlToFile[i,1]	-	URL to Download
;UrlToFile[i,2]	-	SaveFileAs
;UrlToFile[i,3]	-	Progressbar "Downloading" %Filename% Message(Optional), can only create 2 element array instead of 3 element array

;attempcount	-	in case downloading file fails, how many attemps would this function will try to redownload the file
;Overwrite		-	overwrite existing files?
;UseProgressBar	-	show a progressbar when true or 1
{
    FinalSize:=FinishedSize:=0
	savefilesize:=[],haserror:=[]
    ;Check if the user wants a progressbar
      If (UseProgressBar)
	  {
          ;Initialize the WinHttpRequest Object
            WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
			
			for index, in UrlToFile
			{
			;Check if the file already exists and if we must not overwrite it
				If (!Overwrite and FileExist(UrlToFile[index,2])) or (UrlToFile[index,2]="")
					continue
				
				loop %attempcount%
				{
					try
					{
					;Download the headers
						WebRequest.Open("HEAD", UrlToFile[index,1])
						WebRequest.Send()
						
						break ; incase the above commands fails, this will never be reached
					}
				}
			
				try
				{
				;Store the header which holds the file size in a variable:
					savefilesize[index]:=WebRequest.GetResponseHeader("Content-Length")
					FinalSize+=savefilesize[index]
				}
				catch
				{
					;throw Exception("could not get Content-Length for URL: " UrlToFile)
						savefilesize[index]= ; blank size
				}
			}
			VarSetCapacity(WebRequest,0)
      }
	  
    ;Create the progressbar and the timer
      Progress,% "A M1 H120 W" A_ScreenWidth/2,,Downloading...,Fetching`,Please Wait.
      SetTimer, __UpdateProgressBar, 500
	  
	  for index, in UrlToFile
	  {
		;Check if the file already exists and if we must not overwrite it
		If (!Overwrite and FileExist(UrlToFile[index,2])) or (UrlToFile[index,2]="")
			continue
		loop %attempcount%
		{
		;Download the file
			UrlDownloadToFile,% UrlToFile[index,1],% UrlToFile[index,2]
			error:=ErrorLevel
			if !error
				break
		}
		haserror.push(error)
	  }
	  
    ;Remove the timer and the progressbar because the download has finished
      If (UseProgressBar) {
          Progress, Off
          SetTimer, __UpdateProgressBar, Off
      }
    Return
    
    ;The label that updates the progressbar
      __UpdateProgressBar:
			if (saveindex!=index)
			{
				if savefilesize[saveindex] is Number
					FinishedSize+=savefilesize[saveindex]
				saveindex:=index
			}
          ;Get the current filesize and tick
            CurrentSize := FileOpen(UrlToFile[index,2], "r").Length ;FileGetSize wouldn't return reliable results
            CurrentSizeTick := A_TickCount
          ;Calculate the downloadspeed
            Speed := Round(((CurrentSize-LastSize)/1024)/((CurrentSizeTick-LastSizeTick)/1000))
          ;Save the current filesize and tick for the next time
            LastSizeTick := CurrentSizeTick
            LastSize := FileOpen(UrlToFile[index,2], "r").Length
          ;Calculate percent done
			if (savefilesize[index]="")
			{
				PercentDone:=0
				PercentDonetext=Unknown Percentage
			}
            else
			{
			;Calculate the remaining time
				MSEC_Time:=Round((FinalSize-CurrentSize-FinishedSize)/Speed)
				timesketch:=Format_Msec(MSEC_Time,"Array")
				FinishedDate+=timesketch["Day"],D
				FinishedDate+=timesketch["Hour"],H
				FinishedDate+=timesketch["Minute"],M
				FinishedDate+=timesketch["Second"],S
				FormatTime,FinishedDate,%FinishedDate%
				FinishedDate:="Time Remaining - " Format_Msec(MSEC_Time,"Day Hour Minute Second") "`nFinish Date - " FinishedDate
				
				PercentDone := Round((CurrentSize+FinishedSize)/FinalSize*100)
				PercentDonetext=%PercentDone%`%
			}
          ;Update the ProgressBar
			
            Progress,%PercentDone%,Downloading at %Speed% KB/s`n%FinishedDate%,%PercentDonetext% Done,% "Downloading " UrlToFile[index,3] " (" PercentDonetext ")"
      Return haserror
}

EmptyMem(PID=""){ ; removes junk memories making the injector run lightly
    dllcall("psapi.dll\EmptyWorkingSet", "UInt", -1)
	
	pid:=(pid="") ? DllCall("GetCurrentProcessId") : pid
    h:=DllCall("OpenProcess", "UInt", 0x001F0FFF, "Int", 0, "Int", pid)
    DllCall("SetProcessWorkingSetSize", "UInt", h, "Int", -1, "Int", -1)
	
	DllCall("SetProcessWorkingSetSize", Int,-1, Int,-1, Int,-1 )
	
    DllCall("CloseHandle", "Int", h)
}
;;~~~~~~~~~~~~~~~~~~~~~~~End of Functions~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

aboutguiguisize:
Gui,aboutgui:Default
AutoXYWH("w",["text39","text40","text41","text42","text33","text34","text50","text53","text54","text55","text56","text57"]) ; resize all links
AutoXYWH("x0.5 y","text43") ; resize buttons
AutoXYWH("wh",["text35","text36","text37","text38","tababout","text44"]) ; resize texts
;if sO_ci_siwfwimbuqparam=
;{
;	links=text39,text40,text41,text42,text33,text34,text50
;	buttons=text43
;	sO_ci_siwfwimbuqparam=text35,text36,text37,text38,tababout,%links%,%buttons%,text44
;	buttons:=links:=""
;}
;loop,parse,sO_ci_siwfwimbuqparam,`,
;{
;	if InStr(links,A_LoopField)
;	{
;		Anchor(A_LoopField,"w")
;	}
;	else if InStr(buttons,A_LoopField)
;	{
;		Anchor(A_LoopField,"x0.5 y")
;	}
;	else
;	{
;		Anchor(A_LoopField,"wh")
;	}
;}
return

MainGUIGuiSize:
if (A_DefaultGui!="MainGUI")
Gui,MainGUI:Default
;DllCall("QueryPerformanceCounter", "Int64P", t0)

if !IsObject(xv1d2_wv1d2_param)
	xv1d2_wv1d2_param:=["injectto"]
	
if !IsObject(xv1d2_wv1d2_h_param)
	xv1d2_wv1d2_h_param:=["showitems","announcerview","reportshow","terrainchoice","weatherchoice","multikillchoice","emblemchoice","musicchoice","cursorchoice","loadingscreenchoice","courierchoice","wardchoice","hudchoice","radcreepchoice","direcreepchoice","radtowerchoice","diretowerchoice","versuscreenchoice","emoticonchoice"]
	
if !IsObject(wv1d2_h_param)
	wv1d2_h_param:=["herochoice","tauntview","errorshow","singlesourcechoicegui","multiplestyleschoicegui"]
	
if !IsObject(x_y_param)
	x_y_param:=["text31","text51"]
if !IsObject(y_w_param)
	y_w_param:=["datadirview","hdatadirview","MyProgress","searchnofound"]
if !IsObject(x_h_param)
	x_h_param:=["text46"]
if !IsObject(w_h_param)
{
	w_h_param:=["invlv","searchshow","itemview","chview","OuterTab","extfilelist","slotstats"]
	loop,parse,innertabparam,`,
		w_h_param.Push(A_LoopField)
}
	
if !IsObject(wv1d2_param)
	wv1d2_param:=["injectfrom"]
	
if !IsObject(xv1d2_param)
	xv1d2_param:=["text4","text32"]
if !IsObject(xv5d16_param)
	xv5d16_param:=["extlistup","extlistdown"]
if !IsObject(xv11d16_param)
	xv11d16_param:=["extlistrefresh"]
	
if !IsObject(xv1d3_y_param)
	xv1d3_y_param:=["text7","text17","text20"]
if !IsObject(xv2d3_y_param)
	xv2d3_y_param:=["text8","text16","text19"]
if !IsObject(xv1d2_y_param)
	xv1d2_y_param:=["text23","usemiscon","text26","useextfile"]
	
if !IsObject(x_param)
	x_param:=["text1","text2","text25","chbar","text27","chsave","text28","text45"]
if !IsObject(y_param)
	y_param:=["text6","text18","text30"]
if !IsObject(w_param)
	w_param:=["searchbar","idbar","namebar","prefabbar","itemslotbar","modelpathbar","heroesbar","invdirview","mdirview","text24","giloc","dota2dir","useextitemgamefile","useextportraitfile"]
if !IsObject(h_param)
	h_param:=["statscalibrator"]

if quv_widqw_vngowuparam=
	quv_widqw_vngowuparam=w_h_param,x_y_param,y_w_param,x_param,y_param,xv1d2_wv1d2_h_param,w_param,wv1d2_param,xv1d2_wv1d2_param,xv1d2_param,xv1d2_y_param,wv1d2_h_param,xv1d3_y_param,xv2d3_y_param,x_h_param,xv5d16_param,xv11d16_param,h_param
loop,parse,quv_widqw_vngowuparam,`,
{
	StringTrimRight,command,A_LoopField,5
	sizesave=%A_LoopField%
	tempo := StrReplace(A_LoopField,"v","v",sizeint)
	loop %sizeint%
	{
		StringReplace,command,command,% SubStr(sizesave,InStr(sizesave,"v",,,A_Index)+1,InStr(sizesave,"_",,InStr(sizesave,"v",,,A_Index)) - InStr(sizesave,"v",,,A_Index)-1),% StrJoin(Eval(StrReplace(SubStr(sizesave,InStr(sizesave,"v",,,A_Index)+1,InStr(sizesave,"_",,InStr(sizesave,"v",,,A_Index)) - InStr(sizesave,"v",,,A_Index)-1),"d","/")), "`n"),1
	}
	StringReplace,command,command,v,,1
	StringReplace,command,command,_,%A_Space%,1
	AutoXYWH(command,%A_LoopField%)
}
GuiControl,MoveDraw,searchnofound
GuiControl,MoveDraw,text30
GuiControl,MoveDraw,text31
;GuiWidth := A_GuiWidth
;DllCall("QueryPerformanceCounter", "Int64P", t1)
;WinSet, Redraw, , A
Return

leakdestroyer:
VarSetCapacity(portstring,0),VarSetCapacity(masterfilecontent,0),VarSetCapacity(fileto,0),VarSetCapacity(filefrom,0),VarSetCapacity(filestring2,0),VarSetCapacity(filestring1,0),VarSetCapacity(npcunit,0),VarSetCapacity(npchero,0),VarSetCapacity(vpktmp,0),VarSetCapacity(tmp1,0),VarSetCapacity(tmp,0)
cleanvars("") ; clean blank varibles from memory
EmptyMem()
return

externalfiles:
if useextfile=1
{
	Gui,MainGUI:Show,NA,AJOM's Dota 2 MOD Master ; remove that irritating items per second
	IfNotExist,%A_ScriptDir%\Generated MOD\
	{
		FileCreateDir, %A_ScriptDir%\Generated MOD
	}
	else ifexist,%A_ScriptDir%\Generated MOD\pak01_dir\
	{
		FileRemoveDir,%A_ScriptDir%\Generated MOD\pak01_dir,1
	}
	if A_DefaultListView<>extfilelist
	{
		Gui, MainGUI:ListView, extfilelist
	}
	Loop % LV_GetCount()
	{
		LV_GetText(tmpstring,A_Index,2)
		GuiControl,Text,searchnofound,Merging External Files with the Operation Files`, Current Folder : %tmpstring%
		if tmpstring="OPERATION FILES"
		{
			if useextportraitfile<>1
			{
				ifnotexist,%A_ScriptDir%\Plugins\VPKCreator\backup\
				{
					FileCreateDir,%A_ScriptDir%\Plugins\VPKCreator\backup
				}
				FileMove,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\scripts\npc\portraits.txt,%A_ScriptDir%\Plugins\VPKCreator\backup\,1
			}
			if useextitemgamefile<>1
			{
				ifnotexist,%A_ScriptDir%\Plugins\VPKCreator\backup\
				{
					FileCreateDir,%A_ScriptDir%\Plugins\VPKCreator\backup
				}
				FileMove,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir\scripts\items\items_game.txt,%A_ScriptDir%\Plugins\VPKCreator\backup\,1
			}
			FileMoveDir,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir,%A_ScriptDir%\Generated MOD\pak01_dir,2
		}
		else if (A_Index=LV_GetNext(A_Index-1,"Checked"))
		{
			LV_GetText(tmpstring,A_Index,7)
			filecopydir,%tmpstring%\,%A_ScriptDir%\Generated MOD\pak01_dir,1
		}
	}
	if useextportraitfile<>1
	{
		FileMove,%A_ScriptDir%\Plugins\VPKCreator\backup\portraits.txt,%A_ScriptDir%\Generated MOD\pak01_dir\scripts\npc\,1
	}
	else
	{
		FileMove,%A_ScriptDir%\Plugins\VPKCreator\backup\portraits.txt,%A_ScriptDir%\Generated MOD\pak01_dir\scripts\npc\,0
	}
	if useextitemgamefile<>1
	{
		FileMove,%A_ScriptDir%\Plugins\VPKCreator\backup\items_game.txt,%A_ScriptDir%\Generated MOD\pak01_dir\scripts\items\,1
	}
	else
	{
		FileMove,%A_ScriptDir%\Plugins\VPKCreator\backup\items_game.txt,%A_ScriptDir%\Generated MOD\pak01_dir\scripts\items\,0
	}
	FileMoveDir,%A_ScriptDir%\Generated MOD\pak01_dir,%A_ScriptDir%\Plugins\VPKCreator\pak01_dir,2
}
return

extlistrefresh:
Gui, MainGUI:+Disabled
IfNotExist,%A_ScriptDir%\External Files\
{
	FileCreateDir,%A_ScriptDir%\External Files\
}
else
{
	GuiControl, MainGUI:-Redraw, extfilelist
	if A_DefaultListView<>extfilelist
	{
		Gui, MainGUI:ListView, extfilelist
	}
	LV_ClearAll()
	Loop, Files,%A_ScriptDir%\External Files\*,D
	{
		VarSetCapacity(intsaver,0),VarSetCapacity(position,0),VarSetCapacity(boolean,0),VarSetCapacity(boolean1,0)
		GuiControl,Text,searchnofound,External Files :  Found %A_LoopFileName% : Counting Model Files Present
		Loop, Files,%A_LoopFilePath%\*.vmdl_c,R
		{
			intsaver=%A_Index%
		}
		GuiControl,Text,searchnofound,External Files :  Found %A_LoopFileName% : Counting Particle Files Present
		Loop, Files,%A_LoopFilePath%\*.vpcf_c,R
		{
			position=%A_Index%
		}
		IfExist,%A_LoopFilePath%\scripts\items\items_game.txt
		{
			boolean=True
		}
		else boolean=False
		IfExist,%A_LoopFilePath%\scripts\npc\portraits.txt
		{
			boolean1=True
		}
		else boolean1=False
		LV_Add(,A_Space,A_LoopFileName,intsaver,position,boolean,boolean1,A_LoopFilePath) ; the first "A_Space" variable here is a dummy character to avoid EVIL CRASH, Please dont touch it or else spamming the refresh list button will lead to crash
	}
	;"operation files" is used at ExternalFiles Label
	LV_Add(,LV_GetCount()+1,"""OPERATION FILES""","---->","This Row is the ","MAIN Files generated ","by this tool. ","It is not advisable reordering this row upwards unless you know what you're doing`, moving this row upwards will make OPERATION FILES more superior than External Files found beneath this row so keep that in mind.") ; the first "A_Space" variable here is a dummy character to avoid EVIL CRASH, Please dont touch it or else spamming the refresh list button will lead to crash
	IniRead,tmpint, %A_ScriptDir%\Settings.aldrin_dota2mod,External_Files,CountExternalFolder,0
	loop %tmpint%
	{
		VarSetCapacity(intsaver,0),VarSetCapacity(boolean,0),VarSetCapacity(boolean1,0),VarSetCapacity(tmpint,0),VarSetCapacity(tmpstring,0)
		position=%A_Index%
		IniRead,intsaver, %A_ScriptDir%\Settings.aldrin_dota2mod,External_Files,ExternalFolder%A_Index%Enabled,%A_Space%
		IniRead,tmpint, %A_ScriptDir%\Settings.aldrin_dota2mod,External_Files,ExternalFolder%A_Index%,%A_Space%
		Loop % LV_GetCount()
		{
			LV_GetText(tmpstring,A_Index,7)
			if tmpint=%tmpstring%
			{
				LV_Modify(A_Index,intsaver,position)
			}
		}
	}
	LV_ModifyCol(1,"Sort Integer")
	VarSetCapacity(intsaver,0),VarSetCapacity(boolean,0),VarSetCapacity(boolean1,0),VarSetCapacity(tmpint,0),VarSetCapacity(tmpstring,0),VarSetCapacity(position,0)
	gosub,extrerank
	gosub,lvautosize
	GuiControl, MainGUI:+Redraw, extfilelist
}
GuiControl,MainGUI:Text,searchnofound,%defaultshoutout%
GuiControl,MainGUI:Show,searchnofound
Gui, MainGUI:-Disabled
return

extrerank:
loop % LV_GetCount()
{
	LV_Modify(A_Index,,A_Index)
}
loop 4
{
	LV_ModifyCol(A_Index+2,"Center")
}
return

extlistup:
if A_DefaultListView<>extfilelist
{
	Gui, MainGUI:ListView, extfilelist
}
LV_MoveRow()
gosub,extrerank
return

extlistdown:
if A_DefaultListView<>extfilelist
{
	Gui, MainGUI:ListView, extfilelist
}
LV_MoveRow(false)
gosub,extrerank
return

showtooltips:
Gui,MainGUI:Submit,NoHide
if showtooltips=1
{
	OnMessage(0x200, "WM_MOUSEMOVE")
}
else
{
	OnMessage(0x200,"")
	WM_MOUSEMOVE()
}
return

alldraggedfiles:
Gui,draggedfilesgui:Submit,NoHide
Loop Files,%selectedfileh%, F
{
	if A_LoopFileExt=aldrin_dota2hidb
	{
		maphdatadirview:=A_LoopFileLongPath
	}
}
Loop Files,%selectedfileg%, F
{
	if A_LoopFileExt=aldrin_dota2db
	{
		mapdatadirview:=A_LoopFileLongPath
	}
}
goto,continueexecution
return



draggedfilesguiguisize:
Gui,draggedfilesgui:Default
;Anchor("text47","w")
;Anchor("selectedfileg","w0.5 h")
;Anchor("selectedfileh","x0.5 w0.5 h")
;Anchor("text48","y")
;Anchor("text49","x0.5")
AutoXYWH("w","text47")
AutoXYWH("w0.5 h","selectedfileg")
AutoXYWH("x0.5 w0.5 h","selectedfileh")
AutoXYWH("y","text48")
AutoXYWH("x0.5","text49")
return

slotstats:
GuiControl,Text,searchnofound,Constructing Handy-Injection Statistics.
herolist:=[] ; declares that this is an array
tmp1:=GlobalArray["activelist.txt"]
Loop
{
	StringGetPos, ipos, tmp1,npc_dota_hero_,L%A_Index%
	if ipos<0
	{
		Break
	}
	StringGetPos, ipos1, tmp1,",,%ipos% ;"
	StringMid,tmp2,tmp1,% ipos+1,% ipos1-ipos
	if tmp2<>
	{
		herolist.push(tmp2) ; stores the npc_dota_hero_*** to the last unused element(rightmost element)
	}
	if ErrorLevel=1 ; hunt this errorlevel
	{
		Break
	}
}
GuiControl, MainGUI:-Redraw,slotstats
GuiControl, MainGUI:-Redraw,statscalibrator
Loop % herolist.Length() ; counts the number of elements inside the array
{
	npcherodata:=npcherodetector(herolist[A_Index],dota2dir "\game\dota\scripts\npc\npc_heroes.txt")
	npcitemslotsdetector(npcherodata,itemslotscount) ; itemslotscount returns the number of item slots of a hero
	if A_DefaultListView<>slotstats
	{
		Gui, MainGUI:ListView,slotstats
	}
	heroname:=StrReplace(herolist[A_Index],"npc_dota_hero_") ; removes this irritating line npc_dota_hero_
	LV_Add(,heroname,itemslotscount,0,itemslotscount) ; (slot count, slot occupied, slot unused count)
}
LV_ModifyCol(1,"Sort")
gosub,lvautosize
herolist= ; voids the array
GuiControl, MainGUI:+Redraw,slotstats
GuiControl, MainGUI:+Redraw,statscalibrator
GuiControl,MainGUI:Text,searchnofound,%defaultshoutout%
GuiControl,MainGUI:Show,searchnofound
return

refreshstatistics() {
;everytime the statistics subsection of handy injection is pressed, this will rescan the items occupied at the operations
	;GuiControl,Text,searchnofound,Constructing Handy-Injection Statistics.
	GuiControl, MainGUI:-Redraw,slotstats
	GuiControl, MainGUI:-Redraw,itemview
	Gui, MainGUI:ListView,slotstats
	LV_DeleteCol(3),LV_InsertCol(3,,"Item Slots Occupied") ; temporary deletes the column and brings it back with an empty resources, this method is for performance purposes
	Gui, MainGUI:ListView,itemview
	loop % LV_GetCount()
	{
		Gui, MainGUI:ListView,itemview
		LV_GetText(heroname1,A_Index,5) ; get the hero user at this listview(column 5)
		Gui, MainGUI:ListView,slotstats
		loop % LV_GetCount()
		{
			LV_GetText(heroname2,A_Index,1) ; get the hero user at this listview(column 1)
			if heroname1=%heroname2%
			{
				;msgbox %heroname1%`n`n%heroname2%
				LV_GetText(slotmax,A_Index,2) ; get the current number of slots
				LV_GetText(slotcount,A_Index,3) ; get the current number of slots
				slotcount++ ; add 1 to the current number of slots
				LV_Modify(A_Index,"Col3",slotcount,slotmax-slotcount)
				break
			}
		}
	}
	GuiControl, MainGUI:+Redraw,slotstats
	GuiControl, MainGUI:+Redraw,itemview
	;GuiControl,Text,searchnofound,%defaultshoutout%
	;GuiControl,Show,searchnofound
}

statscalibrator:
if (InStr(ErrorLevel, "C", true)) or (InStr(ErrorLevel, "c", true))
{
	if A_DefaultListView<>slotstats
	{
		Gui, MainGUI:ListView,slotstats
	}
	loop % LV_GetCount()
	{
		if A_DefaultListView<>slotstats
		{
			Gui, MainGUI:ListView,slotstats
		}
		LV_GetText(heroname,A_Index,1)
		heroname=npc_dota_hero_%heroname%
		npcherodata:=npcherodetector(heroname,dota2dir "\game\dota\scripts\npc\npc_heroes.txt") ; extracts the data of a specific hero
		refreshnpcitemslotsdetector(npcherodata,itemslotscount) ; itemslotscount returns the number of item slots of a hero
		
		if A_DefaultListView<>slotstats
		{
			Gui, MainGUI:ListView,slotstats
		}
		LV_GetText(occupiedslots,A_Index,3)
		if occupiedslots=
			occupiedslots:=0
		LV_Modify(A_Index,"Col2",itemslotscount,occupiedslots,itemslotscount-occupiedslots) ; edits the listview statistics again
	}
	
}
return

hincprio:
Gui, MainGUI:Default
Gui, MainGUI:Submit,NoHide
Gui, MainGUI:ListView,itemview
lvrowswapper(A_DefaultListView,"7",1)
return

hdecprio:
Gui, MainGUI:Default
Gui, MainGUI:Submit,NoHide
Gui, MainGUI:ListView,itemview
lvrowswapper(A_DefaultListView,"7")
return

lvrowswapper(listview,columncount,isincrement:=0)
{
	Gui, MainGUI:ListView,%listview%
	if (isincrement=0)
	{
		Loop % LV_GetCount()
		{
			if (LV_GetNext(A_Index-1)=A_Index) and (A_Index<>1)
			{
				offset2:=A_Index-1,offset1:=A_Index
				loop %columncount%
				{
					LV_GetText(temp1,offset1,A_Index),LV_GetText(temp2,offset2,A_Index)
					LV_Modify(offset1,"-Select Col" A_Index,temp2),LV_Modify(offset2,"Select Col" A_Index,temp1)
				}
			}
		}
	}
	else
	{
		Loop % LV_GetCount()
		{
			if (LV_GetNext(LV_GetCount()-A_Index)=LV_GetCount()-A_Index+1) and (LV_GetCount()-A_Index+1<>LV_GetCount())
			{
				offset1:=LV_GetCount()-A_Index+2,offset2:=LV_GetCount()-A_Index+1
				;msgbox % "at`n`n" LV_GetCount() " and " A_Index
				loop %columncount%
				{
					LV_GetText(temp1,offset1,A_Index),LV_GetText(temp2,offset2,A_Index)
					;msgbox %offset1% and %offset2%`n`n%temp1% and %temp2%
					LV_Modify(offset1,"Select Col" A_Index,temp2),LV_Modify(offset2,"-Select Col" A_Index,temp1)
				}
			}
		}
	}
}

/*

;for testing purposes

$y::
Gui, MainGUI:Default
Gui, MainGUI:Submit, NoHide
if A_DefaultListView<>itemview
{
	Gui, MainGUI:ListView, itemview
}
Gui, MainGUI:Submit, NoHide
LV_ModifyCol(4,"SortDesc Integer")
msgbox % A_DefaultListView "`n" LV_GetCount()
return

*/

/*
~$^+!l::
global debugmode
if debugmode
debugmode:=0
else debugmode:=1
tooltip, DEBUGMODE : %debugmode%
sleep 500
tooltip
return
*/

/*

add teleport effect
add blink effect
add socket gem
make misc like handy injection method
bug sa general redraw
custom items_game.txt para sa handy injection
warn user kung nagbago items_game.txt compare sa last generated pak01_dir items_game.txt generate as scriptdir/library/mod_items_game.txt
divide number of items into multiple custom processes
timedverinteg function di madetect variables sa timer

*/