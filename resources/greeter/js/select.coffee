nicesx = null

class Select extends Widget
    EACH_HEIGHT = 36
    constructor:(@id,@parent)->
        super
        echo "New Select #{@id}"
        @parent?.appendChild(@element)
        #inject_js("js/jquery/jquery.nicescroll.js")
        inject_css(@element,"css/select.css")
        @lists = []
        @selected = null
        @boxscroll = null
        @hide()

    set_lists:(@current,@lists) ->

    toggle: ->
        if @element.style.display isnt "none" then @hide()
        else @show()

    show: ->
        @element.style.display = "block"
        @check_selected_css()
        #@boxscroll_create()

    hide: ->
        @element.style.display = "none"
        #@boxscroll_remove()

    boxscroll_remove: ->
        @element.removeChild(@boxscroll) if @boxscroll
        @boxscroll = null

    boxscroll_create: (@max_show = 5) ->
        @boxscroll_remove()
        #@triangle = create_img("triangle","images/triangle.png",@element)
        @boxscroll = create_element("div","boxscroll",@element)
        @boxscroll.setAttribute("id","boxscroll")
        @boxscroll.style.maxHeight = EACH_HEIGHT * @max_show
        @boxscroll.style.overflowY = "scroll" if @lists.length > @max_show
        @li = []
        @a = []
        @ul = create_element("ul","select_ul",@boxscroll)
        for each,i in @lists
            @li[i] = create_element("li","select_li",@ul)
            @li[i].setAttribute("style","height:#{EACH_HEIGHT}px;line-height:#{EACH_HEIGHT}px;")
            @a[i] = create_element("a","select_a",@li[i])
            @li[i].setAttribute("id",each)
            @a[i].innerText = each

    check_selected_css: ->
        @selected = @current
        if @li.length == 0 then @boxscroll_create()
        for each,i in @lists
            if each is @current
                @select_css(i)
                #@li[i].removeEventListener("mouseover",@hover_css(i))
                #@li[i].removeEventListener("mouseout",@unselect_css(i))
            else
                @unselect_css(i)
                #@li[i].addEventListener("mouseover",@hover_css(i))
                #@li[i].addEventListener("mouseout",@unselect_css(i))

    unselect_css: (i) =>
        echo "unselect_css:#{i}"
        @li[i].style.background = "no-repeat"
        @li[i].style.backgroundPosition = "5px 11px"
        @li[i].style.backgroundColor = "rgba(0,0,0,0.4)"
        @a[i].style.color = "#FFFFFF"

    hover_css: (i) =>
        echo "hover_css:#{i}"
        @li[i].style.background = "no-repeat"
        @li[i].style.backgroundPosition = "5px 11px"
        @li[i].style.backgroundColor = "rgba(0,0,0,0.7)"
        @a[i].style.color = "#FFFFFF"

    select_css: (i) =>
        echo "select_css:#{i}"
        @li[i].style.background = "url(\"images/select_dark_hover.png\") no-repeat"
        @li[i].style.backgroundPosition = "5px 11px"
        @li[i].style.backgroundColor = "rgba(0,0,0,0.7)"
        @a[i].style.color = "#01bdff"

    set_cb:(@cb) ->
        if @li.length == 0 then @boxscroll_create()
        for each,i in @lists
            that = @
            @li[i].addEventListener("click",(e)->
                e.stopPropagation()
                that.current = this.id
                that.cb?(that.current)
            )
