class ApplicationController < ActionController::Base
  protect_from_forgery

	require "rubygems"
	require 'twitter'


 
  def refresh
    list = Array.new
		hashtag = "#nowplaying"
		tweets = getTweets(hashtag)
    tweets.each do |tweet|  
		      query = getSong(tweet.text,hashtag)
					url = getUrl(query)
				  list.push(updateSong(url, query))
		end 
    #list = tweets
		#list = Song.all
		return list

  end

  def getTweets(query)
		search = Twitter::Search.new
		search.containing(query).result_type("recent").per_page(10)
		end
  
  def getSong(tweet,hashtag)
		return clean(tweet,hashtag)
  end

  def getUrl(query)
		query
  end
  
  def updateSong(url, tweet)
		song = Song.new
		song.title = "Just try to figure it out for the moment"
		song.url = "will come from soundcloud"
		song.artist = "someone but not me"
		song.tweet = tweet
		return song			
  end
	
	def clean(str, query)
		return str.gsub(/#\w*/,"").gsub(/@\w*/,"").gsub(/http.*/,"")
	end		
end
