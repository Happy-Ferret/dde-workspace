#Copyright (c) 2011 ~ Deepin, Inc.
#              2011 ~ 2012 snyh
#              2013 ~ Liqiang Lee
#
#Author:      Liqiang Lee <liliqiang@linuxdeepin.com>
#Maintainer:  Liqiang Lee <liliqiang@linuxdeepin.com>
#
#This program is free software; you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation; either version 3 of the License, or
#(at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program; if not, see <http://www.gnu.org/licenses/>.


class Panel
    constructor: (@id)->
        try
            @dockProperty = get_dbus(
                "session",
                name:"com.deepin.daemon.Dock",
                path:"/dde/dock/Property",
                interface:"dde.dock.Property",
                "SetPanelWidth",
            )
        catch e
            console.error(e)
            DCore.Dock.quit()

        @panel = $("##{@id}")
        @panel.width = ITEM_WIDTH * 3
        @panel.height = PANEL_HEIGHT
        # @panel.addEventListener("resize", @redraw)

        @panel.addEventListener("click", @on_click)
        $("#containerWrap").addEventListener("click", @on_click)

        @globalMenu = new GlobalMenu()
        @panel.addEventListener("contextmenu", @on_rightclick)
        $("#containerWrap").addEventListener("contextmenu", @on_rightclick)

        @has_notifications = false

    inEffectivePanelWorkarea: (x, y)=>
        switch settings.displayMode()
            when DisplayMode.Efficient, DisplayMode.Classic
                true
            when DisplayMode.Fashion
                margin = (screen.width - @panel.width) / 2
                itemMargin = (screen.width - $("#container").clientWidth) / 2
                return y > screen.height - DOCK_HEIGHT + ICON_HEIGHT || (x >= margin && x < itemMargin || x > screen.width - itemMargin && x <= screen.width - margin)

    on_click: (e)=>
        e.stopPropagation()
        e.preventDefault()

        switch settings.displayMode()
            when DisplayMode.Efficient, DisplayMode.Classic
                return

        if @inEffectivePanelWorkarea(e.clientX, e.clientY)
            show_desktop.toggle()
            calc_app_item_size()
            if debugRegion
                console.warn("[Panel.on_click] update_dock_region")
            update_dock_region()
            Preview_close_now(_lastCliengGroup)

    on_rightclick: (e)=>
        e.preventDefault()
        e.stopPropagation()
        if @inEffectivePanelWorkarea(e.clientX, e.clientY)
            @globalMenu.showMenu(e.screenX, e.screenY)
            Preview_close_now()
            $tooltip?.hide()

    load_image: (src)->
        img = new Image()
        img.src = src
        img

    redraw: =>
        @draw()

    draw: =>
        switch settings.displayMode()
            # TODO:
            when DisplayMode.Efficient, DisplayMode.Classic
                ctx = @panel.getContext('2d')
                ctx.clearRect(0, 0, @panel.width, @panel.height)
                ctx.rect(0, 0, @panel.width, @panel.height)
                ctx.fillStyle = 'rgba(0,0,0,.6)'
                ctx.fill()

                y = 0
                blackLineHeight = 1
                drawLine(ctx, 0, y, @panel.width, y, lineColor: 'rgba(0,0,0,.6)', lineWidth: blackLineHeight)

                y = blackLineHeight
                whiteLineHeight = 1
                drawLine(ctx, 0, y, @panel.width, y, lineColor: 'rgba(255,255,255,.15)', lineWidth: whiteLineHeight)
            when DisplayMode.Fashion
                DCore.Dock.draw_panel(
                    @panel,
                    PANEL_LEFT_IMAGE,
                    PANEL_MIDDLE_IMAGE,
                    PANEL_RIGHT_IMAGE,
                    @panel.width,
                    PANEL_MARGIN,
                    PANEL_HEIGHT
                )
        @dockProperty.SetPanelWidth(@panel.width)
        DCore.Dock.update_panel_width(@panel.width)

    _set_width: (w)->
        @panel.width = Math.min(w + PANEL_MARGIN * 2, screen.width)

    _set_height: (h)->
        @panel.height = Math.min(h, screen.height)

    set_width: (w)->
        @_set_width(w)
        @redraw()

    set_height: (h)->
        @_set_height(h)
        @redraw()

    set_size: (w, h)->
        @_set_width(w)
        @_set_height(h)
        @redraw()

    width: ->
        @panel.width

    update: (appid, itemid)=>
        echo "#{appid}, #{itemid}"
        if appid == DEEPIN_APPTRAY
            echo "show message"
            @has_notifications = true
            @redraw()
        else
            echo "not dapptray: #{itemid}"
            if itemid != "" && (w = Widget.look_up("le_#{itemid}"))?
                w.notify()
            else
                Widget.look_up("le_#{appid}")?.notify()

    updateWithAnimation:=>
        @cancelAnimation()
        if debugRegion
            console.warn("[Panel.updateWithAnimation] update_dock_region")
        update_dock_region($("#container").clientWidth)
        panel.set_width(Panel.getPanelMiddleWidth())
        @calcTimer = webkitRequestAnimationFrame(@updateWithAnimation)

    cancelAnimation:=>
        webkitCancelAnimationFrame(@calcTimer || null)
        if debugRegion
            console.warn("[Panel.cancelAnimation] update_dock_region")
        update_dock_region($("#container").clientWidth)

    # TODO: remove it.
    @getPanelMiddleWidth:->
        switch settings.displayMode()
            when DisplayMode.Efficient, DisplayMode.Classic
                return screen.width

        apps = $s(".AppItem")
        panel_width = ITEM_WIDTH * apps.length
        # FIXME: clientWidth is 0 on switching mode.
        return $("#container").clientWidth || panel_width

    @getPanelWidth:->
        @getPanelMiddleWidth() + PANEL_MARGIN * 2
