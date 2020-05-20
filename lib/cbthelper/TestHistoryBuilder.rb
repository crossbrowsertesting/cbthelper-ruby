#Builder to generate options for getting test history
#All of the with... methods return self for method chaining

class TestHistoryBuilder
    

    def initialize
        @options = {}   
    end

    #Sets the max number of tests to return
    def withLimit(limit)
        @options["num"] = limit
        self
    end

    #If set, will only return active or inactive tests
    #@param active: boolean value
    def withActive(active)
        @options["active"] = active
        self
    end

    #Will only return tests that match the name given
    def withName(name)
        @options["name"] = name
        self
    end

    # Will only return tests that match the build given
    def withBuild(build)
        @options["build"] = build
        self
    end

    #Will only return tests that navigate to the same url
    def withUrl(url)
        @options["url"] = url
        self
    end

    #Will only return tests with the score specified ('pass', 'fail', 'unset')
    def withScore(score)
        @options["score"] = score
        self
    end

    #Will only return tests with the same platform (OS)
    #@param platform: string with the platform (eg. 'Windows 10', 'Mac OS 10.13')
    def withPlatform(platform)
        @options["platform"] = platform
        self
     end

    #Will only return tests with the same platformType (OS Family)
    #@param platformType: string with the platform type (eg. 'Windows', 'Mac', 'Android')
    def withPlatformType(platformType)
        @options["platformType"] = platformType
        self
    end 

    #Will only return tests that used the same browser
    #@param browser: a string with the browser name and version: (eg. Chrome 65)
    def withBrowser(browser)
        @options["browser"] = browser
        self
    end

    #Will only return tests that used the same browser type
    #@param browserType: a string representing the browser family (eg. 'Chrome', 'Edge', 'Safari')

    def withBrowserType(browserType)
        @options["browserType"] = browserType
        self
    end

    #Will only return tests that used the same resolution
    #@param resolution: a string with the form 'WIDTHxHEIGHT' (eg. '1024x768')
    def withResolution(resolution)
        @options["resolution"]= resolution
        self
    end

    def withStartDate(startDate)
        @options["startDate"] = startDate
        self
    end

    def withEndDate(endDate)
        @options["endDate"] = endDate
        self
    end

    #Generates the test history options
    #@return : a ruby hash to pass to getTestHistory()
    def build
        return @options
    end
    
end

