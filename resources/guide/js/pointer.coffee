#Copyright (c) 2011 ~ 2014 Deepin, Inc.
#              2011 ~ 2014 bluth
#
#encoding: utf-8
#Author:      bluth <yuanchenglu@linuxdeepin.com>
#Maintainer:  bluth <yuanchenglu@linuxdeepin.com>
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


AREA_TYPE =
    circle:"circle"
    circle_white:"circle_white"
    corner:"corner"

class Pointer extends Widget
    constructor:(@id,parent)->
        super
        echo "new Pointer #{@id}"
        @img_src = "img"
        parent?.appendChild(@element)
        inject_css(@element,"css/pointer.css")
        @element.style.display = "none"

    create_pointer: (@area_type,@pos_type,@cb,@cb_type = "click") ->
        @pointer_img = create_img("pointer_img","",@element)
        @area_div = create_element("div","area_div",@element)

        @area_div.style.display = "-webkit-box"
        @area_div.style.webkitBoxPack = "center"
        @area_div.style.webkitBoxAlign = "center"

        @pointer_img.src = "#{@img_src}/pointer_#{@pos_type}.png"
        if @area_type isnt AREA_TYPE.corner
            @area_div.style.backgroundImage = "url(#{@img_src}/#{@area_type}.png)"
        else
            @area_div.style.backgroundImage = "url(#{@img_src}/#{@area_type}_#{@pos_type}.png)"

        @area_width = @pointer_width = ITEM_SIZE[_dm].w
        @area_height = @pointer_height = ITEM_SIZE[_dm].h
        @height = @area_height + @pointer_height
        @width = @area_width + @pointer_width
        @pointer_img.style.width = @pointer_width
        @pointer_img.style.height = @pointer_height
        @area_div.style.width = @area_width
        @area_div.style.height = @area_height
        @element.style.width = @width
        @element.style.height = @height

        set_pos(@area_div,0,0,"absolute",@pos_type)
        set_pos(@pointer_img,@area_width,@area_height,"absolute",@pos_type)
        #shadow_light(@area_div,"circle")
        @area_div.addEventListener(@cb_type, (e)=>
            #if !@show_animation_end then return
            console.log "area #{@id} click"
            @cb?(e)
        )

    enable_area_icon: (@area_icon_path,w = ICON_SIZE[_dm].w,h = ICON_SIZE[_dm].h) ->
        @area_icon = create_img("area_icon",@area_icon_path,@area_div) if not @area_icon?
        if w > POINTER_AREA_SIZE[_dm] then w = POINTER_AREA_SIZE[_dm]
        if h > POINTER_AREA_SIZE[_dm] then h = POINTER_AREA_SIZE[_dm]
        @area_icon?.style.width = w
        @area_icon?.style.height = h

    set_area_pos : (x,y,position_type = "absolute",type = POS_TYPE.leftup) ->
        set_pos(@element,x,y,position_type,type)
        #@show_animation()

    opacity : (value) ->
        @element.style.opacity = value

    display : (type) ->
        @element.style.display = type

    show_animation: (@show_cb) ->
        @element.style.display = "block"
        @show_animation_end = false
        init_delta = @area_width
        t_show = 1000
        x0 = @area_width + init_delta
        y0 = @area_height + init_delta
        x1 = @area_width
        y1 = @area_height
        pos = {}
        switch @pos_type
            when POS_TYPE.leftup
                pos = {left:x1;top:y1}

            when POS_TYPE.rightup
                pos = {right:x1;top:y1}

            when POS_TYPE.leftdown
                pos = {left:x1;bottom:y1}

            when POS_TYPE.rightdown
                pos = {right:x1;bottom:y1}
        set_pos(@pointer_img,x0,y0,"absolute",@pos_type)
        jQuery(@pointer_img).animate(
            pos,t_show,"linear",=>
                set_pos(@pointer_img,x0,y0,"absolute",@pos_type)
                jQuery(@pointer_img).animate(
                    pos,t_show,"linear",=>
                        @show_animation_end = true
                        @show_cb?()
                )
        )
