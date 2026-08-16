#Requires AutoHotkey v2.0+
#SingleInstance Force
SendMode "Input"

; Center newly created windows
DllCall("RegisterShellHookWindow", "Ptr", A_ScriptHwnd)
OnMessage(DllCall("RegisterWindowMessage", "Str", "ShellHook"), ShellMessage)

ShellMessage(wParam, lParam, *) {
    static HSHELL_WINDOWCREATED := 1
    static WS_MAXIMIZE := 0x01000000
    static WS_MINIMIZE := 0x20000000

    if wParam != HSHELL_WINDOWCREATED
        return

    Sleep 50 ; Let the window render at its intended dimensions.

    try {
        window := "ahk_id " lParam
        if !WinExist(window)
            return

        ; Resize window before centering
        style := WinGetStyle(window)
        if (style & WS_MAXIMIZE) || (style & WS_MINIMIZE)
            return

        CenterWindow(lParam)
    }
}

GetWindowWorkArea(hwnd, &left, &top, &right, &bottom) {
    static MONITOR_DEFAULTTONEAREST := 2

    monitor := DllCall(
        "MonitorFromWindow",
        "Ptr", hwnd,
        "UInt", MONITOR_DEFAULTTONEAREST,
        "Ptr"
    )
    monitorInfo := Buffer(40, 0)
    NumPut("UInt", monitorInfo.Size, monitorInfo)

    if !DllCall("GetMonitorInfo", "Ptr", monitor, "Ptr", monitorInfo)
        throw OSError()

    left := NumGet(monitorInfo, 20, "Int")
    top := NumGet(monitorInfo, 24, "Int")
    right := NumGet(monitorInfo, 28, "Int")
    bottom := NumGet(monitorInfo, 32, "Int")
}

CenterWindow(hwnd := 0) {
    static MAX_HEIGHT_RATIO := 0.90
    static FULL_HEIGHT_THRESHOLD := 0.98

    if !hwnd
        hwnd := WinExist("A")
    if !hwnd
        return

    window := "ahk_id " hwnd
    if WinGetMinMax(window) != 0 {
        WinRestore window
        Sleep 50
    }

    WinGetPos &x, &y, &width, &height, window
    GetWindowWorkArea(hwnd, &left, &top, &right, &bottom)

    workWidth := right - left
    workHeight := bottom - top
    if height >= workHeight * FULL_HEIGHT_THRESHOLD
        height := Round(workHeight * MAX_HEIGHT_RATIO)

    targetX := Round(left + (workWidth - width) / 2)
    targetY := Round(top + (workHeight - height) / 2)
    WinMove targetX, targetY, width, height, window
}

; Windows Terminal uses Ctrl+Shift+C/V for copy and paste.
#HotIf WinActive("ahk_exe WindowsTerminal.exe")
^c::Send "^+c"
^v::Send "^+v"
#c::Send "^+c"
#v::Send "^+v"
#HotIf

; Copy, paste, and cut
#a::Send "^a"
#c::Send "^c"
#v::Send "^v"
#x::Send "^x"

; New, new window, save, and open
#n::Send "^n"
#+n::Send "^+n"
#s::Send "^s"
#o::Send "^o"

; Beginning/end of a line and top/bottom of a document
#Left::Send "{Home}"
#Right::Send "{End}"
#Up::Send "^{Home}"
#Down::Send "^{End}"

; Snap left/right
#+Left::Send "{Blind}{Shift up}{Left}"
#+Right::Send "{Blind}{Shift up}{Right}"

; Center the active window
#+Space::CenterWindow()

; Undo and redo
#z::Send "^z"
#+z::Send "^+z"

; Snap layouts
#+\::{
    Send "{Blind}{Shift up}z"
    KeyWait "\", "P"
}

; Prevent releasing the Windows key from opening the Start menu.
~LWin Up::Return
~RWin Up::Return

; Move or select by word
!Left::Send "^{Left}"
!Right::Send "^{Right}"
!+Left::Send "^+{Left}"
!+Right::Send "^+{Right}"

; Search, window management and force quit
#q::WinClose "A"
#Space::Send "#s"
<#Tab::AltTab
>#Tab::AltTab

; Multi-select and open links in new tabs
#LButton::Send "^{Click}"

; Switch directly to virtual desktops 1-10 using VirtualDesktopAccessor.dll.
#1::SwitchToDesktop(1)
#2::SwitchToDesktop(2)
#3::SwitchToDesktop(3)
#4::SwitchToDesktop(4)
#5::SwitchToDesktop(5)
#6::SwitchToDesktop(6)
#7::SwitchToDesktop(7)
#8::SwitchToDesktop(8)
#9::SwitchToDesktop(9)
#0::SwitchToDesktop(10)

SwitchToDesktop(desktopNumber) {
    result := DllCall(
        A_ScriptDir "\VirtualDesktopAccessor.dll\GoToDesktopNumber",
        "Int", desktopNumber - 1,
        "Int"
    )

    if result = -1
        throw Error("Failed to switch to virtual desktop " desktopNumber ".")
}
