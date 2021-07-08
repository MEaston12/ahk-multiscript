ClipAppendHit(){
  OldClipboard =%Clipboard%
  Clipboard =
  Sleep 100
  Send ^c
  ClipWait
  Clipboard =%OldClipBoard%%Clipboard%
}

ClipAppendDef(){
  Hotkey, !c, ClipAppendHit
  return "Alt-C: Append copy`n"
}