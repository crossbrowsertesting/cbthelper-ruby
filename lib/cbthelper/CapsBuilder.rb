require_relative "../cbthelper.rb"
require "rest-client"
require "json"


#Builder for generating selenium capabilities
#All of the with... methods return self for method chaining
class CapsBuilder
    

    def initialize
        @capsData = JSON.parse(RestClient.get("https://crossbrowsertesting.com/api/v3/selenium/browsers"))
        @platform = nil
        @browser = nil
        @width = nil
        @height = nil
        @name = nil
        @version = nil
        @recordVideo = nil
        @recordNetwork = nil
    end

    #Sets the platform (OS) the user wants to use. The string will be compared against the 'name' and 'api_name' properties returned from the selenium api.
    #@param platform: a string specifying the platform (eg. Windows 7, Mac 10.13)
    def withPlatform(platform)
        @platform = platform
        self
    end

    #Sets the browser the user wants to use. The string will be compared against the 'name' and 'api_name' properties returned from the selenium api.
    #@param browser: as string specifying the browser (eg. Edge 17, Chrome 55x64)
    def withBrowserApiName(browser)
        @browser = browser
        self
    end
    
    #Sets the screen size for the test
    def withResolution(width, height)
        @width = width
        @height = height
        self
    end

    #Sets the name of the test in the web app
    def withName(name)
        @name = name
        self
    end
    
    #Sets the build number in the web app
    def withBuild(build)
        @version = build
        self
    end 

    #Records a video for the length of the test
    def withRecordVideo(bool)
        @recordVideo = bool
        self
    end

    #Records network traffic for the length of the test
    def withRecordNetwork(bool)
        @recordNetwork = bool
        self
    end

    #Used to generate the capabilites using any options the user specifies
    def build
        return choose
    end

    #Determines the best platform based on user input :param target
    def bestOption(options, target)
        if target != nil
            target =target.downcase
        end
        
        for option in options
            name = option['name'].downcase
            apiName = option['name'].downcase
            if target == name or target == apiName
                return option
            end
        end
        return nil
    end

    #Determines the best platform based on user input :param target when no platform provided
    def bestBrowserNoPlatform(target)
        target = target.downcase

        for platform in @capsData
            for browser in platform['browsers']
                name = browser['name'].downcase
                if target == name or target == apiName
                    return browser
                end
            end
        end

        return nil
    end

    private
    #Sets the capabilities passed to the WebDriver
    def choose
        data = @capsData
        caps = Selenium::WebDriver::Remote::Capabilities.new
        if @platform
            caps['platform'] = @platform
        end
        if @browser
            caps['browser_api_name'] = @browser
        end

        if @width and @height
            caps['screenResolution'] = @width.to_s + 'x' + @height.to_s
        end

        if @name
            caps['name'] = @name
        end

        if @version
            caps['build'] = @version
        end 

        if @recordVideo
            caps['record_video'] = @recordVideo
        end

        if @recordNetwork
            caps['record_network'] = @recordNetwork
        end
        return caps
    end


end
