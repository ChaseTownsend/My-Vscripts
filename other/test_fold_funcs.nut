::FOLD_FUNCS <- {
    function Cleanup()
    {
        delete ::FOLD_FUNCS
    }
    function OnGameEvent_recalculate_holidays(_) {Cleanup()}

    __CTFPlayer_CTFBot__SayHi = function()
    {
        ClientPrint(this, 3, "test")
    }
}

foreach (item, value in FOLD_FUNCS)
{
    printl(item + " : " + value)
    // ROOT[func] <- func.bindenv(this)
}