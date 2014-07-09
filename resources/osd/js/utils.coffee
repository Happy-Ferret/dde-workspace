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

_b = document.body
FOCUS = null

osd = {}

DEBUG = false
setFocus = (focus)->
    FOCUS = focus
    FOCUS = true if DEBUG
    DCore.Osd.set_focus(FOCUS)


TIME_HIDE = 1500
TIME_PRESS = 5
timeout_osdHide = null


allElsHide = ->
    els = _b.children
    for el in els
        if el.tagName = "DIV"
            el.style.display = "none"

osdHide = ->
    return if FOCUS
    echo "osdHide : #{timeout_osdHide}"

    allElsHide()
    DCore.Osd.hide()
    clearTimeout(timeout_osdHide)
    DCore.Osd.quit()
    return

osdShow = ->
    allElsHide()
    DCore.Osd.show()
    document.body.opacity = "0"
    jQuery(document.body).animate({opacity:'1';},500)

#osdHide()

click_time = 0
_b.addEventListener("click",(e)=>
    e.stopPropagation()
    echo click_time
    click_time++
    times = 1
    times = 3 if DEBUG
    if click_time % times == 0
        click_time = 0
        DCore.Osd.hide()
)

_b.addEventListener("contextmenu",(e)=>
    e.preventDefault()
    e.stopPropagation()
)

setBodySize = (width,height)->
    _b.style.width = width
    _b.style.height = height

set_bg = (cls,imgName,prevImgName)->
    if prevImgName == imgName then return
    echo "set_bg: bgChanged from #{prevImgName} to #{imgName}"

    cls.bg1 = create_element("div","#{cls.id}_bg1",cls.element) if not cls.bg1?
    cls.bg2 = create_element("div","#{cls.id}_bg2",cls.element) if not cls.bg2?
    cls.bg1.style.position = "absolute"
    cls.bg2.style.position = "absolute"
    cls.bg1.style.width = "100%"
    cls.bg2.style.width = "100%"
    cls.bg1.style.height = "100%"
    cls.bg2.style.height = "100%"

    try
        cls.bg1.style.backgroundImage = "url(img/#{prevImgName}.png)"
        cls.bg2.style.backgroundImage = "url(img/#{imgName}.png)"
    catch e
        echo "#{e}"
    cls.bg1.style.display = "block"
    cls.bg2.style.display = "block"

    t = 500
    cls.bg1.style.opacity = "1.0"
    jQuery(cls.bg1).animate({opacity:'0';},t,"swing")
    cls.bg2.style.opacity = "0.0"
    jQuery(cls.bg2).animate({opacity:'1';},t,"swing")

showValue = (value,min,max,cls,id)->
    if value > max then value = max
    else if value < min then value = min
    else if value is null then value = min

    if not cls.bar?
        cls.bar = new Bar(id)
        cls.bar.setPosition(cls.element,"31px","20px","absolute")
        cls.bar.setSize("98px","6px")
        cls.bar.setColor("#FFF")
        cls.bar.showProgressNum(false)
        cls.bar.progressCreate()
    echo "showValue: setProgress-----#{value / max}---"
    cls.bar.setProgress(value / max) if cls.bar


move_animation = (el,y0,y1,type = "top",pos = "absolute",cb) ->
    el.style.display = "block"
    el.style.position = pos
    t_show = 1000
    pos0 = null
    pos1 = null
    animate_init = ->
        switch type
            when "top"
                el.style.top = y0
                pos0 = {top:y0}
                pos1 = {top:y1}
            when "bottom"
                el.style.bottom = y0
                pos0 = {bottom:y0}
                pos1 = {bottom:y1}
    animate_init()
    jQuery(el).animate(
        pos1,t_show,"linear",=>
            animate_init()
            jQuery(el).animate(pos1,t_show,"linear",cb?())
    )

set_center = (el,w,h,x_scale = 1,y_scale = 0.8) ->
    top = (screen.height  - h) / 2 * y_scale
    left = (screen.width  - w) / 2 * x_scale
    el.style.position = "fixed"
    el.style.top = "#{top}px"
    el.style.left = "#{left}px"

