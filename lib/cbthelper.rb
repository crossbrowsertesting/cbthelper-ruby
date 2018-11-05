require_relative "cbthelper/version"
require_relative "cbthelper/AutomatedTest"
require_relative "cbthelper/CapsBuilder"
require_relative "cbthelper/Snapshot"
require_relative "cbthelper/TestHistoryBuilder"
require_relative "cbthelper/Video"
require "rest-client"
require "json"
require "selenium-webdriver"

module Cbthelper
	#Used to get the selenium capability builder
	#Generating the CapsBuilder pulls in a large amount of data, so user should not call the constrcutor manually
	def self.getCapsBuilder
    	@@caps = CapsBuilder.new
	end

	#Sets the username and authkey used to make the HTTP requests
	def self.login(username, authkey)
    	@@username= username
    	@@authkey = authkey	
	end

	#Used to get the TestHistoryBuilder
    #Can also just call the constructor. Method created to match getCapsBuilder()
	def self.getTestHistoryBuilder
    	return TestHistoryBuilder.new
	end

	#Returns a ruby hash with the test history, filtering based on the options given.
    #@param options: a ruby hash created by the TestHistoryBuilder
	def self.getTestHistory(options)
    	return JSON.parse(RestClient.get("https://#{@@username}:#{@@authkey}@crossbrowsertesting.com/api/v3/selenium/", params: options))	
	end

	#Creates an automated test from the selenium session id
    #@param sessid: string for the seleneium session/test id. Should come from WebDriver
	def self.getTestFromId(sessid)
    	return AutomatedTest.new(sessid)
	end

	def self.username
		@@username
	end

	def self.authkey
		@@authkey
	end

	def self.caps
		@@caps
	end
end
