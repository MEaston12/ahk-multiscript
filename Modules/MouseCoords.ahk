; While CapsLock is toggled On
; Script will display Mouse Position (coordinates) as a tooltip at Top-Left corner of screen.
; Also allows to copy them (to clipboard) with a PrintScreen button.

settimer start1, 0 ; "0" to make it update position instantly
return

start1:
if !GetKeyState("capslock","T") ; whether capslock is on or off
{
    tooltip ; if off, don't show tooltip at all.
}
else
{ ; if on
    CoordMode, ToolTip, Window ; makes tooltip to appear at position, relative to screen.
    CoordMode, Mouse, Window ; makes mouse coordinates to be relative to screen.
    CoordMode, Pixel, Window
    MouseGetPos xx, yy ; get mouse x and y position, store as %xx% and %yy%
    PixelGetColor, color, %xx%, %yy%
    tooltip %xx% %yy% %color%, 0, 0 ; display tooltip of %xx% %yy% at coordinates x0 y0.
    PrintScreen:: ; assign new function to PrintScreen. If pressed...
    clipboard == %xx% %yy% ; ...store %xx% %yy% to clipboard.
    return
}
return
