class ApplicationController < ActionController::Base
  protect_from_forgery

	require "rubygems"
	require 'twitter'


 
  def refresh
    list = Array.new
		tweets = getTweets("#nowplaying")
    tweets.each do |tweet|  
		      query = getSong(tweet)
					url = getUrl(query)
				  list.push(updateSong(url, tweet))
		end 
    #list = tweets
		#list = Song.all
		return list

  end

  def getTweets(query)
		# Initialize a Twitter search
		search = Twitter::Search.new
		search.containing(query).result_type("recent").per_page(10)
		end
  
  def getSong(tweet)
		tweet
  end

  def getUrl(query)
		query
  end
  
  def updateSong(url, tweet)
		song = Song.new
		song.title = "Just try to figure it out for the moment"
		song.url = "will come from soundcloud"
		song.artist = "someone but not me"
		song.tweet = tweet.text
		return song			
  end
	
end
