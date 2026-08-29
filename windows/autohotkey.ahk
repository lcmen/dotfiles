#Requires AutoHotkey v2.0+
#SingleInstance Force
SendMode "Input"

#HotIf WinActive("ahk_exe WindowsTerminal.exe")
^c::Send "^+c"
^v::Send "^+v"
#c::Send "^+c"
#v::Send "^+v"
#HotIf

#a::Send "^a"
#c::Send "^c"
#v::Send "^v"
#x::Send "^x"

#n::Send "^n"
#+n::Send "^+n"
#s::Send "^s"
#o::Send "^o"

#Left::Send "{Home}"
#Right::Send "{End}"
#+Left::Send "+{Home}"
#+Right::Send "+{End}"

#z::Send "^z"
#+z::Send "^+z"

~LWin Up::Return
~RWin Up::Return

!Left::Send "^{Left}"
!Right::Send "^{Right}"
!+Left::Send "^+{Left}"
!+Right::Send "^+{Right}"

#Up::Send "^{Home}"
#Down::Send "^{End}"
#+Up::Send "^+{Home}"
#+Down::Send "^+{End}"

#q::WinClose "A"
#Space::Send "#s"
<#Tab::AltTab
>#Tab::AltTab

#LButton::Send "^{Click}"
