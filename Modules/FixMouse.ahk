
FixMouseHit(){
    Process, Close,LCore.exe
    Run, C:\Program Files\Logitech Gaming Software\LCore.exe
}

FixMouseDef(){
    Hotkey, ^!F12, FixMouseHit
    Return "Ctrl-Alt-F12: Restart Logitech Gaming`n"
}