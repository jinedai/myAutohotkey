last := 0
viewStatus := 0
a::
    ifNotEqual viewStatus, 1
    {
        last := viewStatus
        viewStatus := 1
        sendInput {F1}
    }
    return
s::
d::
    ifNotEqual viewStatus, 2
    {
        if (viewStatus = 1) and (last = 2)
        {
            sendInput {Esc}
        }
        else
        {
            sendInput {F2}
        }
        last := viewStatus
        viewStatus := 2
    }
    return
f::
    ifNotEqual viewStatus, 3
    {
        if (viewStatus = 1) and (last = 3)
        {
            sendInput {Esc}
        }
        else
        {
            sendInput {F3}
        }
        last := viewStatus
        viewStatus := 3
        ;FileAppend F3`n, log.txt
    }
    return

#UseHook, On
g::
    MouseGetPos xPos, yPos
    MouseMove 200, 60
    sendInput {LButton}
    MouseMove %xPos%, %yPos%
    return
z::
    MouseGetPos xPos, yPos
    MouseMove 200, 150
    sendInput {LButton}
    MouseMove %xPos%, %yPos%
    return
x::
    MouseGetPos xPos, yPos
    MouseMove 200, 240
    sendInput {LButton}
    MouseMove %xPos%, %yPos%
    return
c::
    MouseGetPos xPos, yPos
    MouseMove 200, 330
    sendInput {LButton}
    MouseMove %xPos%, %yPos%
    return
v::
    MouseGetPos xPos, yPos
    MouseMove 200, 420
    sendInput {LButton}
    MouseMove %xPos%, %yPos%
    return
b::
    MouseGetPos xPos, yPos
    MouseMove 200, 510
    sendInput {LButton}
    MouseMove %xPos%, %yPos%
    return
t::
    MouseGetPos xPos, yPos
    MouseMove 240, 60
    sendInput {LButton}
    MouseMove %xPos%, %yPos%
    return
r::sendInput {b}
