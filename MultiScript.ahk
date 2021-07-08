#SingleInstance, Force
#KeyHistory, 0
#Persistent
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn ; Recommended for catching common errors.
#MaxThreadsPerHotkey, 1 ; no re-entrant hotkey handling
SetBatchLines, -1
ListLines, Off
SendMode Input ; Forces Send and SendRaw to use SendInput buffering for speed.
SetTitleMatchMode, 2
SetTitleMatchMode, Fast		;Fast is default
DetectHiddenWindows, off	;Off is default
SetWorkingDir, %A_ScriptDir%
SplitPath, A_ScriptName, , , , thisscriptname

#Include .\Modules
#Include AdvancedWindowSnap.ahk
#Include ClipAppend.ahk
#Include FixMouse.ahk
#Include WindowLocationSaver.ahk

global TrayString := "" ;Init tray string, append onto this.
TrayString .= ClipAppendDef()
TrayString .= FixMouseDef()
TrayString .= WindowLocationSaverDef()
TrayString .= AdvancedWindowSnapDef()

Menu, Tray, Tip, Right click and select show hotkeys to see hotkeys.
Menu, Tray, Add
Menu, Tray, Add, Show Hotkeys, showHotkeys

showHotkeys(){
    ;TrayTip, Active Hotkeys, %TrayString%
    MsgBox, %TrayString%
}