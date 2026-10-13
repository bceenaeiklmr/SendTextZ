; Script     SendTextZ.ahk
; License:   MIT License
; Author:    Bence Markiel (bceenaeiklmr)
; Github:    https://github.com/bceenaeiklmr/SendTextZ
; Date       13.10.2026
; Version    0.4.0

SendTextZ

SendTextZ(triggerHotkey := ":") {

    ; Main menu.
    texts := Menu()

    ; Read INI file (relative to this script's directory for standalone compatibility).
    SplitPath(A_LineFile,, &dir)
    fileName := dir "\hotstring.ini"
    if (!FileExist(fileName))
        return

    sections := IniRead(fileName)

    ; Read sections and create section menus.
    for section in StrSplit(sections, "`n") {
        section := Trim(section)
        if (!section)
            continue

        sectMenu := Menu()
       
        ; Read keys from section.
        keys := IniRead(fileName, section)
        for line in StrSplit(keys, "`n") {
            line := Trim(line)
            if (!line || SubStr(line, 1, 1) == ";")
                continue

            key := line
            ; Temporarily replace OR with a different character.
            if InStr(key, "||")
                key := StrReplace(key, "||", "Ͻ")
            
            parts := StrSplit(key, "|")
            if (parts.Length < 3)
                continue

            for v in parts
                parts[A_Index] := Trim(v)
            
            ; Make `n chars visible in menus.
            if (parts.Length >= 4 && InStr(parts[4], "``n")) 
                parts[4] := StrReplace(parts[4], "``n", "`n")
            
            ; Replace temporary character.
            if InStr(parts[3], "Ͻ")
                parts[3] := StrReplace(parts[3], "Ͻ", "||")

            pre := parts[1]
            txt := parts[3]
            str := (parts.Length < 4) ? parts[3] : parts[4]

            sectMenu.Add(pre "`t" txt, SendStr.Bind(str))

            ; Create hotstring.
            for hotStr in StrSplit(parts[2], ",") {
                cleanHotStr := Trim(hotStr)
                if (cleanHotStr != "")
                    HotString(":*:" triggerHotkey cleanHotStr, SendStr.Bind(str))
            }
        }

        texts.Add(section, sectMenu)
    }

    if IsSet(W32menu) && HasProp(W32menu, "main") {
        W32menu.main.Add("Texts", texts)
        W32menu.main.SetIcon("Texts", "Shell32.dll", 75)
    } else {
        mainMenu := Menu()
        mainMenu.Add("Texts", texts)
        mainMenu.SetIcon("Texts", "Shell32.dll", 75)
        Hotkey("#c", (*) => mainMenu.Show())
    }
    return texts
}

SendStr(str, *) {
    if (SubStr(str, 1, 1) == "*") {
        return Send(SubStr(str, 2))
    }
    SendText(str)
    return
}
