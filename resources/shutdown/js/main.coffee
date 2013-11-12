#Copyright (c) 2011 ~ 2012 Deepin, Inc.
#              2011 ~ 2012 snyh
#
#Author:      Cole <phcourage@gmail.com>
#Maintainer:  Cole <phcourage@gmail.com>
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

shutdown = new ShutDown()
shutdown.frame_build()
document.body.appendChild(shutdown.element)

DCore.signal_connect('workarea_changed', (alloc)->
    echo "workarea_changed"
    height = alloc.height
    width = alloc.width
    echo document.body + "#{height};#{width}"
    document.body.style.maxHeight = "#{height}px"
    document.body.style.maxWidth = "#{width}px"
)

inited = false
DCore.signal_connect("draw_background", (info)->
    echo "draw_background:url(#{info.path})"
    document.body.style.backgroundImage = "url(#{info.path})"
    # if inited
    #     DCore.Launcher.clear()
    # inited = true
)