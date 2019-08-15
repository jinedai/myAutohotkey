a::
    ifNotEqual viewStatus, 1
    {
        viewStatus := 1
        sendInput {F1}
        ;FileAppend F1`n, log.txt
    }
    return
s::
    toolTip 14  45
    ifNotEqual viewStatus, 2
    {
        viewStatus := 2
        sendInput {F2}
    }
    return
d::
    toolTip 14  45
    ifNotEqual viewStatus, 2
    {
        ifEqual viewStatus, 1
            sendInput {Esc}
        viewStatus := 2
        sendInput {F2}
    }
    return
f::
    ifNotEqual viewStatus, 3
    {
        ifEqual viewStatus, 1
            sendInput {Esc}
        viewStatus := 3
        sendInput {F3}
        ;FileAppend F3`n, log.txt
    }
    return
