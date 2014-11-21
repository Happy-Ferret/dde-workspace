class Clock
    @Type: {Digit:0, Analog:1, Tray:2}
    constructor:(@setting)->

    show:->
        if @time.style.display == 'none'
            @time.style.display = ''

    hide:->
        if @time.style.display != 'none'
            @time.style.display = 'none'

    @openDateAndTimeSettingModle:->
        try
            sysSettings = get_dbus('session', "com.deepin.dde.ControlCenter", "ShowModule")
        catch e
            console.log e
            sysSettings = null
        sysSettings?.ShowModule("date_time")