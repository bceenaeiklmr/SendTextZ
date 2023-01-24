# SendText
SendText is an AutoHotkey v2 script that simplifies the management of your hotstrings and text snippets.

The script includes 155 built-in symbols and special characters and allows for the quick and easy addition of new texts and hotstrings.

----

### Table of Contents

- ### [Features](https://github.com/bceenaeiklmr/SendText#features)
- ### [How to use it?](https://github.com/bceenaeiklmr/SendText/edit/main/README.md#how-to-use-it)
- ### [Texts & hostrings in the ini file](https://github.com/bceenaeiklmr/SendText#define-a-new-menu-category)
- ### [Define a New Menu Category](https://github.com/bceenaeiklmr/SendText#define-a-new-menu-category)
- ### [Creating Menu items](https://github.com/bceenaeiklmr/SendText#creating-menu-items)
- ### [Send support](https://github.com/bceenaeiklmr/SendText#send-support)
- ### [Reselect a word](https://github.com/bceenaeiklmr/SendText#reselect-a-word)
- ### [Sending longer texts](https://github.com/bceenaeiklmr/SendText#sending-longer-texts)
- ### [Add to your existing menu](https://github.com/bceenaeiklmr/SendText#add-to-your-existing-menu)
- ### [Why not IniRead?](https://github.com/bceenaeiklmr/SendText#ahk---iniread)

----

## Features

- send texts via win32 menus or using hotstrings
- manages categories, menu items, and hotstrings from one file
- can be integrated easily into your own existing config, menu
- emoji support: 😉
- old school ascii texts: ଘ(੭*ˊᵕˋ)੭* ̀ˋ ɪɴᴛᴇʀɴᴇᴛ!
- long text support
- warn compatible

<img src="https://user-images.githubusercontent.com/105103590/213881464-54c186b6-986d-4b86-ab00-55271ef6860e.png" width="537" height="450">

## How to use it?

Please note ☝ this script `#Requires AutoHotkey >=2.0`.  

1. Download both [SendText.ahk](https://github.com/bceenaeiklmr/SendText/blob/main/SendText.ahk) and [hotstring.ini](https://github.com/bceenaeiklmr/SendText/blob/main/hotstring.ini) into the same folder.
2. Run [SendText.ahk](https://github.com/bceenaeiklmr/SendText/blob/main/SendText.ahk)
3. Hold `Mbutton` down for at least 500 ms or press simultaneously `Win + c` to show the menu.
4. Select an element and the text will be pasted into the last active window.
     
   ⏵ Alternatively, you can call the snippets via [`hotstrings`](https://www.autohotkey.com/docs/v2/Hotstrings.htm).
   
By default, all hotstrings start with the semicolon `:` character. You can alter this value.

## Texts & hotstrings in the ini file:

The scripts contain 100+ built-in texts, special characters, and symbols categorized by 8 main categories.

The following picture represents one category, a set of hotstrings, and item menus.

```ahk
[Emoji faces]

eyes                     | eyes, rolleyes, check        | 👀
smile                    | smile, grin                  | 😁
crying out loud          | cryingoutloud, col           | 😂
smiling eyes             | smilingeyes                  | 😄
open mouth               | openmouth                    | 😃
joy                      | joy, tears                   | 😂
rolling on the floor     | rofl                         | 🤣
laughing hand            | laughing                     | 🤭
embarassed               | embarassed                   | 😊
halo                     | halo, saint                  | 😇
upside down              | upsidedown                   | 🙃
winking                  | wink                         | 😉
relived                  | relived                      | 😌
love eyes                | love                         | 😍
delicous                 | delicious, toungue, yummi    | 😋
sunglasses               | sunglass, cool               | 😎
hearths                  | hearth                       | 🥰
thinking                 | think                        | 🤔
```

Here are a few example of each categories:
- `[Roman Numerals]` I, II, III, IV, ...  
- `[AutoHotkey]` keystrokes with Send()
- `[Brackets]` 〔...〕, ⌜⌝, ...
- `[ASCII texts]` ଘ(੭*ˊᵕˋ)੭* ̀ˋ ɪɴᴛᴇʀɴᴇᴛ!, (҂^.^)ᕤ, ...
- `[ASCII symbols]` ⏵, ⟫, ⊙, €, ∑, ...
- `[Emoji symbols]` ✔, ⛅, ⏰, ...
- `[Emoji faces]` 👀, 😍, ...
- `[Emoji hands]` 🤙, 👍, ...

## Define a New Menu Category

Simply put `[NewCategory]` into the ini file. 

All lines under NewCategory until the next Category will be listed in the NewCategory menu.

*Spaces can be used.*

```ini
[NewCategory]
...
texts
...
[NextCategory]
```

*Closing the category tag is not necessary. `Omitting NextCategory` will set Newcategory to the last category.*

## Creating Menu items

Menu items can be created using the following format.

By default, the delimiter is the pipe `|` character.

`displayed text | menu item title | hotstring | ahk code`

For example: `perfect | ok, perfect | 👌` will create a menu item.

The displayed text in the menu will be `perfect A_Tab 👌`.

The third column indicates there are two hotstrings for this text. (separate the hotstring with a colon `","` or `", "` )

Typing either `:ok` or `:perfect` will display `👌`.

## Send support

Sending hotkeys is supported by using the `*` character as the first character in the fourth column.

This way AutoHotkey will send the strings using the built-in `Send` command.

This helps to send not just strings/texts but hotkeys too.

### - example 1 -

`... | ... | ... | *; {# 42}`

will send (display) the following text:

`; ##########################################`

### - example 2 -

Combine multiple hotkeys this way, e.g

Please note, the default keystrokes in the ini file are for Visual Studio Code. ☝

`... | ... | ... | *(x = y) ? 1 : 0{Home}{Right}{ShiftDown}{Right 5}{ShiftUp}`

Will display

`(x = y) ? 1 : 0` and the selected string will texts `x = y`.

### - example 3 -

Typing `:for` will send the following string with AHK `Send()` function:

`"for k, v in obj {{}{Enter}{Left 2}{Tab}{Up}{End}{Left 2}{ShiftDown}{Left 3}{ShiftUp}"`

and will send

```ahk
for k, v in obj {
    
}
```

And the `obj` phrase will be selected automatically.

### - example 4 -

Typing `:if` will send:

`"if (condition) {{}{Enter}{Down}{End}{Space}else{Space}{{}{Enter 2}{}}"` `"."`

`"{Up 4}{Home}{Right 4}{CtrlDown}{ShiftDown}{Right}{CtrlUp}{ShiftUp}"`

And will create a standard if-else block:

```ahk
if (condition) {

else {

}
```
And reselect the `condition` word.

## Reselect a word

You can use standard hotkeys like reselection.

Using `{CtrlDown}{ShiftDown}{Left}{CtrlUp}{ShiftUp}` or `{CtrlDown}{ShiftDown}{Left}{CtrlUp}{ShiftUp}`

will reselect a word.

## Sending longer texts

In the fourth column copy the text you want. (without `*` as the first chr)

`... | ... | ... | ImagineThisIsAVeryLongText`

This way the fourth element content will be copied to the clipboard and will be sent by using the clipboard.

After a successful paste the previous (saved) clipboard content will be restored.

## Add to your existing menu

Copy the `SendText()` function to your script.

Call `Texts := SendText()`

Add to your menu with: `YourMenuName.Add("Texts", Texts)`

## AHK - IniRead

Unfortunately, AutoHotkey v2 IniRead function does not support UTF-16 (Emoji characters), on the other hand, FileRead works.
