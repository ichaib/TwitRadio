class ApplicationController < ActionController::Base
  protect_from_forgery
  require "rubygems"
  require 'twitter'
  

  def refresh
    list = Array.new
    hashtag = "#nowplaying"
    tweet = getTweet(hashtag)
    if hasSong(tweet, hashtag) == true
      list.push(updateSong(tweet, hashtag)) 
    else
      refresh
    end


  end
  def getTweet(query)
		search = Twitter::Search.new
		return search.containing(query).result_type("recent").fetch.first
  end
  
  def getSongQuery(tweet,hashtag)
		return clean(tweet,hashtag)
  end

  def getSong(query)
		getSongFromSoundCloud(query)
  end
  def hasSong(tweet,hashtag)
		query = getSongQuery(tweet.text,hashtag)
		temp = getSong(query)
		!temp.nil?
  end
  def updateSong(tweet,hashtag)
    song = Song.new
    query = getSongQuery(tweet.text,hashtag)
    temp = getSong(query)
    song.title = !temp.nil? ? temp.title : ""
    song.url = !temp.nil? ? temp.permalink_url : ""
    song.tweet = query
    return song
  end
	
  def clean(str, query)
    str.gsub(/#\w*/,"").gsub(/@\w*/,"").gsub(/http.*/,"")
  end

  def getSongFromSoundCloud(query)
    client = Soundcloud.new(:client_id => 'Kym1pcyEMdeHgzYvigIwsQ')
    tracks = client.get('/tracks', :q => query)
    tracks[0]
  end	
end
