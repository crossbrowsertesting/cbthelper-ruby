require_relative "../cbthelper.rb"
require "json"
require "rest-client"

#Represents a snapshot for selenium tests
class Snapshot
    
 
    #@param hash: the hash for this image, returned by rest api when taking a screenshot
    #@param test: an AutomatedTest object that represents a test currently running
    attr_accessor :info
    def initialize(hash, test)
        @hash = hash
        @testId = test
        getInfo
    end

    #Calls out to api to get updated info for this snapshot
    #@return : a hash object with all of the info for this Snapshot
    def getInfo
        @info = JSON.parse(RestClient.get("https://#{Cbthelper.username}:#{Cbthelper.authkey}@crossbrowsertesting.com/api/v3/selenium/#{@testId}/snapshots/#{@hash}"))
    end

    #Sets the description for this snapshot
    def setDescription(description) 
        url = "https://#{Cbthelper.username}:#{Cbthelper.authkey}@crossbrowsertesting.com/api/v3/selenium/#{@testId}/snapshots/#{@hash}"
        @info = RestClient.put(url, "description=#{description}")
      
    end

    #Downloads the snapshot to the given location
    #@param location: a string with the location and filename for the image. Should have a .png extension
    def saveSnapshot(location)
        url = getInfo["image"]
        path = File.split(location)[0]
        Dir.mkdir(path) unless Dir.exist?(path)

        #downloads the image to the given location in chunks
        File.open(location, "wb") {|f|
            block = proc { |response|
                response.read_body do |chunk|
                    f.write chunk
                end
            }
            RestClient::Request.execute(method: :get,
                                        url: url,
                                        block_response: block)
        }
    end
end
