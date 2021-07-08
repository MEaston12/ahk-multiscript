#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

PhoneCheckLog(){
    targetCSV := "./Refs/PhoneCheckLog.csv"
    formatTime, currentTime, A_Now, d'-'M'-'y '['h:mm:ss'], 1`n'
    FileAppend, %currentTime% , %targetCSV%
}

PhoneCheckDef(){
    Hotkey, !Pause, PhoneCheckLog
    return "Alt-Pause: Resisted urge to look at phone"
}