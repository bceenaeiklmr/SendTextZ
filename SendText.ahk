; Script     SendText.ahk
; License:   MIT License
; Author:    Bence Markiel (bceenaeiklmr)
; Github:    https://github.com/bceenaeiklmr/SendText
; Date       21.01.2023
; Version    0.1

#Requires AutoHotkey >=2.0
#Warn
#SingleInstance

; ############################################

Main := Menu()
Sys  := Menu()

Main.Add("System", sys)
Sys.Add("My computer",  (*) => Run("::{20D04FE0-3AEA-1069-A2D8-08002B30309D}"))
Sys.Add("Recycle bin",  (*) => Run("::{645FF040-5081-101B-9F08-00AA002F954E}"))
Sys.Add("Downloads",    (*) => Run("C:\users\" A_userName "\Downloads"))
Sys.Add("My documents", (*) => Run(A_MyDocuments))
Sys.Add("My desktop",   (*) => Run(A_desktop))

Text := sendText(":")
Main.Add("Texts", Text)

previewIcon := 0
if previewIcon {
    pIcon := PreviewIcons()
    Main.Add("Icons", pIcon)
}

; set icons
Main.SetIcon("Texts",       "Shell32.dll", 75)
Main.SetIcon("System",      "Shell32.dll", 16)
Sys.SetIcon("My computer",  "Shell32.dll", 16)
Sys.SetIcon("Recycle bin",  "Shell32.dll", 32)
Sys.SetIcon("My documents", "Shell32.dll", 39)
Sys.SetIcon("Downloads",    "Shell32.dll", 46)
Sys.SetIcon("My desktop",   "Shell32.dll",  5)

; ############################################

#c::showMain(1)      ; windows + c, instantly
MButton::showMain(0) ; middle mouse button after 500 ms

; ############################################

sendText(TriggerHotkey := ":") {

    ; Unfortunately, IniRead doesn't support UTF-16 which is neccessary to use emojis
    Input := FileRead(A_ScriptDir "\hotstring.ini")
    ; temporaly replace OR
    InputFile := StrReplace(Input, "||", "Ͻ")
    Sect := Array()
    loop Parse, InputFile, "`n" {
        ; skip empty and comment lines
        if (A_LoopField ~= "^;") || (3 > StrLen(A_LoopField))
            continue
        Line := StrReplace(A_LoopField, Chr(13))
        ; category names
        if RegExMatch(Line, "^\[\w+(\s\w+)*\]", &Lines) {    ; regex
            Name := Trim(SubStr(Lines[], 2, -1))
            Sect.Push({ Name: Name, Hotkeys: [] })
        }
        else { ; hotkeys
            ; columns are separated by the pipe '|' chr
            Col := StrSplit(Line, "|")
            for v in Col {
                Col[A_index] := Trim(v)
                ; make `n chars visible in menus
                if (A_index = 4)
                    Col[A_index] := StrReplace(v, "``n", "`n")
                if InStr(v, "Ͻ")
                    Col[A_index] := StrReplace(v, "Ͻ", "||")
            }

            obj := { Preview : Col[1]
                   , Hotstrg : Col[2]
                   , Text    : Col[3]
                   , Code    : (4 > Col.length) ? "" : Col[4] }

            Sect[Sect.Length].Hotkeys.Push(obj)
        }
    }

    ; create menus
    Texts := Menu()
    for v in Sect {
        SectMenu := Menu()
        for hk in v.Hotkeys {
            Sectmenu.Add(hk.Preview "`t" hk.Text, SendStr.Bind(hk.text))
            if (hk.Code !== "") {
                hk.Text := Trim(hk.Code)
            }
            ; register hotstrings
            hStrings := StrSplit(hk.HotStrg, ",")
            for hStr in hStrings {
                HotString(":*:" TriggerHotkey Trim(hStr), SendStr.Bind(hk.text))
            }
            
        }
        texts.Add(v.Name, sectmenu)
    }

    return texts
    
}

PreviewIcons() {
    local i
    IconMenu := Menu()
    loop 10 {
        i := A_index
        submenu := Menu()
        IconMenu.Add(A_index, submenu)
        loop 32 {
            ii := A_index + 32*(i-1)
            submenu.Add(ii, (*) => "")
            submenu.SetIcon(ii, "Shell32.dll", A_index + 32*(i-1))
        }
    }
    return IconMenu
}

SendStr(Strg, *) {
    if (SubStr(Strg, 1, 1) == "*")
        return Send(SubStr(Strg, 2))
    ClipSaved := ClipboardAll()
    A_Clipboard := ""
    Sleep 50
    A_Clipboard := Strg
    if ClipWait(.5, 0) {
        Send("{CtrlDown}v{CtrlUp}")
        Sleep 100
    }
    A_Clipboard := ClipSaved
    return
}

showMain(Instant := 1) {
    if Instant
        Main.Show()
    else {
        pressed := 0
        while getKeyState(A_thisHotkey,"P") {
            if (A_TimeSinceThisHotkey > 500) {
                Main.Show()
                pressed := 1
            }
        }
        if !pressed
            send "{" A_thisHotkey "}" ;hotkey
    }
}
