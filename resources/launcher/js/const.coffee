#Copyright (c) 2011 ~  Deepin, Inc.
#              2013 ~  Lee Liqiang
#
#Author:      Lee Liqiang <liliqiang@linuxdeepin.com>
#Maintainer:  Lee Liqiang <liliqiang@linuxdeepin.com>
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

SWITCHER_WIDTH = 64
ITEM_WIDTH = 160
ITEM_HEIGHT = 160

CONTAINER_BOTTOM_MARGIN = 70
SEARCH_BAR_HEIGHT = 50
GRID_PADDING = 160
CATEGORY_LIST_ITEM_MARGIN = 20
CATEGORY_BAR_ITEM_MARGIN = 10

SCROLL_STEP_LEN = ITEM_HEIGHT

CATEGORY_ID =
    ALL: -1
    OTHER: -2
    INTERNET: 0
    MULTIMEDIA: 1
    GAMES: 2
    GRAPHICS: 3
    PRODUCTIVITY: 4
    INDUSTRY: 5
    EDUCATION: 6
    DEVELOPMENT: 7
    SYSTEM: 8
    UTILITIES: 9

NUM_SHOWN_ONCE = 10

ITEM_IMG_SIZE = 48

GRID_MARGIN_BOTTOM = 30

KEYCODE.BACKSPACE = 8
KEYCODE.TAB = 9
KEYCODE.P = 80
KEYCODE.N = 78
KEYCODE.B = 66
KEYCODE.F = 70

HIDDEN_ICONS_MESSAGE =
    true: _("_Hide the icon")
    false: _("_Display hidden icons")

ITEM_HIDDEN_ICON_MESSAGE =
    'display': _("_Hide this icon")
    'hidden': _("_Display this icon")

AUTOSTART_MESSAGE =
    false: _("_Add to autostart")
    true: _("_Remove from autostart")

AUTOSTART_ICON =
    NAME: "emblem-autostart"
    SIZE: 16

SEND_TO_DESKTOP_MESSAGE =
    false: _("Send to d_esktop")
    true: _("Remove from d_esktop")

SEND_TO_DOCK_MESSAGE =
    false: _("Send to do_ck")
    true: _("Remove from do_ck")

MASK_TOP_BOTTOM = "-webkit-linear-gradient(top, rgba(0,0,0,0), rgba(0,0,0,1) 5%, rgba(0,0,0,1) 90%, rgba(0,0,0,0.3), rgba(0,0,0,0))"

CATEGORY_ORDER = [
    CATEGORY_ID.INTERNET,
    CATEGORY_ID.MULTIMEDIA,
    CATEGORY_ID.GAMES,
    CATEGORY_ID.GRAPHICS,
    CATEGORY_ID.PRODUCTIVITY,
    CATEGORY_ID.INDUSTRY,
    CATEGORY_ID.EDUCATION,
    CATEGORY_ID.DEVELOPMENT,
    CATEGORY_ID.SYSTEM,
    CATEGORY_ID.UTILITIES,
    CATEGORY_ID.OTHER
]

SWITCHER_SHADOW = "img/radial-bg.png"
