dbus = null
activeWindowTimer = null
normal_mouseout_id = null
closePreviewWindowTimer = null
_lastCliengGroup = null
pop_id = null
hide_id = null

_clear_item_timeout = ->
    clearTimeout(normal_mouseout_id)

class Item extends Widget
    constructor:(@id, icon, title, @container)->
        super()
        @imgWarp = create_element(tag:'div', class:"imgWarp", @element)
        @imgContainer = create_element(tag:'div', class:"imgContainer", @imgWarp)
        @img = create_img(src:icon || NOT_FOUND_ICON, class:"AppItemImg", @imgContainer)
        @imgHover = create_img(src:"", class:"AppItemImg", @imgContainer)
        @imgHover.style.display = 'none'
        @imgDark = create_img(src:"", class:"AppItemImg", @imgContainer)
        @imgDark.style.display = 'none'

        @imgWarp.classList.add("ReflectImg")

        @img.onload = =>
            dataUrl = bright_image(@img, 40)
            @imgHover.src = dataUrl
            dataUrl = bright_image(@img, -40)
            @imgDark.src = dataUrl

        @imgWarp.style.pointerEvents = "auto"
        @imgWarp.addEventListener("mouseover", @on_mouseover)
        @imgWarp.addEventListener("mouseover", @on_mousemove)
        @imgWarp.addEventListener("mouseout", @on_mouseout)
        @imgWarp.addEventListener("mousedown", @on_mousedown)
        @imgWarp.addEventListener("mouseup", @on_mouseup)
        @imgWarp.addEventListener("contextmenu", @on_rightclick)
        @imgWarp.addEventListener("dragstart", @on_dragstart)
        @imgWarp.addEventListener("dragenter", @on_dragenter)
        @imgWarp.addEventListener("dragover", @on_dragover)
        @imgWarp.addEventListener("dragleave", @on_dragleave)
        @imgWarp.addEventListener("drop", @on_drop)
        @imgWarp.addEventListener("dragend", @on_dragend)
        @imgWarp.addEventListener("mousewheel", @on_mousewheel)

        calc_app_item_size()
        @tooltip = null
        @element.classList.add("AppItem")
        # if settings.displayMode() == DisplayMode.Classic
        #     @element.style.width = '48px'
        #     @element.style.height = '44px' # + border * 2 == container.clientHeight
        # else
        #     @element.style.width = '48px'
        #     @element.style.height = '54px'

        @imgContainer.draggable=true
        e = document.getElementsByName(@id)
        if e.length != 0
            e = e[0]
            console.log("find insert indicator")
            e.parentNode.insertBefore(@element, e)
            e.parentNode.removeChild(e)
            sortDockedItem()
        else
            @container?.appendChild?(@element)

        update_dock_region($("#container").clientWidth)

    change_icon: (src)->
        @img.src = src
        @img.onload = =>
            @imgHover.src = bright_image(@img, 40)
            @imgDark.src = bright_image(@img, -40)

    set_tooltip: (text) ->
        if @tooltip == null
            # @tooltip = new ToolTip(@element, text)
            @tooltip = new ArrowToolTip(@element, text)
            @tooltip.set_delay_time(200)  # set delay time to the same as scale time
            return
        @tooltip.set_text(text)

    destroy_tooltip:->
        @tooltip?.hide()
        @tooltip?.destroy()
        @tooltip = null

    isNormal:->
        true

    isNormalApplet:->
        false

    isActive:->
        false

    isRuntimeApplet:->
        false

    update_scale:->

    displayIcon:(type="")->
        if type
            type = type[0].toUpperCase() + type.substr(1).toLowerCase()
        @img.style.display = 'none'
        @imgHover.style.display = 'none'
        @imgDark.style.display = 'none'
        this["img#{type}"].style.display = ''

    on_mousemove: (e)=>
        console.log("mouse move event")
        if e
            console.log("record mouse position")
            $mousePosition.x = e.x
            $mousePosition.y = e.y

        resetAllItems()
        # clearRegion()

    on_mouseover:(e)=>
        @on_mousemove(e)

        if _isRightclicked || settings.hideMode() != HideMode.KeepShowing and hideStatusManager.state != HideState.Shown
            console.log("_isRightclicked: #{_isRightclicked}")
            console.log("hide mode is keep-showing: #{settings.hideMode() != HideMode.KeepShowing}")
            console.log("hide state is not Shown: #{hideStatusManager.state != HideState.Shown}")
            $tooltip?.hide()
            return
        console.log("mouseover, require_all_region")
        DCore.Dock.require_all_region()
        @displayIcon('hover')

    on_mouseout:(e)=>
        DCore.Dock.set_is_hovered(false)
        @displayIcon()

    on_mousewheel:(e)=>
        @core?.onMouseWheel(e.x, e.y, e.wheelDeltaY)

    on_rightclick:(e)=>
        _isRightclicked = true
        DCore.Dock.set_is_hovered(false)
        update_dock_region($("#container").clientWidth)
        e.preventDefault()
        e.stopPropagation()
        @tooltip?.hide()

    on_mousedown:(e)=>
        if e.button != 0
            return
        Preview_close_now()
        @tooltip?.hide()
        @displayIcon('dark')

    on_mouseup:(e)=>
        @displayIcon('hover')

    # on_click:(e)=>
    #     e?.preventDefault()
    #     e?.stopPropagation()
    #     Preview_close_now()

    on_dragend:(e)=>
        e.preventDefault()
        console.log(@id + ' dragend')
        clearTimeout(@removeTimer || null)
        update_dock_region()
        _lastHover?.reset()
        @element.style.position = ''
        @element.style.webkitTransform = ''
        console.log(_dragTargetManager)
        _dragTarget = _dragTargetManager.getHandle(@id)
        if not _dragTarget
            console.log("get handle failed")
            return
        console.log("#{@id} dragend back? #{_dragTarget.dragToBack}")
        _dragTarget.reset()
        _dragTarget.removeImg()
        if _dragTarget.dragToBack
            console.log("drag to back")
            _dragTarget.back(e.x, e.y)
        @removeTimer = setTimeout(=>
            _dragTargetManager.remove(@id)
        , 1000)

    on_dragstart: (e)=>
        Preview_close_now()
        _dragTarget = new DragTarget(@)
        clearTimeout(@removeTimer || null)
        clearTimeout(_isDragTimer)
        _dragTargetManager.add(@id, _dragTarget)
        pos = get_page_xy(@element)
        _dragTarget.setOrigin(pos.x, pos.y)
        _lastHover = null
        app_list.setInsertAnchor(@element.nextSibling)
        if el = @element.nextSibling
            el.style.marginLeft = "#{INSERT_INDICATOR_WIDTH}px"
        else if el = @element.previousSibling
            el.style.marginRight = "#{INSERT_INDICATOR_WIDTH}px"

        if el
            if not _isDragging
                updatePanel()
                _isDragging = true
            _lastHover = Widget.look_up(el.getAttribute('id')) || null
        setTimeout(=>
            _b.appendChild(@element)
            @element.style.position = 'absolute'
            @element.style.webkitTransform = "translateY(-#{ITEM_HEIGHT}px)"
            @element.style.display = 'none'
        , 10)
        console.log("dragstart")
        e.stopPropagation()
        Preview_close_now()
        DCore.Dock.require_all_region()
        return if @is_fixed_pos
        if @isNormal()
            @tooltip?.hide()
        dt = e.dataTransfer
        dt.setData(DEEPIN_ITEM_ID, @id)
        console.log("DEEPIN_ITEM_ID: #{@id}")

        # flag for doing swap between items
        dt.setData("text/plain", "swap")
        dt.effectAllowed = "copyMove"
        dt.dropEffect = 'none'

    move:(x, threshold)=>
        if _lastHover and _lastHover.id != @id
            _lastHover.reset()
        _lastHover = @

        @reset()
        if x < threshold
            if t = @element.nextSibling
                t.style.marginLeft = ''
                t.style.marginRight = ''
            @element.style.marginLeft = "#{INSERT_INDICATOR_WIDTH}px"
            @element.style.marginRight = ''
            app_list.setInsertAnchor(@element)
        else
            if t = @element.nextSibling
                t.style.marginLeft = "#{INSERT_INDICATOR_WIDTH}px"
                t.style.marginRight = ''
            else
                @element.style.marginLeft = ''
                @element.style.marginRight = "#{INSERT_INDICATOR_WIDTH}px"
            app_list.setInsertAnchor(t)

        if not _isDragging
            updatePanel()
            _isDragging = true

        _isItemExpanded = true
        setTimeout(->
            console.log("update tray icon")
            systemTray.updateTrayIcon()
        , 100)

    reset:->
        setTimeout(->
            console.log("update tray icon")
            systemTray.updateTrayIcon()
        , 100)
        _isItemExpanded = false
        _isDragTimer = setTimeout(->
            _isDragging = false
        , 500)
        # updatePanel()
        @element.style.marginLeft = ''
        @element.style.marginRight = ''
        if t = @element.nextSibling
            t.style.marginRight = ''
            t.style.marginLeft = ''

    on_dragenter: (e)=>
        console.log("dragenter image #{@id}")
        e.preventDefault()
        e.stopPropagation()
        return if @is_fixed_pos
        # DCore.Dock.require_all_region()
        if dnd_is_deepin_item(e) or dnd_is_desktop(e)
            @move(e.offsetX, @element.clientWidth / 2)
        else
            # TODO
            # activeWindowTimer = setTimeout(=>
            #     if @n_clients.length == 1
            #         clientManager?.ActiveWindow(@n_clients[0])
            #         update_dock_region()
            #     else
            #         @on_mouseover()
            # , 1000)

    on_dragleave: (e)=>
        console.log("dragleave")
        clearTimeout(activeWindowTimer)
        update_dock_region()
        e.preventDefault()
        e.stopPropagation()

    on_dragover:(e)=>
        e.stopPropagation()
        e.preventDefault()
        return if @is_fixed_pos
        if dnd_is_deepin_item(e) or dnd_is_desktop(e)
            @move(e.offsetX, @element.clientWidth / 2)

    on_drop: (e) =>
        _dropped = true
        e.preventDefault()
        e.stopPropagation()
        updatePanel()
        dt = e.dataTransfer
        _lastHover?.reset()
        console.log("do drop, #{@id}")
        console.log("deepin item id: #{dt.getData(DEEPIN_ITEM_ID)}")
        tmp_list = []
        for file in dt.files
            console.log(file)
            path = decodeURI(file.path)
            tmp_list.push(path)
        if tmp_list.length > 0
            fileList = tmp_list.join()
            console.log("drop to open: #{fileList}")
            @core?.onDrop(fileList)
        update_dock_region()


class AppItem extends Item
    is_fixed_pos: false
    constructor:(@id, icon, title, @container)->
        super
        @changeImgTimer = null
        @currentImg = @img

        @core = new EntryProxy($DBus[@id])

        @lastStatus = @core.status()
        @clientgroupInited = @isActive()
        console.log("#{@id} init status: #{@lastStatus}")
        @indicatorWarp = create_element(tag:'div', class:"indicatorWarp", @element)
        @openingIndicator = create_img(src:OPENING_INDICATOR, class:"indicator OpeningIndicator", @indicatorWarp)
        @openingIndicator.addEventListener("webkitAnimationEnd", @on_animationend)
        if settings.displayMode() == DisplayMode.Classic
            @openIndicator = create_img(src:CLASSIC_ACTIVE_IMG, class:"indicator OpenIndicator", @indicatorWarp)
            @hoverIndicator = create_img(src:CLASSIC_ACTIVE_HOVER_IMG, class:"indicator OpenIndicator", @indicatorWarp)
        else
            @openIndicator = create_img(src:OPEN_INDICATOR, class:"indicator OpenIndicator", @indicatorWarp)
            @hoverIndicator = create_img(src:OPEN_INDICATOR, class:"indicator OpenIndicator", @indicatorWarp)

        @tooltip = null

        @hide_open_indicator()
        if @isNormal() || @isNormalApplet()
            console.log("is normal")
            @init_activator()
        else
            console.log("is runtime")
            @init_clientgroup()

        if @isRuntimeApplet()
            console.log("runtime applet: #{@id}")
            @hide_open_indicator()

        @core?.connect("DataChanged", (name, value)=>
            console.log("#{@id}: #{name} is changed to #{value}")

            switch name
                when ITEM_DATA_FIELD.xids
                    if not @clientgroupInited
                        return
                    # [{Xid:0, Title:""}]
                    xids = JSON.parse(value)
                    for info in xids
                        @update_client(info.Xid, info.Title)

                    ids = @n_clients.slice(0)
                    for id in ids
                        needDelete = true
                        for info in xids
                            if id == info.Xid
                                needDelete = false
                                break
                        if needDelete
                            @remove_client(id)

                    return
                when ITEM_DATA_FIELD.status
                    if @lastStatus == value
                        return
                    console.log("old status: #{@lastStatus}, new status #{value}")
                    @lastStatus = value
                    if @isNormal()
                        console.log("is normal")
                        @swap_to_activator()
                    else if @isActive()
                        if @openingIndicator.style.webkitAnimationName == ''
                            console.log("#{@id} is slow or opened somewhere else.")
                            @swap_to_clientgroup()
                when ITEM_DATA_FIELD.icon
                    if value.substring(0, 7) == "file://" || value.substring(0, 10) == "data:image"
                        @change_icon(value)
                    else
                        v = DCore.get_theme_icon(value, 48)
                        @change_icon(v)
                when ITEM_DATA_FIELD.title
                    @set_tooltip(value)
        )

    _show_indicator:(bgColor, borderColor, img, display)->
        if settings.displayMode() == DisplayMode.Classic
            console.log("#{@id} display on Classic mode")
            if activeWindow and activeWindow.itemId and activeWindow.itemId == @id
                console.log("#{@id} is active window")
                @element.style.backgroundColor = ""
                @element.style.borderColor = ""
                if display == 'none'
                    @openIndicator.style.display = 'none'
                    @hoverIndicator.style.display = 'none'
                    @element.style.boxShadow = ''
                    @element.style.borderColor = ''
                else if img == CLASSIC_ACTIVE_IMG
                    @openIndicator.style.display = 'inline'
                    @hoverIndicator.style.display = 'none'
                    @element.style.boxShadow = 'rgba(92, 209, 255, .2) 0 0 2px'
                    @element.style.borderColor = 'rgba(92, 209, 255, .2)'
                else
                    @openIndicator.style.display = 'none'
                    @hoverIndicator.style.display = 'inline'
                    @element.style.boxShadow = 'rgba(92, 209, 255, .5) 0 0 2px'
                    @element.style.borderColor = 'rgba(92, 209, 255, .5)'
            else
                @openIndicator.style.display = 'none'
                @hoverIndicator.style.display = 'none'
                @element.style.boxShadow = ''
                @element.style.backgroundColor = bgColor
                @element.style.borderColor = borderColor
                console.log("#{@id} is not active window, #{@element.style.backgroundColor}, #{@element.style.borderColor}")
        else
            console.log("#{@id} display on modern mode")
            @element.style.borderColor = ''
            @element.style.boxShadow = ''
            @hoverIndicator.style.display = 'none'
            @openIndicator.style.display = display

    hide_open_indicator:->
        console.log("#{@id} hide_open_indicator")
        @_show_indicator("", "", "", "none")

    show_open_indicator:->
        console.log("#{@id} show_open_indicator")
        @_show_indicator( "rgba(255,255,255, .15)", "rgba(255,255,255, .2)", CLASSIC_ACTIVE_IMG, "inline")

    show_hover_indicator:->
        @_show_indicator( "rgba(255,255,255, .3)", "rgba(255,255,255, .35)", CLASSIC_ACTIVE_HOVER_IMG, "inline")

    init_clientgroup:->
        # console.log("init_clientgroup #{@core.id()}")
        @n_clients = []
        @client_infos = {}
        @leader = null

        if not @core or not (xids = JSON.parse(@core.xids()))
            return

        # console.log "#{@id}: #{@core.type()}, #{@core.xids()}"
        for xidInfo in xids
            @n_clients.push(xidInfo.Xid)
            @update_client(xidInfo.Xid, xidInfo.Title)
            # console.log "ClientGroup:: Key: #{xidInfo.Xid}, Valvue:#{xidInfo.Title}"

        if @isApplet()
            for xid in xids
                console.log("map #{xid.Xid}")
                $EW_MAP[xid.Xid] = @
            @embedWindows = new EmbedWindow(xids)
        else
            @show_open_indicator()

        @clientgroupInited = true

    init_activator:->
        # console.log("init_activator #{@core.id()}")
        @hide_open_indicator()
        title = @core.title() || "Unknow"
        @set_tooltip(title)
        @clientgroupInited = false

    swap_to_clientgroup:->
        console.log('swap to clientgroup')
        @openingIndicator.style.display = 'none'
        @openingIndicator.style.webkitAnimationName = ''
        if not @isApplet()
            @show_open_indicator()
        @destroy_tooltip()
        @init_clientgroup()

    swap_to_activator:->
        console.log("swap_to_activator")
        @hide_open_indicator()
        Preview_close_now()
        @init_activator()

    update_client: (id, title)->
        @client_infos[id] =
            "id": id
            "title": title
        @add_client(id)
        @update_scale()

    add_client: (id)->
        if @n_clients.indexOf(id) == -1
            @n_clients.unshift(id)

            if @leader != id
                @leader = id

        @element.style.display = "block"

    remove_client: (id, used_internal=false) ->
        if not used_internal
            delete @client_infos[id]

        @n_clients.remove(id)

        if @n_clients.length == 0
            @destroy()
        else if @leader == id
            @next_leader()

    next_leader: ->
        @n_clients.push(@n_clients.shift())
        @leader = @n_clients[0]

    destroy: ->
        if @isNormal()
            super
            @destroy_tooltip()
            calc_app_item_size()
            update_dock_region($("#container").clientWidth)
        else
            if Preview_container._current_group && @id == Preview_container._current_group.id
                Preview_close_now(@)
            @element.style.display = "block"
            super

        delete $DBus[@id]

    destroyWidthAnimation:->
        @img.classList.remove("ReflectImg")
        @rotate(300)
        setTimeout(=>
            @destroy()
            dockedAppManager.Undock(@id)
        ,300)

    rotate:(time=1000)->
        console.log("rotate")
        apply_animation(@imgWarp, "rotateOut", time)

    isNormal:->
        @core.isNormal?()

    isActive:->
        @core.isActive?()

    isApp:->
        @core.isApp?()

    isApplet:->
        @core.isApplet?()

    isRuntimeApplet:->
        @core?.isRuntimeApplet?()

    isNormalApplet:->
        @core?.isNormalApplet?()

    on_mouseover:(e)=>
        super
        if _isRightclicked || settings.hideMode() != HideMode.KeepShowing and hideStatusManager.state != HideState.Shown
            console.log("hide state is not Shown")
            return
        if @isNormal() || @isNormalApplet()
            console.log("app item is normal")
            clearTimeout(hide_id)
            closePreviewWindowTimer = setTimeout(->
                Preview_close_now(Preview_container._current_group)
            , 200)
        else
            if @isApp()
                @show_hover_indicator()

            if _lastCliengGroup and _lastCliengGroup.id != @id
                _lastCliengGroup.embedWindows?.hide?()

            e?.stopPropagation()
            __clear_timeout()
            clearTimeout(hide_id)
            clearTimeout(tooltip_hide_id)
            _clear_item_timeout()

            _lastCliengGroup = @
            xy = get_page_xy(@element)
            w = @element.clientWidth || 0
            # console.log("mouseover: "+xy.y + ","+xy.x, +"clientWidth"+w)
            console.log("ClientGroup mouseover")
            # DCore.Dock.require_all_region()
            # console.log(@core.type())
            if @core && @isApp()
                console.log("#{@id} App show preview")
                if @n_clients.length != 0
                    console.log("length is not 0")
                    Preview_show(@)
            else if @embedWindows
                @core?.showQuickWindow()
                console.log("Applet show preview")
                try
                    size = @embedWindows.window_size(@embedWindows.xids[0])
                    console.log size
                    console.log("size: #{size.width}x#{size.height}")
                catch e
                    console.log(e)
                Preview_show(@, size, (c)=>
                    ew = @embedWindows
                    # 6 for container's blur
                    extraHeight = PREVIEW_TRIANGLE.height + 6 + PREVIEW_WINDOW_BORDER_WIDTH + PREVIEW_CONTAINER_BORDER_WIDTH + size.height
                    # console.log("Preview_show callback: #{c}")
                    x = xy.x + w/2 - size.width/2
                    y = xy.y - extraHeight
                    # console.log("Move Window to #{x}, #{y}")
                    ew.move(ew.xids[0], x, y)
                    clearTimeout(@showEmWindowTimer || null)

                    if Preview_container.border.classList.contains("moveAnimation")
                        console.log("show window after animation")
                        @showEmWindowTimer = setTimeout(->
                            ew.show()
                        , 400)
                    else
                        console.log("show window immiditely")
                        ew.show()
                )

    on_mouseout:(e)=>
        super
        console.log("mouseout")
        clearTimeout(@showEmWindowTimer)
        if @isNormal()
            if Preview_container.is_showing
                console.log("normal mouseout, preview window is showing")
                __clear_timeout()
                clearTimeout(closePreviewWindowTimer)
                clearTimeout(tooltip_hide_id)
                DCore.Dock.require_all_region()
                normal_mouseout_id = setTimeout(->
                    console.log("showing, update dock region")
                    update_dock_region()
                , 1000)
            else
                console.log("normal mouseout, preview window is NOT showing")
                update_dock_region()
                normal_mouseout_id = setTimeout(->
                    hideStatusManager.updateState()
                , 500)
        else
            if not @isApplet()
                @show_open_indicator()
            __clear_timeout()
            _clear_item_timeout()
            if not Preview_container.is_showing
                console.log "Preview_container is not showing"
                # calc_app_item_size()
                hide_id = setTimeout(=>
                    update_dock_region()
                    hideStatusManager.updateState()
                    # @embedWindows?.hide()
                , 300)
            else
                console.log "item mouseout, Preview_container is showing"
                DCore.Dock.require_all_region()
                hide_id = setTimeout(=>
                    update_dock_region()
                    Preview_close_now(@)
                    hideStatusManager.updateState()
                , 1000)

    on_rightclick:(e)=>
        super
        _clear_item_timeout()
        clearTimeout(@showEmWindowTimer)
        Preview_close_now()
        setTimeout(->
            Preview_close_now()
        , 300)
        # console.log("rightclick")
        xy = get_page_xy(@element)

        clientHalfWidth = @element.clientWidth / 2
        menuContent = @core.menuContent?()
        if not menuContent
            _isRightclicked = false
            return

        screenOffset =
            x: e.screenX - e.pageX
            y: e.screenY - e.pageY

        menu =
            x: xy.x + clientHalfWidth + screenOffset.x
            y: xy.y + screenOffset.y
            isDockMenu: true
            cornerDirection: DEEPIN_MENU_CORNER_DIRECTION.DOWN
            menuJsonContent: menuContent

        menuJson = JSON.stringify(menu)

        # console.log(menuJson)

        try
            manager = get_dbus(
                "session",
                name:DEEPIN_MENU_NAME,
                path:DEEPIN_MENU_PATH,
                interface:DEEPIN_MENU_MANAGER_INTERFACE,
                "RegisterMenu"
            )
        catch e
            console.log(e)
            _isRightclicked = false
            return

        menu_dbus_path = manager.RegisterMenu_sync()
        # echo "menu path is: #{menu_dbus_path}"
        try
            dbus = get_dbus(
                "session",
                name:DEEPIN_MENU_NAME,
                path:menu_dbus_path,
                interface:DEEPIN_MENU_INTERFACE,
                "ShowMenu"
            )
        catch e
            conosle.log("get menu dbus failed: #{e}")
            _isRightclicked = false
            return

        dbus.connect("ItemInvoked", @on_itemselected($DBus[@id]))
        dbus.connect("MenuUnregistered", ->
            handleMenuUnregister()
            dbus = null
        )
        dbus.ShowMenu(menuJson)

    on_itemselected: (d)->
        (id)->
            # console.log("select id: #{id}")
            d?.HandleMenuItem(id)

    on_mouseup:(e)=>
        super
        if e.button != 0
            return

        if not @core.activate?(0,0)
            console.log("activate failed")
            dockedAppManager.Undock(@id)
            return
        console.log("on_click")
        if @isNormal() and settings.displayMode() != DisplayMode.Classic
            @openNotify()

    openNotify:->
        @openingIndicator.style.display = 'inline'
        @openingIndicator.style.webkitAnimationName = 'Breath'

    on_animationend: (e)=>
        console.log("open notify animation is end")
        @openingIndicator.style.webkitAnimationName = ''
        @openingIndicator.style.display = 'none'
        if @lastStatus == "active"
            @swap_to_clientgroup()

    to_active_status : (id)->
        @leader = id
        @n_clients.remove(id)
        @n_clients.unshift(id)

    on_dragleave: (e) =>
        super
        clearTimeout(pop_id) if e.dataTransfer.getData('text/plain') != "swap"

    on_drop: (e) =>
        super
        console.log("drop")
        clearTimeout(pop_id) if e.dataTransfer.getData('text/plain') != "swap"
