#Copyright (c) 2011 ~ 2012 Deepin, Inc.
#              2011 ~ 2012 yilang
#
#Author:      LongWei <yilang2007lw@gmail.com>
#                     <snyh@snyh.org>
#Maintainer:  LongWei <yilang2007lw@gmail.com>
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

apply_refuse_rotate = (el, time)->
    apply_animation(el, "refuse", "#{time}s", "linear")
    setTimeout(->
        el.style.webkitAnimation = ""
    , time * 1000)

class LoginEntry extends Widget
    constructor: (@id, @on_active)->
        super
        @password = create_element("input", "Password", @element)
        @password.setAttribute("type", "password")
        @password.index = 0
        @password.addEventListener("keyup", (e)=>
            if e.which == 13
                if not @password.value
                    @password.focus()
                else
                    @on_active(@password.value)
        )

        @login = create_element("button", "LoginButton", @element)
        @login.innerText = "UnLock"
        @login.addEventListener("click", =>
            if not @password.value
                @password.focus()
            else
                @on_active(@password.value)
        )
        @login.index = 1
        @password.focus()
    
class Loading extends Widget
    constructor: (@id)->
        super
        create_element("div", "ball", @element)
        create_element("div", "ball1", @element)
        create_element("span", "", @element).innerText = "Welcome !"

_current_user = null

class UserInfo extends Widget
    constructor: (@id, name, img_src)->
        super
        @li = create_element("li", "")
        @li.appendChild(@element)
        @img = create_img("UserImg", img_src, @element)
        @name = create_element("span", "UserName", @element)
        @name.innerText = name
        @active = false
        @login_displayed = false

    focus: ->
        _current_user?.blur()
        _current_user = @
        @add_css_class("UserInfoSelected")

    blur: ->
        @element.setAttribute("class", "UserInfo")
        @login?.destroy()
        @login = null
        @loading?.destroy()
        @loading = null

    show_login: ->
        if false
            @login()
        else if not @login
            @login = new LoginEntry("login", (p)=>@on_verify(p))
            @element.appendChild(@login.element)
            @login.password.focus()
            @login_displayed = true
            @add_css_class("foo")
    
    do_click: (e)->
        if _current_user == @
            if not @login
                @show_login()
            else
                if e.target.parentElement.className == @login.element.className
                    echo "login pwd clicked"
                else
                    if @login_displayed
                        @focus()
                        @login_displayed = false
        else
            @focus()
    
    on_verify: (password)->
        if not password
            @login.password.focus()
        else
            @login.destroy()
            @loading = new Loading("loading")
            @element.appendChild(@loading.element)
            DCore.Lock.try_unlock(password)

    unlock_check: (msg) ->
        if msg.status == "succeed"
            DCore.Lock.unlock_succeed()
        else
            @focus()
            @show_login()
            @login.password.setAttribute("type", "text")
            @login.password.style.color = "red"
            @login.password.value = msg.status
            @login.password.blur()
            @login.password.addEventListener("focus", (e)=>
                @login.password.setAttribute("type", "password")
                @login.password.style.color = "black"
                @login.password.value = ""
            )

            apply_refuse_rotate(@element, 0.5)

user = DCore.Lock.get_username()

user_path = DCore.DBus.sys_object("org.freedesktop.Accounts","/org/freedesktop/Accounts","org.freedesktop.Accounts").FindUserByName_sync(user)
user_image = DCore.DBus.sys_object("org.freedesktop.Accounts", user_path, "org.freedesktop.Accounts.User").IconFile

if not user_image? or not user_image.length
    user_image = "images/img01.jpg"

user_background = DCore.DBus.sys_object("org.freedesktop.Accounts", user_path, "org.freedesktop.Accounts.User").BackgroundFile
if not user_background? or not user_background.length
    user_background = "/usr/share/backgrounds/1440x900.jpg"
background_img = create_img("Background",user_background) 
document.body.appendChild(background_img)

u = new UserInfo(user, user, user_image) 
u.focus()
$("#lockroundabout").appendChild(u.li)
DCore.signal_connect("unlock", (msg)->
    u.unlock_check(msg)
)

