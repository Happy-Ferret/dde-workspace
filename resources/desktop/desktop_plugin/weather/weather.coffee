#Copyright (c) 2011 ~ 2012 Deepin, Inc.
#              2011 ~ 2012 bluth
#
#Author:      bluth <yuanchenglu@linuxdeepin.com>
#Maintainer:  bluth <yuanchenglu@linuxdeepin.com>

class Weather
    weather_data = null
    prov2city = null
    xhr = null 
    cityurl = null
    cityid = null
    cityid_info = null
    weather_now_pic = null 
    temperature_now = null 
    city = null
    date = null
    week1 = null
    week2 = null
    week3 = null
    week4 = null
    week5 = null
    week6 = null
    pic1 = null
    pic2 = null
    pic3 = null 
    pic4 = null 
    pic5 = null
    pic6 = null 
    tempratue1 = null
    tempratue2 = null
    tempratue3 = null
    tempratue4 = null
    tempratue5 = null
    tempratue6 = null
    refresh = null
    weather_click_times = 0
    auto_update = null #set it as whole  for we can close auto update in needing
    img_url_first = "desktop_plugin/weather/img/"
    chooseprov = null
    choosecity = null
    provincetemp = null
    citytemp = null
    allname = null

    constructor: ->
        week_init = "星期日"
        img_url_init = img_url_first + "b1.gif"

        @element = create_element("div","Weather",null)
        @element.draggable = true

        @date_init()
        @weathergui_init() 
        
        weather_now_pic = create_img("weather_now_pic", img_url_init, @element)

        temperature_now = create_element("div", "temperature_now", @element)
        temperature_now.textContent = "20°"

        city_and_date = create_element("div", "city_and_date", @element)

        city = create_element("div", "city", city_and_date)
        city.textContent = "北京"

        date = create_element("div", "date", city_and_date)
        date.textContent =  "正在加载中..." + "..."

        more_weather_menu = create_element("div", "more_weather_menu", @element)

        first_day_weather_data = create_element("div", "first_day_weather_data", more_weather_menu)
        week1 = create_element("a", "week1", first_day_weather_data)
        week1.textContent = week_init
        pic1 = create_img("pic1", img_url_init, first_day_weather_data)
        tempratue1 = create_element("a", null, first_day_weather_data)
        tempratue1.textContent = "22℃~10℃"

        second_day_weather_data = create_element("div", "second_day_weather_data", more_weather_menu)
        week2 = create_element("a", "week2", second_day_weather_data)
        week2.textContent = week_init
        pic2 = create_img("pic2", img_url_init, second_day_weather_data)
        tempratue2 = create_element("a", null, second_day_weather_data)
        tempratue2.textContent = "22℃~10℃"

        third_day_weather_data = create_element("div", "third_day_weather_data", more_weather_menu)
        week3 = create_element("a", "week3", third_day_weather_data)
        week3.textContent = week_init
        pic3 = create_img("pic3", img_url_init, third_day_weather_data)
        tempratue3 = create_element("a", null, third_day_weather_data)
        tempratue3.textContent = "22℃~10℃"

        fourth_day_weather_data = create_element("div", "fourth_day_weather_data", more_weather_menu)
        week4 = create_element("a", "week4", fourth_day_weather_data)
        week4.textContent = week_init
        pic4 = create_img("pic4", img_url_init, fourth_day_weather_data)
        tempratue4 = create_element("a", null, fourth_day_weather_data)
        tempratue4.textContent = "22℃~10℃"

        fifth_day_weather_data = create_element("div", "fifth_day_weather_data", more_weather_menu)
        week5 = create_element("a", "week5", fifth_day_weather_data)
        week5.textContent = week_init
        pic5 = create_img("pic5", img_url_init, fifth_day_weather_data)
        tempratue5 = create_element("a", null, fifth_day_weather_data)
        tempratue5.textContent = "22℃~10℃"

        sixth_day_weather_data = create_element("div", "sixth_day_weather_data", more_weather_menu)
        week6 = create_element("a", "week6", sixth_day_weather_data)
        week6.textContent = week_init
        pic6 = create_img("pic6", img_url_init, sixth_day_weather_data)
        tempratue6 = create_element("a", null, sixth_day_weather_data)
        tempratue6.textContent = "22℃~10℃"

        refresh = create_img("refresh", img_url_first + "refresh.png", @element)
        more_city = create_img("more_city", img_url_first + "ar.png", @element)       
        more_city_menu = create_element("div", "more_city_menu", @element)
        chooseprov = create_element("select", "chooseprov", more_city_menu)        
        # chooseprov.options.length = 1
        chooseprov.size = 1
        choosecity = create_element("select", "choosecity", more_city_menu)
        # choosecity.options.length = 1

        # provinit = create_element("option", "provinit", chooseprov)
        # provinit.innerText = "--省--"        
        # cityinit = create_element("option", "cityinit", choosecity)
        # cityinit.innerText = "--市--"

        date.addEventListener("click", => 
            if more_weather_menu.style.display == "none" 
                more_weather_menu.style.display = "block"
                more_city_menu.style.display = "none"
                @element.style.zIndex = "65535"    
                echo "more_weather_menu block ,none more_city none  "        
            else 
                more_weather_menu.style.display = "none"
                more_city_menu.style.display = "none"
                @element.style.zIndex = "1"
                echo "more_weather_menu none ,none more_city none  "   
        )        

        more_city.addEventListener("click", =>             
            if more_city_menu.style.display == "none"
                more_city_menu.style.display = "block"
                chooseprov.style.display = "block"
                choosecity.style.display = "block"
                more_weather_menu.style.display = "none"
                @element.style.zIndex = "65535"
                echo "more_city block , more_weather_menu none "
            else 
                more_city_menu.style.display = "none" 
                chooseprov.style.display = "none"
                choosecity.style.display = "none"                
                more_weather_menu.style.display = "none"
                @element.style.zIndex = "1"
                echo "more_city none , more_weather_menu none "

            chooseprov.size = 13
            choosecity.size = 1
            chooseprov.options.length = 0 #clear the prov option value
            for key of prov2city
                provincetemp = create_element("option", "provincetemp", chooseprov)
                provincetemp.innerText = key
        )


        chooseprov.addEventListener("change", ->
            echo "prov change"
            provIndex = chooseprov.selectedIndex #序号，取当前选中选项的序号 
            provincevalue = chooseprov.options[provIndex].value 
            chooseprov.size = 1

            choosecity.options.length = 0 #clear the city option value
            if prov2city[provincevalue].length < 8                
                choosecity.size = prov2city[provincevalue].length
            else choosecity.size = 8
            for cityvalue in prov2city[provincevalue]
                citytemp = create_element("option", "citytemp", choosecity)
                citytemp.innerText = cityvalue
            ) 
        chooseprov.addEventListener("blur", ->
            echo "prov blur"            
            )
        choosecity.addEventListener("blur", ->
            echo "city blur"
            )
        chooseprov.addEventListener("focus", ->
            echo "prov focus"            
            )
        choosecity.addEventListener("focus", ->
            echo "city focus"
            )
        choosecity.addEventListener("change", ->
            echo "city change"
            chooseprov.options.length = 1
            chooseprov.style.display = "none"
            choosecity.style.display = "none"

            cityIndex = choosecity.selectedIndex #序号，取当前选中选项的序号 
            cityvalue = choosecity.optionscity[cityIndex].value
            for provin of allname.城市代码
                if allname.城市代码[provin].省 is provincevalue
                    echo allname.城市代码[provin].省
                    for ci of allname.城市代码[provin].市
                        if allname.城市代码[provin].市[ci].市名 is cityvalue
                            echo allname.城市代码[provin].市[ci].市名
                            echo allname.城市代码[provin].市[ci].编码
                            cityid = allname.城市代码[provin].市[ci].编码
                            cityurl = "http://m.weather.com.cn/data/"+cityid+".html"
                            @weathergui_update()
            )

        refresh.addEventListener("click", =>
            refresh.style.backgroundColor = "gray"
            @weathergui_update()
        )

        @element.addEventListener("click", =>
            weather_click_times++
            if weather_click_times%2
                @element.style.zIndex = "65535"
            else 
                @element.style.zIndex = "1"
        )   

    ajax : (url, method, callback, asyn=true) ->
        xhr = new XMLHttpRequest()
        xhr.open(method, url, asyn)
        xhr.send(null)
        xhr.onreadystatechange = ->
            if (xhr.readyState == 4 and xhr.status == 200)
                echo "received all over 200 update"
                callback?(xhr)                
            else if xhr.readystate == 0 
                echo "init"
            else if xhr.readystate == 1
                echo "open"
            else if xhr.readystate == 2
                echo "send"
            else if xhr.readystate == 3
                echo "receiving"    

    weathergui_init: =>
        window.loader.addcss('desktop_plugin/weather/weather.css', 'screen print').load()
        # document.getElementById('css').href = 'weather2.css'
        cityid = 101200101  #101200101 #101010100
        cityurl = "http://m.weather.com.cn/data/"+cityid+".html"    
        # @date_init()
        # here set ten mins to updata gui
        auto_update = setInterval(@weathergui_update(),10*60000)

    weathergui_update: ->        
        # echo "weathergui_update"
        @ajax( cityurl , "GET", (xhr)=>
            localStorage.setItem(weather_data,xhr.responseText)
            weather_data = JSON.parse(localStorage.getItem(weather_data))
            localStorage.removeItem(weather_data)  
            # echo "received all update "
            week_name = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
            i_week = 0
            while i_week < week_name.length
                break if weather_data.weatherinfo.week is week_name[i_week]
                i_week++
            # alert i_week  
            week_n = i_week
            weather_now_pic.src = img_url_first + "b"+ weather_data.weatherinfo.img1 + ".gif"
            str_data = weather_data.weatherinfo.date_y
            date.textContent = str_data.substring(0,str_data.indexOf("年")) + "." + str_data.substring(str_data.indexOf("年")+1,str_data.indexOf("月"))+ "." + str_data.substring(str_data.indexOf("月") + 1,str_data.indexOf("日")) + weather_data.weatherinfo.week            
            temp_str = weather_data.weatherinfo.temp1
            i = temp_str.indexOf("℃")
            j = temp_str.lastIndexOf("℃")
            temper= ( parseInt(temp_str.substring(0,i)) + parseInt(temp_str.substring(i+2,j)) )/2
            temperature_now.textContent = Math.round(temper) + "°"            
            city.textContent = weather_data.weatherinfo.city

            week1.textContent = week_name[week_n%7]
            pic1.src = img_url_first + "b"+ weather_data.weatherinfo.img1 + ".gif"
            tempratue1.textContent = weather_data.weatherinfo.temp1
            week2.textContent = week_name[(week_n+1)%7]
            pic2.src = img_url_first + "b"+ weather_data.weatherinfo.img3 + ".gif"
            tempratue2.textContent = weather_data.weatherinfo.temp2
            week3.textContent = week_name[(week_n+2)%7]
            pic3.src = img_url_first + "b"+ weather_data.weatherinfo.img5 + ".gif"
            tempratue3.textContent = weather_data.weatherinfo.temp3
            week4.textContent = week_name[(week_n+3)%7]
            pic4.src = img_url_first + "b"+ weather_data.weatherinfo.img7 + ".gif"
            tempratue4.textContent = weather_data.weatherinfo.temp4
            week5.textContent = week_name[(week_n+4)%7]
            pic5.src = img_url_first + "b"+ weather_data.weatherinfo.img9 + ".gif"
            tempratue5.textContent = weather_data.weatherinfo.temp5
            week6.textContent = week_name[(week_n+5)%7]
            pic6.src = img_url_first + "b"+ weather_data.weatherinfo.img11 + ".gif"
            tempratue6.textContent = weather_data.weatherinfo.temp6

            refresh.style.backgroundColor = null
        )
              

    date_init: ->
        prov2city = {
        '--省--':['--市--'],
        '北京':['北京'],
        '上海':['上海'],
        '黑龙江':['牡丹江','大兴安岭','黑河','齐齐哈尔','绥化','鹤岗','佳木斯','伊春','双鸭山','哈尔滨','鸡西','漠河','大庆','七台河','绥芬河'],
        '安徽':['淮南','马鞍山','淮北','铜陵','滁州','巢湖','池州','宣城','亳州','宿州','阜阳','六安','蚌埠','合肥','芜湖','安庆','黄山'],
        '澳门':['澳门'],
        
        '重庆':['奉节','重庆','涪陵'],
        '福建':['莆田','浦城','南平','宁德','福州','龙岩','三明','泉州','漳州','厦门'],
        '甘肃':['张掖','金昌','武威','兰州','白银','定西','平凉','庆阳','甘南','临夏','天水','嘉峪关','酒泉','陇南'],
        '广东':['南雄','韶关','清远','梅州','肇庆','广州','河源','汕头','深圳','汕尾','湛江','阳江','茂名','佛冈','梅县','电白','高要','珠海','佛山','江门','惠州','东莞','中山','潮州','揭阳','云浮'],
        '广西':['桂林','河池','柳州','百色','贵港','梧州','南宁','钦州','北海','防城港','玉林','贺州','来宾','崇左'],
        '贵州':['毕节','遵义','铜仁','安顺','贵阳','黔西南布依族苗族自治州','六盘水'],
        '海南':['海口','三亚','屯昌','琼海','儋州','文昌','万宁','东方','澄迈','定安','临高','白沙黎族自治县','乐东黎族自治县','陵水黎族自治县','保亭黎族苗族自治县','琼中黎族苗族自治县'],
        '河北':['邯郸','衡水','石家庄','邢台','张家口','承德','秦皇岛','廊坊','唐山','保定','沧州'],
        '河南':['安阳','三门峡','郑州','南阳','周口','驻马店','信阳','开封','洛阳','平顶山','焦作','鹤壁','新乡','濮阳','许昌','漯河','商丘','济源'],
        
        '湖北':['襄樊','荆门','黄冈','恩施土家族苗族自治州','武汉','麻城','黄石','鄂州','孝感','咸宁','随州','仙桃','天门','潜江','神农架','枣阳'],
        '湖南':['张家界','岳阳','怀化','长沙','邵阳','益阳','郴州','桑植','沅陵','南岳','株洲','湘潭','衡阳','娄底','常德'],
        '吉林':['辽源','通化','白城','松原','长春','吉林市','桦甸','延边朝鲜族自治州','集安','白山','四平'],
        '江苏':['无锡','苏州','盱眙','赣榆','东台','高邮','镇江','泰州','宿迁','徐州','连云港','淮安','南京','扬州','盐城','南通','常州'],
        '江西':['庐山','玉山','贵溪','广昌','萍乡','新余','宜春','赣州','九江','景德镇','南昌','鹰潭','上饶','抚州'],
        '辽宁':['葫芦岛','盘锦','辽阳','铁岭','阜新','朝阳','锦州','鞍山','沈阳','本溪','抚顺','营口','丹东','瓦房店','大连'],
        '内蒙古':['呼伦贝尔','兴安盟','锡林郭勒盟','巴彦淖尔盟','包头','呼和浩特','锡林浩特','通辽','赤峰','乌海','鄂尔多斯','乌兰察布盟'],
        '宁夏':['石嘴山','银川','吴忠','固原'],
        '青海':['海北藏族自治州','海南藏族自治州','西宁','玉树藏族自治州','黄南藏族自治州','果洛藏族自治州','海西蒙古族藏族自治州','海东'],
        '山东':['德州','滨州','烟台','聊城','济南','泰安','淄博','潍坊','青岛','济宁','日照','泰山','枣庄','东营','威海','莱芜','临沂','菏泽'],
        '山西':['长治','晋中','朔州','大同','吕梁','忻州','太原','阳泉','临汾','运城','晋城','五台山'],
        '陕西':['榆林','延安','西安','渭南','汉中','商洛','安康','铜川','宝鸡','咸阳'],
        
        '四川':['甘孜藏族自治州','阿坝藏族羌族自治州','成都','绵阳','雅安','峨眉山','乐山','宜宾','巴中','达州','遂宁','南充','泸州','自贡','攀枝花','德阳','广元','内江','广安','眉山','资阳','凉山彝族自治州'],
        '台湾':['台北'],
        '天津':['天津','塘沽区'],
        '西藏':['那曲','日喀则','拉萨','山南','阿里','昌都','林芝'],
        '香港':['香港'],
        '新疆':['昌吉回族自治州','克孜勒苏柯尔克孜自治州','伊犁哈萨克自治州','阿拉尔','克拉玛依','博尔塔拉蒙古自治州','乌鲁木齐','吐鲁番','阿克苏','石河子','喀什','和田','哈密','奇台'],
        '云南':['昭通','丽江','曲靖','保山','大理白族自治州','楚雄彝族自治州','昆明','瑞丽','玉溪','临沧','思茅','红河哈尼族彝族自治州','文山壮族苗族自治州','西双版纳傣族自治州','德宏傣族景颇族自治州','怒江傈傈族自治州','迪庆藏族自治州'],
        '浙江':['湖州','嵊州','平湖','石浦','宁海','洞头','舟山','杭州','嘉兴','金华','绍兴','宁波','衢州','丽水','台州','温州']
        }
        allname = {
                    "城市代码": [
                        {
                            "省": "北京",
                            "市": [
                                {
                                    "市名": "北京",
                                    "编码": "101010100"
                                },
                                {
                                    "市名": "朝阳",
                                    "编码": "101010300"
                                },
                                {
                                    "市名": "顺义",
                                    "编码": "101010400"
                                },
                                {
                                    "市名": "怀柔",
                                    "编码": "101010500"
                                },
                                {
                                    "市名": "通州",
                                    "编码": "101010600"
                                },
                                {
                                    "市名": "昌平",
                                    "编码": "101010700"
                                },
                                {
                                    "市名": "延庆",
                                    "编码": "101010800"
                                },
                                {
                                    "市名": "丰台",
                                    "编码": "101010900"
                                },
                                {
                                    "市名": "石景山",
                                    "编码": "101011000"
                                },
                                {
                                    "市名": "大兴",
                                    "编码": "101011100"
                                },
                                {
                                    "市名": "房山",
                                    "编码": "101011200"
                                },
                                {
                                    "市名": "密云",
                                    "编码": "101011300"
                                },
                                {
                                    "市名": "门头沟",
                                    "编码": "101011400"
                                },
                                {
                                    "市名": "平谷",
                                    "编码": "101011500"
                                },
                                {
                                    "市名": "八达岭",
                                    "编码": "101011600"
                                },
                                {
                                    "市名": "佛爷顶",
                                    "编码": "101011700"
                                },
                                {
                                    "市名": "汤河口",
                                    "编码": "101011800"
                                },
                                {
                                    "市名": "密云上甸子",
                                    "编码": "101011900"
                                },
                                {
                                    "市名": "斋堂",
                                    "编码": "101012000"
                                },
                                {
                                    "市名": "霞云岭",
                                    "编码": "101012100"
                                },
                                {
                                    "市名": "北京城区",
                                    "编码": "101012200"
                                },
                                {
                                    "市名": "海淀",
                                    "编码": "101010200"
                                }
                            ]
                        },
                        {
                            "省": "天津市",
                            "市": [
                                {
                                    "市名": "天津",
                                    "编码": "101030100"
                                },
                                {
                                    "市名": "宝坻",
                                    "编码": "101030300"
                                },
                                {
                                    "市名": "东丽",
                                    "编码": "101030400"
                                },
                                {
                                    "市名": "西青",
                                    "编码": "101030500"
                                },
                                {
                                    "市名": "北辰",
                                    "编码": "101030600"
                                },
                                {
                                    "市名": "蓟县",
                                    "编码": "101031400"
                                },
                                {
                                    "市名": "汉沽",
                                    "编码": "101030800"
                                },
                                {
                                    "市名": "静海",
                                    "编码": "101030900"
                                },
                                {
                                    "市名": "津南",
                                    "编码": "101031000"
                                },
                                {
                                    "市名": "塘沽",
                                    "编码": "101031100"
                                },
                                {
                                    "市名": "大港",
                                    "编码": "101031200"
                                },
                                {
                                    "市名": "武清",
                                    "编码": "101030200"
                                },
                                {
                                    "市名": "宁河",
                                    "编码": "101030700"
                                }
                            ]
                        },
                        {
                            "省": "上海",
                            "市": [
                                {
                                    "市名": "上海",
                                    "编码": "101020100"
                                },
                                {
                                    "市名": "宝山",
                                    "编码": "101020300"
                                },
                                {
                                    "市名": "嘉定",
                                    "编码": "101020500"
                                },
                                {
                                    "市名": "南汇",
                                    "编码": "101020600"
                                },
                                {
                                    "市名": "浦东",
                                    "编码": "101021300"
                                },
                                {
                                    "市名": "青浦",
                                    "编码": "101020800"
                                },
                                {
                                    "市名": "松江",
                                    "编码": "101020900"
                                },
                                {
                                    "市名": "奉贤",
                                    "编码": "101021000"
                                },
                                {
                                    "市名": "崇明",
                                    "编码": "101021100"
                                },
                                {
                                    "市名": "徐家汇",
                                    "编码": "101021200"
                                },
                                {
                                    "市名": "闵行",
                                    "编码": "101020200"
                                },
                                {
                                    "市名": "金山",
                                    "编码": "101020700"
                                }
                            ]
                        },
                        {
                            "省": "河北",
                            "市": [
                                {
                                    "市名": "石家庄",
                                    "编码": "101090101"
                                },
                                {
                                    "市名": "张家口",
                                    "编码": "101090301"
                                },
                                {
                                    "市名": "承德",
                                    "编码": "101090402"
                                },
                                {
                                    "市名": "唐山",
                                    "编码": "101090501"
                                },
                                {
                                    "市名": "秦皇岛",
                                    "编码": "101091101"
                                },
                                {
                                    "市名": "沧州",
                                    "编码": "101090701"
                                },
                                {
                                    "市名": "衡水",
                                    "编码": "101090801"
                                },
                                {
                                    "市名": "邢台",
                                    "编码": "101090901"
                                },
                                {
                                    "市名": "邯郸",
                                    "编码": "101091001"
                                },
                                {
                                    "市名": "保定",
                                    "编码": "101090201"
                                },
                                {
                                    "市名": "廊坊",
                                    "编码": "101090601"
                                }
                            ]
                        },
                        {
                            "省": "河南",
                            "市": [
                                {
                                    "市名": "郑州",
                                    "编码": "101180101"
                                },
                                {
                                    "市名": "新乡",
                                    "编码": "101180301"
                                },
                                {
                                    "市名": "许昌",
                                    "编码": "101180401"
                                },
                                {
                                    "市名": "平顶山",
                                    "编码": "101180501"
                                },
                                {
                                    "市名": "信阳",
                                    "编码": "101180601"
                                },
                                {
                                    "市名": "南阳",
                                    "编码": "101180701"
                                },
                                {
                                    "市名": "开封",
                                    "编码": "101180801"
                                },
                                {
                                    "市名": "洛阳",
                                    "编码": "101180901"
                                },
                                {
                                    "市名": "商丘",
                                    "编码": "101181001"
                                },
                                {
                                    "市名": "焦作",
                                    "编码": "101181101"
                                },
                                {
                                    "市名": "鹤壁",
                                    "编码": "101181201"
                                },
                                {
                                    "市名": "濮阳",
                                    "编码": "101181301"
                                },
                                {
                                    "市名": "周口",
                                    "编码": "101181401"
                                },
                                {
                                    "市名": "漯河",
                                    "编码": "101181501"
                                },
                                {
                                    "市名": "驻马店",
                                    "编码": "101181601"
                                },
                                {
                                    "市名": "三门峡",
                                    "编码": "101181701"
                                },
                                {
                                    "市名": "济源",
                                    "编码": "101181801"
                                },
                                {
                                    "市名": "安阳",
                                    "编码": "101180201"
                                }
                            ]
                        },
                        {
                            "省": "安徽",
                            "市": [
                                {
                                    "市名": "合肥",
                                    "编码": "101220101"
                                },
                                {
                                    "市名": "芜湖",
                                    "编码": "101220301"
                                },
                                {
                                    "市名": "淮南",
                                    "编码": "101220401"
                                },
                                {
                                    "市名": "马鞍山",
                                    "编码": "101220501"
                                },
                                {
                                    "市名": "安庆",
                                    "编码": "101220601"
                                },
                                {
                                    "市名": "宿州",
                                    "编码": "101220701"
                                },
                                {
                                    "市名": "阜阳",
                                    "编码": "101220801"
                                },
                                {
                                    "市名": "亳州",
                                    "编码": "101220901"
                                },
                                {
                                    "市名": "黄山",
                                    "编码": "101221001"
                                },
                                {
                                    "市名": "滁州",
                                    "编码": "101221101"
                                },
                                {
                                    "市名": "淮北",
                                    "编码": "101221201"
                                },
                                {
                                    "市名": "铜陵",
                                    "编码": "101221301"
                                },
                                {
                                    "市名": "宣城",
                                    "编码": "101221401"
                                },
                                {
                                    "市名": "六安",
                                    "编码": "101221501"
                                },
                                {
                                    "市名": "巢湖",
                                    "编码": "101221601"
                                },
                                {
                                    "市名": "池州",
                                    "编码": "101221701"
                                },
                                {
                                    "市名": "蚌埠",
                                    "编码": "101220201"
                                }
                            ]
                        },
                        {
                            "省": "浙江",
                            "市": [
                                {
                                    "市名": "杭州",
                                    "编码": "101210101"
                                },
                                {
                                    "市名": "舟山",
                                    "编码": "101211101"
                                },
                                {
                                    "市名": "湖州",
                                    "编码": "101210201"
                                },
                                {
                                    "市名": "嘉兴",
                                    "编码": "101210301"
                                },
                                {
                                    "市名": "金华",
                                    "编码": "101210901"
                                },
                                {
                                    "市名": "绍兴",
                                    "编码": "101210501"
                                },
                                {
                                    "市名": "台州",
                                    "编码": "101210601"
                                },
                                {
                                    "市名": "温州",
                                    "编码": "101210701"
                                },
                                {
                                    "市名": "丽水",
                                    "编码": "101210801"
                                },
                                {
                                    "市名": "衢州",
                                    "编码": "101211001"
                                },
                                {
                                    "市名": "宁波",
                                    "编码": "101210401"
                                }
                            ]
                        },
                        {
                            "省": "重庆",
                            "市": [
                                {
                                    "市名": "重庆",
                                    "编码": "101040100"
                                },
                                {
                                    "市名": "合川",
                                    "编码": "101040300"
                                },
                                {
                                    "市名": "南川",
                                    "编码": "101040400"
                                },
                                {
                                    "市名": "江津",
                                    "编码": "101040500"
                                },
                                {
                                    "市名": "万盛",
                                    "编码": "101040600"
                                },
                                {
                                    "市名": "渝北",
                                    "编码": "101040700"
                                },
                                {
                                    "市名": "北碚",
                                    "编码": "101040800"
                                },
                                {
                                    "市名": "巴南",
                                    "编码": "101040900"
                                },
                                {
                                    "市名": "长寿",
                                    "编码": "101041000"
                                },
                                {
                                    "市名": "黔江",
                                    "编码": "101041100"
                                },
                                {
                                    "市名": "万州天城",
                                    "编码": "101041200"
                                },
                                {
                                    "市名": "万州龙宝",
                                    "编码": "101041300"
                                },
                                {
                                    "市名": "涪陵",
                                    "编码": "101041400"
                                },
                                {
                                    "市名": "开县",
                                    "编码": "101041500"
                                },
                                {
                                    "市名": "城口",
                                    "编码": "101041600"
                                },
                                {
                                    "市名": "云阳",
                                    "编码": "101041700"
                                },
                                {
                                    "市名": "巫溪",
                                    "编码": "101041800"
                                },
                                {
                                    "市名": "奉节",
                                    "编码": "101041900"
                                },
                                {
                                    "市名": "巫山",
                                    "编码": "101042000"
                                },
                                {
                                    "市名": "潼南",
                                    "编码": "101042100"
                                },
                                {
                                    "市名": "垫江",
                                    "编码": "101042200"
                                },
                                {
                                    "市名": "梁平",
                                    "编码": "101042300"
                                },
                                {
                                    "市名": "忠县",
                                    "编码": "101042400"
                                },
                                {
                                    "市名": "石柱",
                                    "编码": "101042500"
                                },
                                {
                                    "市名": "大足",
                                    "编码": "101042600"
                                },
                                {
                                    "市名": "荣昌",
                                    "编码": "101042700"
                                },
                                {
                                    "市名": "铜梁",
                                    "编码": "101042800"
                                },
                                {
                                    "市名": "璧山",
                                    "编码": "101042900"
                                },
                                {
                                    "市名": "丰都",
                                    "编码": "101043000"
                                },
                                {
                                    "市名": "武隆",
                                    "编码": "101043100"
                                },
                                {
                                    "市名": "彭水",
                                    "编码": "101043200"
                                },
                                {
                                    "市名": "綦江",
                                    "编码": "101043300"
                                },
                                {
                                    "市名": "酉阳",
                                    "编码": "101043400"
                                },
                                {
                                    "市名": "秀山",
                                    "编码": "101043600"
                                },
                                {
                                    "市名": "沙坪坝",
                                    "编码": "101043700"
                                },
                                {
                                    "市名": "永川",
                                    "编码": "101040200"
                                }
                            ]
                        },
                        {
                            "省": "福建",
                            "市": [
                                {
                                    "市名": "福州",
                                    "编码": "101230101"
                                },
                                {
                                    "市名": "泉州",
                                    "编码": "101230501"
                                },
                                {
                                    "市名": "漳州",
                                    "编码": "101230601"
                                },
                                {
                                    "市名": "龙岩",
                                    "编码": "101230701"
                                },
                                {
                                    "市名": "晋江",
                                    "编码": "101230509"
                                },
                                {
                                    "市名": "南平",
                                    "编码": "101230901"
                                },
                                {
                                    "市名": "厦门",
                                    "编码": "101230201"
                                },
                                {
                                    "市名": "宁德",
                                    "编码": "101230301"
                                },
                                {
                                    "市名": "莆田",
                                    "编码": "101230401"
                                },
                                {
                                    "市名": "三明",
                                    "编码": "101230801"
                                }
                            ]
                        },
                        {
                            "省": "甘肃",
                            "市": [
                                {
                                    "市名": "兰州",
                                    "编码": "101160101"
                                },
                                {
                                    "市名": "平凉",
                                    "编码": "101160301"
                                },
                                {
                                    "市名": "庆阳",
                                    "编码": "101160401"
                                },
                                {
                                    "市名": "武威",
                                    "编码": "101160501"
                                },
                                {
                                    "市名": "金昌",
                                    "编码": "101160601"
                                },
                                {
                                    "市名": "嘉峪关",
                                    "编码": "101161401"
                                },
                                {
                                    "市名": "酒泉",
                                    "编码": "101160801"
                                },
                                {
                                    "市名": "天水",
                                    "编码": "101160901"
                                },
                                {
                                    "市名": "武都",
                                    "编码": "101161001"
                                },
                                {
                                    "市名": "临夏",
                                    "编码": "101161101"
                                },
                                {
                                    "市名": "合作",
                                    "编码": "101161201"
                                },
                                {
                                    "市名": "白银",
                                    "编码": "101161301"
                                },
                                {
                                    "市名": "定西",
                                    "编码": "101160201"
                                },
                                {
                                    "市名": "张掖",
                                    "编码": "101160701"
                                }
                            ]
                        },
                        {
                            "省": "广东",
                            "市": [
                                {
                                    "市名": "广州",
                                    "编码": "101280101"
                                },
                                {
                                    "市名": "惠州",
                                    "编码": "101280301"
                                },
                                {
                                    "市名": "梅州",
                                    "编码": "101280401"
                                },
                                {
                                    "市名": "汕头",
                                    "编码": "101280501"
                                },
                                {
                                    "市名": "深圳",
                                    "编码": "101280601"
                                },
                                {
                                    "市名": "珠海",
                                    "编码": "101280701"
                                },
                                {
                                    "市名": "佛山",
                                    "编码": "101280800"
                                },
                                {
                                    "市名": "肇庆",
                                    "编码": "101280901"
                                },
                                {
                                    "市名": "湛江",
                                    "编码": "101281001"
                                },
                                {
                                    "市名": "江门",
                                    "编码": "101281101"
                                },
                                {
                                    "市名": "河源",
                                    "编码": "101281201"
                                },
                                {
                                    "市名": "清远",
                                    "编码": "101281301"
                                },
                                {
                                    "市名": "云浮",
                                    "编码": "101281401"
                                },
                                {
                                    "市名": "潮州",
                                    "编码": "101281501"
                                },
                                {
                                    "市名": "东莞",
                                    "编码": "101281601"
                                },
                                {
                                    "市名": "中山",
                                    "编码": "101281701"
                                },
                                {
                                    "市名": "阳江",
                                    "编码": "101281801"
                                },
                                {
                                    "市名": "揭阳",
                                    "编码": "101281901"
                                },
                                {
                                    "市名": "茂名",
                                    "编码": "101282001"
                                },
                                {
                                    "市名": "汕尾",
                                    "编码": "101282101"
                                },
                                {
                                    "市名": "韶关",
                                    "编码": "101280201"
                                }
                            ]
                        },
                        {
                            "省": "广西",
                            "市": [
                                {
                                    "市名": "南宁",
                                    "编码": "101300101"
                                },
                                {
                                    "市名": "柳州",
                                    "编码": "101300301"
                                },
                                {
                                    "市名": "来宾",
                                    "编码": "101300401"
                                },
                                {
                                    "市名": "桂林",
                                    "编码": "101300501"
                                },
                                {
                                    "市名": "梧州",
                                    "编码": "101300601"
                                },
                                {
                                    "市名": "防城港",
                                    "编码": "101301401"
                                },
                                {
                                    "市名": "贵港",
                                    "编码": "101300801"
                                },
                                {
                                    "市名": "玉林",
                                    "编码": "101300901"
                                },
                                {
                                    "市名": "百色",
                                    "编码": "101301001"
                                },
                                {
                                    "市名": "钦州",
                                    "编码": "101301101"
                                },
                                {
                                    "市名": "河池",
                                    "编码": "101301201"
                                },
                                {
                                    "市名": "北海",
                                    "编码": "101301301"
                                },
                                {
                                    "市名": "崇左",
                                    "编码": "101300201"
                                },
                                {
                                    "市名": "贺州",
                                    "编码": "101300701"
                                }
                            ]
                        },
                        {
                            "省": "贵州",
                            "市": [
                                {
                                    "市名": "贵阳",
                                    "编码": "101260101"
                                },
                                {
                                    "市名": "安顺",
                                    "编码": "101260301"
                                },
                                {
                                    "市名": "都匀",
                                    "编码": "101260401"
                                },
                                {
                                    "市名": "兴义",
                                    "编码": "101260906"
                                },
                                {
                                    "市名": "铜仁",
                                    "编码": "101260601"
                                },
                                {
                                    "市名": "毕节",
                                    "编码": "101260701"
                                },
                                {
                                    "市名": "六盘水",
                                    "编码": "101260801"
                                },
                                {
                                    "市名": "遵义",
                                    "编码": "101260201"
                                },
                                {
                                    "市名": "凯里",
                                    "编码": "101260501"
                                }
                            ]
                        },
                        {
                            "省": "云南",
                            "市": [
                                {
                                    "市名": "昆明",
                                    "编码": "101290101"
                                },
                                {
                                    "市名": "红河",
                                    "编码": "101290301"
                                },
                                {
                                    "市名": "文山",
                                    "编码": "101290601"
                                },
                                {
                                    "市名": "玉溪",
                                    "编码": "101290701"
                                },
                                {
                                    "市名": "楚雄",
                                    "编码": "101290801"
                                },
                                {
                                    "市名": "普洱",
                                    "编码": "101290901"
                                },
                                {
                                    "市名": "昭通",
                                    "编码": "101291001"
                                },
                                {
                                    "市名": "临沧",
                                    "编码": "101291101"
                                },
                                {
                                    "市名": "怒江",
                                    "编码": "101291201"
                                },
                                {
                                    "市名": "香格里拉",
                                    "编码": "101291301"
                                },
                                {
                                    "市名": "丽江",
                                    "编码": "101291401"
                                },
                                {
                                    "市名": "德宏",
                                    "编码": "101291501"
                                },
                                {
                                    "市名": "景洪",
                                    "编码": "101291601"
                                },
                                {
                                    "市名": "大理",
                                    "编码": "101290201"
                                },
                                {
                                    "市名": "曲靖",
                                    "编码": "101290401"
                                },
                                {
                                    "市名": "保山",
                                    "编码": "101290501"
                                }
                            ]
                        },
                        {
                            "省": "内蒙古",
                            "市": [
                                {
                                    "市名": "呼和浩特",
                                    "编码": "101080101"
                                },
                                {
                                    "市名": "乌海",
                                    "编码": "101080301"
                                },
                                {
                                    "市名": "集宁",
                                    "编码": "101080401"
                                },
                                {
                                    "市名": "通辽",
                                    "编码": "101080501"
                                },
                                {
                                    "市名": "阿拉善左旗",
                                    "编码": "101081201"
                                },
                                {
                                    "市名": "鄂尔多斯",
                                    "编码": "101080701"
                                },
                                {
                                    "市名": "临河",
                                    "编码": "101080801"
                                },
                                {
                                    "市名": "锡林浩特",
                                    "编码": "101080901"
                                },
                                {
                                    "市名": "呼伦贝尔",
                                    "编码": "101081000"
                                },
                                {
                                    "市名": "乌兰浩特",
                                    "编码": "101081101"
                                },
                                {
                                    "市名": "包头",
                                    "编码": "101080201"
                                },
                                {
                                    "市名": "赤峰",
                                    "编码": "101080601"
                                }
                            ]
                        },
                        {
                            "省": "江西",
                            "市": [
                                {
                                    "市名": "南昌",
                                    "编码": "101240101"
                                },
                                {
                                    "市名": "上饶",
                                    "编码": "101240301"
                                },
                                {
                                    "市名": "抚州",
                                    "编码": "101240401"
                                },
                                {
                                    "市名": "宜春",
                                    "编码": "101240501"
                                },
                                {
                                    "市名": "鹰潭",
                                    "编码": "101241101"
                                },
                                {
                                    "市名": "赣州",
                                    "编码": "101240701"
                                },
                                {
                                    "市名": "景德镇",
                                    "编码": "101240801"
                                },
                                {
                                    "市名": "萍乡",
                                    "编码": "101240901"
                                },
                                {
                                    "市名": "新余",
                                    "编码": "101241001"
                                },
                                {
                                    "市名": "九江",
                                    "编码": "101240201"
                                },
                                {
                                    "市名": "吉安",
                                    "编码": "101240601"
                                }
                            ]
                        },
                        {
                            "省": "湖北",
                            "市": [
                                {
                                    "市名": "武汉",
                                    "编码": "101200101"
                                },
                                {
                                    "市名": "黄冈",
                                    "编码": "101200501"
                                },
                                {
                                    "市名": "荆州",
                                    "编码": "101200801"
                                },
                                {
                                    "市名": "宜昌",
                                    "编码": "101200901"
                                },
                                {
                                    "市名": "恩施",
                                    "编码": "101201001"
                                },
                                {
                                    "市名": "十堰",
                                    "编码": "101201101"
                                },
                                {
                                    "市名": "神农架",
                                    "编码": "101201201"
                                },
                                {
                                    "市名": "随州",
                                    "编码": "101201301"
                                },
                                {
                                    "市名": "荆门",
                                    "编码": "101201401"
                                },
                                {
                                    "市名": "天门",
                                    "编码": "101201501"
                                },
                                {
                                    "市名": "仙桃",
                                    "编码": "101201601"
                                },
                                {
                                    "市名": "潜江",
                                    "编码": "101201701"
                                },
                                {
                                    "市名": "襄樊",
                                    "编码": "101200201"
                                },
                                {
                                    "市名": "鄂州",
                                    "编码": "101200301"
                                },
                                {
                                    "市名": "孝感",
                                    "编码": "101200401"
                                },
                                {
                                    "市名": "黄石",
                                    "编码": "101200601"
                                },
                                {
                                    "市名": "咸宁",
                                    "编码": "101200701"
                                }
                            ]
                        },
                        {
                            "省": "四川",
                            "市": [
                                {
                                    "市名": "成都",
                                    "编码": "101270101"
                                },
                                {
                                    "市名": "自贡",
                                    "编码": "101270301"
                                },
                                {
                                    "市名": "绵阳",
                                    "编码": "101270401"
                                },
                                {
                                    "市名": "南充",
                                    "编码": "101270501"
                                },
                                {
                                    "市名": "达州",
                                    "编码": "101270601"
                                },
                                {
                                    "市名": "遂宁",
                                    "编码": "101270701"
                                },
                                {
                                    "市名": "广安",
                                    "编码": "101270801"
                                },
                                {
                                    "市名": "巴中",
                                    "编码": "101270901"
                                },
                                {
                                    "市名": "泸州",
                                    "编码": "101271001"
                                },
                                {
                                    "市名": "宜宾",
                                    "编码": "101271101"
                                },
                                {
                                    "市名": "内江",
                                    "编码": "101271201"
                                },
                                {
                                    "市名": "资阳",
                                    "编码": "101271301"
                                },
                                {
                                    "市名": "乐山",
                                    "编码": "101271401"
                                },
                                {
                                    "市名": "眉山",
                                    "编码": "101271501"
                                },
                                {
                                    "市名": "凉山",
                                    "编码": "101271601"
                                },
                                {
                                    "市名": "雅安",
                                    "编码": "101271701"
                                },
                                {
                                    "市名": "甘孜",
                                    "编码": "101271801"
                                },
                                {
                                    "市名": "阿坝",
                                    "编码": "101271901"
                                },
                                {
                                    "市名": "德阳",
                                    "编码": "101272001"
                                },
                                {
                                    "市名": "广元",
                                    "编码": "101272101"
                                },
                                {
                                    "市名": "攀枝花",
                                    "编码": "101270201"
                                }
                            ]
                        },
                        {
                            "省": "宁夏",
                            "市": [
                                {
                                    "市名": "银川",
                                    "编码": "101170101"
                                },
                                {
                                    "市名": "中卫",
                                    "编码": "101170501"
                                },
                                {
                                    "市名": "固原",
                                    "编码": "101170401"
                                },
                                {
                                    "市名": "石嘴山",
                                    "编码": "101170201"
                                },
                                {
                                    "市名": "吴忠",
                                    "编码": "101170301"
                                }
                            ]
                        },
                        {
                            "省": "青海省",
                            "市": [
                                {
                                    "市名": "西宁",
                                    "编码": "101150101"
                                },
                                {
                                    "市名": "黄南",
                                    "编码": "101150301"
                                },
                                {
                                    "市名": "海北",
                                    "编码": "101150801"
                                },
                                {
                                    "市名": "果洛",
                                    "编码": "101150501"
                                },
                                {
                                    "市名": "玉树",
                                    "编码": "101150601"
                                },
                                {
                                    "市名": "海西",
                                    "编码": "101150701"
                                },
                                {
                                    "市名": "海东",
                                    "编码": "101150201"
                                },
                                {
                                    "市名": "海南",
                                    "编码": "101150401"
                                }
                            ]
                        },
                        {
                            "省": "山东",
                            "市": [
                                {
                                    "市名": "济南",
                                    "编码": "101120101"
                                },
                                {
                                    "市名": "潍坊",
                                    "编码": "101120601"
                                },
                                {
                                    "市名": "临沂",
                                    "编码": "101120901"
                                },
                                {
                                    "市名": "菏泽",
                                    "编码": "101121001"
                                },
                                {
                                    "市名": "滨州",
                                    "编码": "101121101"
                                },
                                {
                                    "市名": "东营",
                                    "编码": "101121201"
                                },
                                {
                                    "市名": "威海",
                                    "编码": "101121301"
                                },
                                {
                                    "市名": "枣庄",
                                    "编码": "101121401"
                                },
                                {
                                    "市名": "日照",
                                    "编码": "101121501"
                                },
                                {
                                    "市名": "莱芜",
                                    "编码": "101121601"
                                },
                                {
                                    "市名": "聊城",
                                    "编码": "101121701"
                                },
                                {
                                    "市名": "青岛",
                                    "编码": "101120201"
                                },
                                {
                                    "市名": "淄博",
                                    "编码": "101120301"
                                },
                                {
                                    "市名": "德州",
                                    "编码": "101120401"
                                },
                                {
                                    "市名": "烟台",
                                    "编码": "101120501"
                                },
                                {
                                    "市名": "济宁",
                                    "编码": "101120701"
                                },
                                {
                                    "市名": "泰安",
                                    "编码": "101120801"
                                }
                            ]
                        },
                        {
                            "省": "陕西省",
                            "市": [
                                {
                                    "市名": "西安",
                                    "编码": "101110101"
                                },
                                {
                                    "市名": "延安",
                                    "编码": "101110300"
                                },
                                {
                                    "市名": "榆林",
                                    "编码": "101110401"
                                },
                                {
                                    "市名": "铜川",
                                    "编码": "101111001"
                                },
                                {
                                    "市名": "商洛",
                                    "编码": "101110601"
                                },
                                {
                                    "市名": "安康",
                                    "编码": "101110701"
                                },
                                {
                                    "市名": "汉中",
                                    "编码": "101110801"
                                },
                                {
                                    "市名": "宝鸡",
                                    "编码": "101110901"
                                },
                                {
                                    "市名": "咸阳",
                                    "编码": "101110200"
                                },
                                {
                                    "市名": "渭南",
                                    "编码": "101110501"
                                }
                            ]
                        },
                        {
                            "省": "山西",
                            "市": [
                                {
                                    "市名": "太原",
                                    "编码": "101100101"
                                },
                                {
                                    "市名": "临汾",
                                    "编码": "101100701"
                                },
                                {
                                    "市名": "运城",
                                    "编码": "101100801"
                                },
                                {
                                    "市名": "朔州",
                                    "编码": "101100901"
                                },
                                {
                                    "市名": "忻州",
                                    "编码": "101101001"
                                },
                                {
                                    "市名": "长治",
                                    "编码": "101100501"
                                },
                                {
                                    "市名": "大同",
                                    "编码": "101100201"
                                },
                                {
                                    "市名": "阳泉",
                                    "编码": "101100301"
                                },
                                {
                                    "市名": "晋中",
                                    "编码": "101100401"
                                },
                                {
                                    "市名": "晋城",
                                    "编码": "101100601"
                                },
                                {
                                    "市名": "吕梁",
                                    "编码": "101101100"
                                }
                            ]
                        },
                        {
                            "省": "新疆",
                            "市": [
                                {
                                    "市名": "乌鲁木齐",
                                    "编码": "101130101"
                                },
                                {
                                    "市名": "石河子",
                                    "编码": "101130301"
                                },
                                {
                                    "市名": "昌吉",
                                    "编码": "101130401"
                                },
                                {
                                    "市名": "吐鲁番",
                                    "编码": "101130501"
                                },
                                {
                                    "市名": "库尔勒",
                                    "编码": "101130601"
                                },
                                {
                                    "市名": "阿拉尔",
                                    "编码": "101130701"
                                },
                                {
                                    "市名": "阿克苏",
                                    "编码": "101130801"
                                },
                                {
                                    "市名": "喀什",
                                    "编码": "101130901"
                                },
                                {
                                    "市名": "伊宁",
                                    "编码": "101131001"
                                },
                                {
                                    "市名": "塔城",
                                    "编码": "101131101"
                                },
                                {
                                    "市名": "哈密",
                                    "编码": "101131201"
                                },
                                {
                                    "市名": "和田",
                                    "编码": "101131301"
                                },
                                {
                                    "市名": "阿勒泰",
                                    "编码": "101131401"
                                },
                                {
                                    "市名": "阿图什",
                                    "编码": "101131501"
                                },
                                {
                                    "市名": "博乐",
                                    "编码": "101131601"
                                },
                                {
                                    "市名": "克拉玛依",
                                    "编码": "101130201"
                                }
                            ]
                        },
                        {
                            "省": "西藏",
                            "市": [
                                {
                                    "市名": "拉萨",
                                    "编码": "101140101"
                                },
                                {
                                    "市名": "山南",
                                    "编码": "101140301"
                                },
                                {
                                    "市名": "阿里",
                                    "编码": "101140701"
                                },
                                {
                                    "市名": "昌都",
                                    "编码": "101140501"
                                },
                                {
                                    "市名": "那曲",
                                    "编码": "101140601"
                                },
                                {
                                    "市名": "日喀则",
                                    "编码": "101140201"
                                },
                                {
                                    "市名": "林芝",
                                    "编码": "101140401"
                                }
                            ]
                        },
                        {
                            "省": "台湾",
                            "市": [
                                {
                                    "市名": "台北县",
                                    "编码": "101340101"
                                },
                                {
                                    "市名": "高雄",
                                    "编码": "101340201"
                                },
                                {
                                    "市名": "台中",
                                    "编码": "101340401"
                                }
                            ]
                        },
                        {
                            "省": "海南省",
                            "市": [
                                {
                                    "市名": "海口",
                                    "编码": "101310101"
                                },
                                {
                                    "市名": "三亚",
                                    "编码": "101310201"
                                },
                                {
                                    "市名": "东方",
                                    "编码": "101310202"
                                },
                                {
                                    "市名": "临高",
                                    "编码": "101310203"
                                },
                                {
                                    "市名": "澄迈",
                                    "编码": "101310204"
                                },
                                {
                                    "市名": "儋州",
                                    "编码": "101310205"
                                },
                                {
                                    "市名": "昌江",
                                    "编码": "101310206"
                                },
                                {
                                    "市名": "白沙",
                                    "编码": "101310207"
                                },
                                {
                                    "市名": "琼中",
                                    "编码": "101310208"
                                },
                                {
                                    "市名": "定安",
                                    "编码": "101310209"
                                },
                                {
                                    "市名": "屯昌",
                                    "编码": "101310210"
                                },
                                {
                                    "市名": "琼海",
                                    "编码": "101310211"
                                },
                                {
                                    "市名": "文昌",
                                    "编码": "101310212"
                                },
                                {
                                    "市名": "保亭",
                                    "编码": "101310214"
                                },
                                {
                                    "市名": "万宁",
                                    "编码": "101310215"
                                },
                                {
                                    "市名": "陵水",
                                    "编码": "101310216"
                                },
                                {
                                    "市名": "西沙",
                                    "编码": "101310217"
                                },
                                {
                                    "市名": "南沙岛",
                                    "编码": "101310220"
                                },
                                {
                                    "市名": "乐东",
                                    "编码": "101310221"
                                },
                                {
                                    "市名": "五指山",
                                    "编码": "101310222"
                                },
                                {
                                    "市名": "琼山",
                                    "编码": "101310102"
                                }
                            ]
                        },
                        {
                            "省": "湖南",
                            "市": [
                                {
                                    "市名": "长沙",
                                    "编码": "101250101"
                                },
                                {
                                    "市名": "株洲",
                                    "编码": "101250301"
                                },
                                {
                                    "市名": "衡阳",
                                    "编码": "101250401"
                                },
                                {
                                    "市名": "郴州",
                                    "编码": "101250501"
                                },
                                {
                                    "市名": "常德",
                                    "编码": "101250601"
                                },
                                {
                                    "市名": "益阳",
                                    "编码": "101250700"
                                },
                                {
                                    "市名": "娄底",
                                    "编码": "101250801"
                                },
                                {
                                    "市名": "邵阳",
                                    "编码": "101250901"
                                },
                                {
                                    "市名": "岳阳",
                                    "编码": "101251001"
                                },
                                {
                                    "市名": "张家界",
                                    "编码": "101251101"
                                },
                                {
                                    "市名": "怀化",
                                    "编码": "101251201"
                                },
                                {
                                    "市名": "黔阳",
                                    "编码": "101251301"
                                },
                                {
                                    "市名": "永州",
                                    "编码": "101251401"
                                },
                                {
                                    "市名": "吉首",
                                    "编码": "101251501"
                                },
                                {
                                    "市名": "湘潭",
                                    "编码": "101250201"
                                }
                            ]
                        },
                        {
                            "省": "江苏",
                            "市": [
                                {
                                    "市名": "南京",
                                    "编码": "101190101"
                                },
                                {
                                    "市名": "镇江",
                                    "编码": "101190301"
                                },
                                {
                                    "市名": "苏州",
                                    "编码": "101190401"
                                },
                                {
                                    "市名": "南通",
                                    "编码": "101190501"
                                },
                                {
                                    "市名": "扬州",
                                    "编码": "101190601"
                                },
                                {
                                    "市名": "宿迁",
                                    "编码": "101191301"
                                },
                                {
                                    "市名": "徐州",
                                    "编码": "101190801"
                                },
                                {
                                    "市名": "淮安",
                                    "编码": "101190901"
                                },
                                {
                                    "市名": "连云港",
                                    "编码": "101191001"
                                },
                                {
                                    "市名": "常州",
                                    "编码": "101191101"
                                },
                                {
                                    "市名": "泰州",
                                    "编码": "101191201"
                                },
                                {
                                    "市名": "无锡",
                                    "编码": "101190201"
                                },
                                {
                                    "市名": "盐城",
                                    "编码": "101190701"
                                }
                            ]
                        },
                        {
                            "省": "黑龙江",
                            "市": [
                                {
                                    "市名": "哈尔滨",
                                    "编码": "101050101"
                                },
                                {
                                    "市名": "牡丹江",
                                    "编码": "101050301"
                                },
                                {
                                    "市名": "佳木斯",
                                    "编码": "101050401"
                                },
                                {
                                    "市名": "绥化",
                                    "编码": "101050501"
                                },
                                {
                                    "市名": "黑河",
                                    "编码": "101050601"
                                },
                                {
                                    "市名": "双鸭山",
                                    "编码": "101051301"
                                },
                                {
                                    "市名": "伊春",
                                    "编码": "101050801"
                                },
                                {
                                    "市名": "大庆",
                                    "编码": "101050901"
                                },
                                {
                                    "市名": "七台河",
                                    "编码": "101051002"
                                },
                                {
                                    "市名": "鸡西",
                                    "编码": "101051101"
                                },
                                {
                                    "市名": "鹤岗",
                                    "编码": "101051201"
                                },
                                {
                                    "市名": "齐齐哈尔",
                                    "编码": "101050201"
                                },
                                {
                                    "市名": "大兴安岭",
                                    "编码": "101050701"
                                }
                            ]
                        },
                        {
                            "省": "吉林",
                            "市": [
                                {
                                    "市名": "长春",
                                    "编码": "101060101"
                                },
                                {
                                    "市名": "延吉",
                                    "编码": "101060301"
                                },
                                {
                                    "市名": "四平",
                                    "编码": "101060401"
                                },
                                {
                                    "市名": "白山",
                                    "编码": "101060901"
                                },
                                {
                                    "市名": "白城",
                                    "编码": "101060601"
                                },
                                {
                                    "市名": "辽源",
                                    "编码": "101060701"
                                },
                                {
                                    "市名": "松原",
                                    "编码": "101060801"
                                },
                                {
                                    "市名": "吉林",
                                    "编码": "101060201"
                                },
                                {
                                    "市名": "通化",
                                    "编码": "101060501"
                                }
                            ]
                        },
                        {
                            "省": "辽宁",
                            "市": [
                                {
                                    "市名": "沈阳",
                                    "编码": "101070101"
                                },
                                {
                                    "市名": "鞍山",
                                    "编码": "101070301"
                                },
                                {
                                    "市名": "抚顺",
                                    "编码": "101070401"
                                },
                                {
                                    "市名": "本溪",
                                    "编码": "101070501"
                                },
                                {
                                    "市名": "丹东",
                                    "编码": "101070601"
                                },
                                {
                                    "市名": "葫芦岛",
                                    "编码": "101071401"
                                },
                                {
                                    "市名": "营口",
                                    "编码": "101070801"
                                },
                                {
                                    "市名": "阜新",
                                    "编码": "101070901"
                                },
                                {
                                    "市名": "辽阳",
                                    "编码": "101071001"
                                },
                                {
                                    "市名": "铁岭",
                                    "编码": "101071101"
                                },
                                {
                                    "市名": "朝阳",
                                    "编码": "101071201"
                                },
                                {
                                    "市名": "盘锦",
                                    "编码": "101071301"
                                },
                                {
                                    "市名": "大连",
                                    "编码": "101070201"
                                },
                                {
                                    "市名": "锦州",
                                    "编码": "101070701"
                                }
                            ]
                        }
                    ]
                }