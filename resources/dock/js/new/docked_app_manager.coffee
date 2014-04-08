dockedAppManager = get_dbus("session", name:"com.deepin.daemon.Dock", path:"/dde/dock/DockedAppManager", interface:"dde.dock.DockedAppManager")

dockedAppManager?.connect("Docked", (id)->
    console.log("Docked #{id}")
    items = []
    app_list = $("#app_list")
    for i in [0...app_list.children.length]
        child = app_list.children[i]
        items.push(child.id)

    if not $DBus[id]
        # append to the last.
        # dock-apps-builder will listen Docked signal, and emit Added signal if
        # necessary.
        items.push(id)
    console.log("docked items: #{items}")
    dockedAppManager.Sort(items)
)
dockedAppManager?.connect("Undocked", (id)->
    console.log("Undocked #{id}")
    $("#app_list").removeChild($("##{id}"))
    calc_app_item_size()
)

initDockedAppPosition = ->
    if !dockedAppManager
        return
    dockedPosition = dockedAppManager.DockedAppList_sync()
    list = $("#app_list")
    for i in [dockedPosition.length-1..0]
        target = $("##{dockedPosition[i]}")
        if target
            list.insertBefore(target, list.firstElementChild)

