class ApplicationController < ActionController::Base
  protect_from_forgery

	require "rubygems"
	require 'twitter'
	require 'soundcloud'



 
  def refresh
    list = Array.new
		hashtag = "#nowplaying"
		tweets = getTweets(hashtag)
    tweets.each do |tweet|  
				  list.push(updateSong(tweet))
		end 
    #list = tweets
		#list = Song.all
		return list

  end

  def getTweets(query)
		search = Twitter::Search.new
		search.containing(query).result_type("recent").per_page(10)
		end
  
  def getSongQuery(tweet,hashtag)
		return clean(tweet,hashtag)
  end

  def getSong(query)
		getSongFromSoundCloud(query)
  end
  
  def updateSong(tweet,hashtag)
		song = Song.new
		query = getSongQuery(tweet.text,hashtag)
		temp = getSong(query)

		song.title = temp.title
		song.url = temp.permalink_url
		song.tweet = tweet.text
		return song			
  end
	
	def clean(str, query)
		return str.gsub(/#\w*/,"").gsub(/@\w*/,"").gsub(/http.*/,"")
	end

	def getSongFromSoundCloud(query)
		sc_client = Soundcloud.register
		tracks = sc_client.Track.find(:all,:params => {:order => 'hotness', :limit => 1})	
	end	
end
