#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance off
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

BGEffects := "none|Enfeeble all X|Heal all X|Protect all X|Rally all X|Siege all X|Strike all X|Weaken all X|Enhance all Armor X|Enhance all Berserk X|Enhance all Corrosive X|Enhance all Counter X|Enhance all Enfeeble X|Enhance all Evade X|Enhance all Heal X|Enhance all Inhibit X|Enhance all Leech X|Enhance all Pierce X|Enhance all Poison X|Enhance all Protect X|Enhance all Rally X|Enhance all Siege X|Enhance all Strike X|Enhance all Weaken X|Metamorphosis|Reaping X"
IniFileName := "data\SimpleTUOptimizeStarter.ini"
IniSection := "onLoad"

IniRead, IniMyDeck, %IniFileName%, %IniSection%, MyDeck, Cyrus, Medic, Revolver, Imperial APC, Medic, Imperial APC
IniRead, IniMySiege, %IniFileName%, %IniSection%, MySiege, %A_Space%
IniRead, IniEnemiesDeck, %IniFileName%, %IniSection%, EnemiesDeck, Mission #94
IniRead, IniEnemySiege, %IniFileName%, %IniSection%, EnemySiege, %A_Space%
IniRead, IniVIP, %IniFileName%, %IniSection%, VIP, %A_Space%
IniRead, IniIterations, %IniFileName%, %IniSection%, Iterations, 10000
IniRead, IniThreads, %IniFileName%, %IniSection%, Threads, 4
IniRead, IniSimOptions, %IniFileName%, %IniSection%, SimOptions, %A_Space%
IniRead, IniEffect, %IniFileName%, %IniSection%, Effect, 1
IniRead, IniMode, %IniFileName%, %IniSection%, Mode, 1
IniRead, IniCustomDeckFile, %IniFileName%, %IniSection%, CustomDeckFile, 1
IniRead, IniLog, %IniFileName%, %IniSection%, Log, 1
Mode%IniMode% := "Checked"

IniRead, IniOrder, %IniFileName%, %IniSection%, Order, 1
Order%IniOrder% := "Checked"


IniRead, IniOperation, %IniFileName%, %IniSection%, Operation, 1
Operation%IniOperation% := "Checked"

IniRead, IniLog, %IniFileName%, %IniSection%, Log, 1
Log%IniLog% := "Checked"

Menu, MyMenu, Add, ownedcards.txt, MenuOwnedcards
Menu, MyMenu, Add, customdecks.txt, MenuCustomdecks
Menu, MyMenu, Add, cardabbrs.txt, MenuCardabbrs
Menu, MyMenu, Add, Update XMLs, MenuUpdate
Menu, MyMenu, Add, Help, MenuHelp
Menu, MyMenu, Add, Web, MenuWeb
Gui, Menu, MyMenu
Gui, Add, Text, r5, My Deck:
Gui, Add, Text, r1, My Fortress:
Gui, Add, Text, r5, Enemy Deck(s):
Gui, Add, Text, r1, Enemy Fortress:
Gui, Add, Text, r1, VIP Units:
Gui, Add, Text, r1, Effect:
Gui, Add, Text, r1, Mode:
Gui, Add, Text, r1, Order:
Gui, Add, Text, r1, Operation:
Gui, Add, Text, r1, Flags:

Gui, Add, Text, r1, Custom Deck File:

Gui, Add, Text, r1, Log:


Gui, Add, Edit, vMyDeck ym w600 r5, %IniMyDeck%
Gui, Add, Edit, vMySiege w600 r1, %IniMySiege%
Gui, Add, Edit, vEnemiesDeck w600 r5, %IniEnemiesDeck%
Gui, Add, Edit, vEnemySiege w600 r1, %IniEnemySiege%
Gui, Add, Edit, vVIP w600 r1, %IniVIP%
Gui, Add, ComboBox, vEffect Choose1, %BGEffects%
Gui, Add, Radio, vMode r1 %Mode1% section, PVP
Gui, Add, Radio, ys %Mode2%, PVP (defense)
Gui, Add, Radio, ys %Mode3%, Guildwar
Gui, Add, Radio, ys %Mode4%, Guildwar (defense)
Gui, Add, Radio, ys %Mode5%, Brawl
Gui, Add, Radio, ys %Mode6%, Raid
Gui, Add, Radio, ys %Mode7%, Campaign
Gui, Add, Radio, vOrder r2 xs Group %Order1% section, Random
Gui, Add, Radio, r2 ys %Order2%, Ordered
Gui, Add, Radio, vOperation r1 xs Group %Operation1% section, Climb
Gui, Add, Radio, r1 ys %Operation2%, Sim
Gui, Add, Radio, r1 ys %Operation3%, Reorder
Gui, Add, Text, r1 ys, Iterations:
Gui, Add, Edit, vIterations w100 r1 ys-3, %IniIterations%
Gui, Add, Text, r1 ys, Threads:
Gui, Add, Edit, vThreads ys-3 w50, %IniThreads%
Gui, Add, Edit, vSimOptions r1 xs w600, %IniSimOptions%

Gui, Add, Button, r1 w50 section, ...
Gui, Add, Edit, vCustomDeckFile r1 ys w350 ReadOnly, %IniCustomDeckFile%
Gui, Add, Button, r1 ys w50, Edit
Gui, Add, Button, r1 ys w50, Clear

Gui, Add, Radio, vLog r1 xs %Log1% section, Yes
Gui, Add, Radio, r1 ys %Log2%, No

Gui, Add, Button, default r2 w100 x100 y+15 section, Simulate
Gui, Add, Button, r2 w100 ys xs+200, Exit
Gui, Show,, Simple Tyrant Unleashed Optimize Starter
return  

Button...:
Gui, Submit
FileSelectFile, SelectedFile, 3, %A_WorkingDir%\data\ , Open a Owned Card text file, Text Documents (*.txt;)
if SelectedFile !=
	GuiControl,, CustomDeckFile, %SelectedFile%
Gui, Show
return

ButtonClear:
Gui, Submit
GuiControl,, CustomDeckFile, 
Gui, Show
return

ButtonEdit:
Gui, Submit
Run, Notepad.exe %CustomDeckFile%
Gui, Show
return

ButtonSimulate:
Gui, Submit
selMode :=  ( Mode == 1 ? "pvp" : Mode == 2 ? "pvp-defense" : Mode == 3 ? "gw" : Mode == 4 ? "gw-defense" :Mode == 5 ? "brawl" : Mode == 6 ? "raid" : "campaign")
selOrder :=  ( Order == 1 ? "random" : "ordered" )
selOperation :=  ( Operation == 1 ? "climb" : Operation == 2 ? "sim" : "reorder" )
selMySiege := ( MySiege == "" ? "" : "yf """ MySiege """ ")
selEnemySiege := ( EnemySiege == "" ? "" : "ef """ EnemySiege """ ")
selVIP := ( VIP == "" ? "" : "vip """ VIP """ " )
selEffect := ( Effect == "" || Effect == "none" ? "" : "-e """ Effect """ ")
selThreads := ( Threads == "4" ? "" : "-t " Threads " ")
selSimOptions := ( SimOptions == "" ? "" : SimOptions " ")

selCustomDeckFile := ( CustomDeckFile == "" ? "" : "-o=""" CustomDeckFile """ ")

FormatTime, TimeString,, yyyyMMdd_hhmmss
selLogFileName := ( A_WorkingDir "\log\Log_" TimeString "_" MyDeck "_" EnemiesDeck ".txt" )
selLogFirstLine := ( TimeString "_" MyDeck "_" EnemiesDeck "_" selMode "_" selOrder "_" selMySiege "_" selEnemySiege "_" selVIP "_" selEffect "_" selSimOptions "_" selOperation "_" Iterations  )
StringReplace, selLogFileName, selLogFileName, ",, All
StringReplace, selLogFileName, selLogFileName,  %A_Space%,_, All
if Log = 1
	selOutputLog := ( "| wtee -a " selLogFileName )
execString = tuo "%MyDeck%" "%EnemiesDeck%" %selMode% %selOrder% %selMySiege%%selEnemySiege%%selVIP%%selEffect%%selThreads%%selSimOptions%%selOperation% %Iterations% %selCustomDeckFile% %selOutputLog%
Run, cmd.exe /c title TUOptimizeOutput && echo %execString% && %execString% && pause
Gui, Show
return

MenuHelp:
Gui, Submit
Run, cmd.exe /c title TUOptimizeOutput && echo tuo && tuo && pause
Gui, Show
return

MenuWeb:
Gui, Submit
Run https://github.com/andor9/tyrant_optimize/releases
Gui, Show
return

MenuUpdate:
MsgBox, 0, Update started, Updating fusion_recipes_cj2.xml`, missions.xml`, cards.xml and raids.xml.`nPlease wait at least one minute. A new window should open soon.`nThis Window will auto close in 5 seconds. , 5
UrlDownloadToFile, http://mobile.tyrantonline.com/assets/fusion_recipes_cj2.xml, data\fusion_recipes_cj2.xml
had_error := false
if ErrorLevel
{
    MsgBox, Error downloading fusion_recipes_cj2.xml.
    had_error := true
}
UrlDownloadToFile, http://mobile.tyrantonline.com/assets/missions.xml, data\missions.xml
if ErrorLevel
{
    MsgBox, Error downloading missions.xml.
    had_error := true
}
UrlDownloadToFile, http://mobile.tyrantonline.com/assets/cards.xml, data\cards.xml
if ErrorLevel
{
    MsgBox, Error downloading cards.xml.
    had_error := true
}
UrlDownloadToFile, https://raw.githubusercontent.com/andor9/tyrant_optimize/unleashed/data/raids.xml, data\raids.xml
if ErrorLevel
{
    MsgBox, Error downloading raids.xml.
    had_error := true
}
if !had_error
    MsgBox, 0, Update finished, xml files successfully updated.`nThis Window will auto close in 2 seconds., 2
Gui, Show
return

MenuOwnedcards:
Gui, Submit
Run, Notepad.exe data\ownedcards.txt
Gui, Show
return

MenuCustomdecks:
Gui, Submit
Run, Notepad.exe data\customdecks.txt
Gui, Show
return

MenuCardabbrs:
Gui, Submit
Run, Notepad.exe data\cardabbrs.txt
Gui, Show
return

GuiClose:
ButtonExit:
Gui, Submit
IniWrite, %MyDeck%, %IniFileName%, %IniSection%, MyDeck
IniWrite, %MySiege%, %IniFileName%, %IniSection%, MySiege
IniWrite, %EnemiesDeck%, %IniFileName%, %IniSection%, EnemiesDeck
IniWrite, %EnemySiege%, %IniFileName%, %IniSection%, EnemySiege
IniWrite, %VIP%, %IniFileName%, %IniSection%, VIP
IniWrite, %Effect%, %IniFileName%, %IniSection%, Effect
IniWrite, %Mode%, %IniFileName%, %IniSection%, Mode
IniWrite, %Order%, %IniFileName%, %IniSection%, Order
IniWrite, %Operation%, %IniFileName%, %IniSection%, Operation
IniWrite, %Iterations%, %IniFileName%, %IniSection%, Iterations
IniWrite, %Threads%, %IniFileName%, %IniSection%, Threads
IniWrite, %SimOptions%, %IniFileName%, %IniSection%, SimOptions

IniWrite, %CustomDeckFile%, %IniFileName%, %IniSection%, CustomDeckFile

IniWrite, %Log%, %IniFileName%, %IniSection%, Log

while true
{
  IfWinExist, TUOptimizeOutput
      WinClose ; use the window found above
  else
      break
}
ExitApp
