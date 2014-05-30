DOCK_PADDING = 24
ICON_MARGIN_H = 6
ICON_MARGIN_V_TOP = 3
ICON_MARGIN_V_BOTTOM = 10
ICON_SIZE = 48
        

POS_TYPE =
    leftup:"leftup"
    leftdown:"leftdown"
    rightup:"rightup"
    rightdown:"rightdown"
    down:"down"
    up:"up"

AREA_TYPE =
    circle:"circle"
    circle_white:"circle_white"
    corner:"corner"

set_pos = (el,x,y,position_type = "fixed",type = POS_TYPE.leftup)->
    el.style.position = position_type
    switch type
        when POS_TYPE.leftup
            el.style.left = x
            el.style.top = y
        when POS_TYPE.leftdown
            el.style.left = x
            el.style.bottom = y
        when POS_TYPE.rightup
            el.style.right = x
            el.style.top = y
        when POS_TYPE.rightdown
            el.style.right = x
            el.style.bottom = y
        else
            el.style.left = x
            el.style.top = y
        