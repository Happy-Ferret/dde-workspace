FREEDESKKTOP_LOGIN1 =
    name:"org.freedesktop.login1",
    path:"/org/freedesktop/login1",
    interface:"org.freedesktop.login1.Manager",
dbus_login1 = null
try
    dbus_login1 = DCore.DBus.sys_object(
        FREEDESKKTOP_LOGIN1.name,
        FREEDESKKTOP_LOGIN1.path,
        FREEDESKKTOP_LOGIN1.interface
    )
catch e
    echo "dbus_login1 error:#{e}"

power_request = (power) ->
    if not dbus_login1? then return
    document.body.style.cursor = "wait" if power isnt "suspend" and power isnt "lock"
    echo "Warning: The system will request ----#{power}----"
    switch power
        when "suspend" then dbus_login1.Suspend(true)
        when "restart" then dbus_login1.Reboot(true)
        when "shutdown" then dbus_login1.PowerOff(true)
        else return

power_get_inhibit = (power) ->
    result = null
    if not dbus_login1? then return result
    
    inhibitorsList = dbus_login1.ListInhibitors_sync()
    echo "inhibitorsList.lengt:" + inhibitorsList.length
    echo inhibitorsList
    cannot_excute = []
    for inhibit,i in inhibitorsList
        if inhibit is undefined then break
        echo inhibit
        try
            if inhibit[3] is "block"
                type = inhibit[0]
                switch type
                    when "shutdown" then cannot_excute.push({type:"shutdown",inhibit:inhibit})
                    when "idle"  then cannot_excute.push({type:"suspend",inhibit:inhibit})
                    when "handle-suspend-key"  then cannot_excute.push({type:"suspend",inhibit:inhibit})
                    when "handle-power-key"
                        cannot_excute.push({type:"restart",inhibit:inhibit})
                        cannot_excute.push({type:"shutdown",inhibit:inhibit})
                        cannot_excute.push({type:"logout",inhibit:inhibit})
        catch e
            echo "#{e}"


    if cannot_excute.length == 0 then return result
    for tmp in cannot_excute
        if power is tmp.type then result = tmp.inhibit
    echo "power_get_inhibit(#{power}) result:#{result}"
    return result

power_can = (power)->
    inhibit = power_get_inhibit(power)
    if inhibit is null
        echo "power_can:#{power} true"
        return true
    else
        echo "power_can:#{power} false"
        return false


power_can_freedesktop = (power) ->
    if not dbus_login1? then return
    result = true
    switch power
        when "suspend" then result = dbus_login1.CanSuspend_sync()
        when "restart" then result = dbus_login1.CanReboot_sync()
        when "shutdown" then result = dbus_login1.CanPowerOff_sync()
        else result = false
    echo "power_can : -----------Can_#{power} :#{result}------------"
    if result is undefined then result = true
    return result

power_force = (power) ->
    if not dbus_login1? then return
    document.body.style.cursor = "wait" if power isnt "suspend" and power isnt "lock"
    echo "Warning: The system will request ----#{power}----"
    switch power
        when "suspend" then dbus_login1.Suspend(false)
        when "restart" then dbus_login1.Reboot(false)
        when "shutdown" then dbus_login1.PowerOff(false)
        else return