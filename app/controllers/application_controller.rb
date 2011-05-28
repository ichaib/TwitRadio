class ApplicationController < ActionController::Base
  protect_from_forgery

	require "rubygems"
	require 'twitter'
 
  def refresh
    list = Array.new
		hashtag = "#nowplaying"
		tweets = getTweets(hashtag)
    tweets.each do |tweet|  
				  list.push(updateSong(tweet, hashtag))
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
		temp = nil
		temp = getSong(query)
		
		
			
		song.title = !temp.nil? ? temp.title : "nil title"
		song.url = !temp.nil? ? temp.permalink_url : "nil link"
		song.tweet = query
		return song
					
  end
	
	def clean(str, query)
		return str.gsub(/#\w*/,"").gsub(/@\w*/,"").gsub(/http.*/,"")
	end

	def getSongFromSoundCloud(query)
		
		client = Soundcloud.new(:client_id => 'Kym1pcyEMdeHgzYvigIwsQ')
		# get 10 hottest tracks
		tracks = client.get('/tracks', :q => query)
		return tracks[0]
	end	
end
