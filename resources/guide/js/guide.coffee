 


class Guide

    constructor:->
        echo "Guide"
        
        document.body.style.height = screen.height
        document.body.style.width = screen.width
        echo screen.width + "*" + screen.height

        guide = new PageContainer("guide")
        document.body.appendChild(guide.element)

        #welcome_page = new Welcome("welcome_page")
        #guide.add_page(welcome_page)

        #start_page = new Start("start_page")
        #guide.add_page(start_page)

        launcherLaunch_page = new LauncherLaunch("launcherLaunch_page")
        guide.add_page(launcherLaunch_page)



new Guide()