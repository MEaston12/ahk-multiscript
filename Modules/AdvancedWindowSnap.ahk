/**
 * SnapActiveWindow resizes and moves (snaps) the active window to a given position.
 * @param {string} winPlaceVertical   The vertical placement of the active window.
 *                                    Expecting "bottom" or "middle", otherwise assumes
 *                                    "top" placement.
 * @param {string} winPlaceHorizontal The horizontal placement of the active window.
 *                                    Expecting "left" or "right", otherwise assumes
 *                                    window should span the "full" width of the monitor.
 * @param {string} winSizeHeight      The height of the active window in relation to
 *                                    the active monitor's height. Expecting "half" size,
 *                                    otherwise will resize window to a "third".
 */
#Include WinGetPosEx.ahk

global debugMode := false

writeActiveWinToLog(){
    WinGet activeWin, ID, A
    WinGetTitle, aTitle, A
    WinGetPosEx(activeWin,X, Y, Width, Height)
    FileAppend, Title: %aTitle% | X: %X% | Y: %Y% | Width: %Width% | Height: %Height%`n, .\Refs\WinLog.txt
}

AdvancedWindowSnapDef(){
    ; Directional Arrow Hotkeys
    Hotkey, #!Up, SnapTopFullHalf
    Hotkey, #!Down, SnapBottomFullHalf
    Hotkey, #!Numpad7, SnapTopLeftHalf
    Hotkey, #!Numpad8, SnapTopFullHalf
    Hotkey, #!Numpad9, SnapTopRightHalf
    Hotkey, #!Numpad1, SnapBottomLeftHalf
    Hotkey, #!Numpad2, SnapBottomFullHalf
    Hotkey, #!Numpad3, SnapBottomRightHalf
    Hotkey, ^#!Up, SnapTopFullThird
    Hotkey, ^#!Down, SnapBottomFullThird
    Hotkey, ^#!Numpad8, SnapTopFullThird
    Hotkey, ^#!Numpad5, SnapMiddleFullThird
    Hotkey, ^#!Numpad2, SnapBottomFullThird

    Return "SnapWindow:`n Win-Alt-Up/Down Top/Bottom Half`n Ctrl-Win-Alt-Up/Down Top/Bottom Third`n Ctrl-Win-Alt Num 8/5/2 Top/Middle/Bottom Third`n Win-Alt Num 7/8/9/1/2/3 Top/Bottom Left/Full/Right`n"
}

SnapTopFullHalf(){
    SnapActiveWindow("top","full","half")
}
SnapBottomFullHalf(){
    SnapActiveWindow("bottom","full","half")
}
SnapTopFullThird(){
    SnapActiveWindow("top","full","third")
}
SnapMiddleFullThird(){
    SnapActiveWindow("middle","full","third")
}
SnapBottomFullThird(){
    SnapActiveWindow("bottom","full","third")
}
SnapTopLeftHalf(){
    SnapActiveWindow("top","left","half")
}
SnapTopRightHalf(){
    SnapActiveWindow("top","right","half")
}
SnapBottomLeftHalf(){
    SnapActiveWindow("bottom","left","half")
}
SnapBottomRightHalf(){
    SnapActiveWindow("bottom","right","half")
}

SnapActiveWindow(winPlaceVertical, winPlaceHorizontal, winSizeHeight) {
    WinGet activeWin, ID, A
    activeMon := GetMonitorIndexFromWindow(activeWin)

    SysGet, MonitorWorkArea, MonitorWorkArea, %activeMon%
    

    if (winSizeHeight == "half") {
        height := (MonitorWorkAreaBottom - MonitorWorkAreaTop)//2
    } else {
        height := (MonitorWorkAreaBottom - MonitorWorkAreaTop)//3
    }

    if (winPlaceHorizontal == "left") {
        posX  := MonitorWorkAreaLeft
        width := (MonitorWorkAreaRight - MonitorWorkAreaLeft)//2
    } else if (winPlaceHorizontal == "right") {
        posX  := MonitorWorkAreaLeft + (MonitorWorkAreaRight - MonitorWorkAreaLeft)//2
        width := (MonitorWorkAreaRight - MonitorWorkAreaLeft)//2
    } else {
        posX  := MonitorWorkAreaLeft
        width := MonitorWorkAreaRight - MonitorWorkAreaLeft
    }

    if (winPlaceVertical == "bottom") {
        posY := MonitorWorkAreaBottom - height
    } else if (winPlaceVertical == "middle") {
        posY := MonitorWorkAreaTop + height
    } else {
        posY := MonitorWorkAreaTop
    }

    if (MonitorWorkAreaBottom - MonitorWorkAreaTop > MonitorWorkAreaRight - MonitorWorkAreaLeft) { ;If this is a portrait monitor
        ;MsgBox, Top: %MonitorWorkAreaTop%`nBottom: %MonitorWorkAreaBottom%`nLeft: %MonitorWorkAreaLeft%`nRight: %MonitorWorkAreaRight%
    }

    WinGet, activeStyle, Style, A
    WinGet activeExStyle, ExStyle, A
    ;MsgBox, %activeStyle%, %activeExStyle%
    ;MsgBox, posX: %posX%, posY: %posY%, width: %width%, height: %height%

    WinMove,A,,%posX%,%posY%,%width%,%height%

    WinGetPosEx(activeWin,,,,,OffsetX,OffsetY) ;Check to see if window is borked
    if(OffsetX != 0 || OffsetY != 0){
        WinMove,A,,(posX+OffsetX),%posY%,(width-2*OffsetX), (height-2*OffsetY+1) ;Fixing borked window
        if(debugMode) {
            writeActiveWinToLog()
        }
    }
}

/**
 * GetMonitorIndexFromWindow retrieves the HWND (unique ID) of a given window.
 * @param {Uint} windowHandle
 * @author shinywong
 * @link http://www.autohotkey.com/board/topic/69464-how-to-determine-a-window-is-in-which-monitor/?p=440355
 */
GetMonitorIndexFromWindow(windowHandle) {
    ; Starts with 1.
    monitorIndex := 1

    VarSetCapacity(monitorInfo, 40)
    NumPut(40, monitorInfo)

    if (monitorHandle := DllCall("MonitorFromWindow", "uint", windowHandle, "uint", 0x2))
        && DllCall("GetMonitorInfo", "uint", monitorHandle, "uint", &monitorInfo) {
        monitorLeft   := NumGet(monitorInfo,  4, "Int")
        monitorTop    := NumGet(monitorInfo,  8, "Int")
        monitorRight  := NumGet(monitorInfo, 12, "Int")
        monitorBottom := NumGet(monitorInfo, 16, "Int")
        workLeft      := NumGet(monitorInfo, 20, "Int")
        workTop       := NumGet(monitorInfo, 24, "Int")
        workRight     := NumGet(monitorInfo, 28, "Int")
        workBottom    := NumGet(monitorInfo, 32, "Int")
        isPrimary     := NumGet(monitorInfo, 36, "Int") & 1

        SysGet, monitorCount, MonitorCount

        Loop, %monitorCount% {
            SysGet, tempMon, Monitor, %A_Index%

            ; Compare location to determine the monitor index.
            if ((monitorLeft = tempMonLeft) and (monitorTop = tempMonTop)
                and (monitorRight = tempMonRight) and (monitorBottom = tempMonBottom)) {
                monitorIndex := A_Index
                break
            }
        }
    }

    return %monitorIndex%
}