class LauncherItem extends PrefixedItem
    constructor: (@id, icon, @title)->
        super
        @element.classList.add("Activator")
        @set_tooltip(title)
        DCore.signal_connect("launcher_running", =>
            @show(true)
        )
        DCore.signal_connect("launcher_destroy", =>
            @show(false)
        )

    on_mouseover:(e)=>
        super
        @set_tooltip(@title)

    on_mouseup: (e)=>
        super
        if e.button != 0
            return
        DCore.Dock.toggle_launcher(!@__show)

    on_rightclick:(e)=>
        e.stopPropagation()
        e.preventDefault()
        _isRightclicked = false
