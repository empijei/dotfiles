#q::Send !{F4}
return

>!a::
if GetKeyState("CapsLock", "T") = 1
	send, À
else if GetKeyState("CapsLock", "T") = 0
	send, à
return
>!e::
if GetKeyState("CapsLock", "T") = 1
	send, È
else if GetKeyState("CapsLock", "T") = 0
	send, è
return

>!i::
if GetKeyState("CapsLock", "T") = 1
	send, Ì
else if GetKeyState("CapsLock", "T") = 0
	send, ì
return

>!o::
if GetKeyState("CapsLock", "T") = 1
	send, Ò
else if GetKeyState("CapsLock", "T") = 0
	send, ò
return

>!u::
if GetKeyState("CapsLock", "T") = 1
	send, Ù
else if GetKeyState("CapsLock", "T") = 0
	send, ù
return

>!;::
if GetKeyState("CapsLock", "T") = 1
	send, É
else if GetKeyState("CapsLock", "T") = 0
	send, é
return

>![::Send &
return

>!]::Send *
return
