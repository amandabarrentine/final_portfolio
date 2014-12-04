require 'sinatra'
require 'sinatra/reloader' if development?

get "/" do
    @title = "Amanda Barrentine's Portfolio"
    @description = "This site showcases all of the awesome things that Amanda Barrentine has done."
    @home = "active"
    erb :home
end

get '/about' do
    @title = "About Me"
    @description = "This page provides a short bio for Amanda Barrentine"
    @about = "active"
    erb :about
end

get '/works' do
    @title = "My Clips"
    @description = "This page provides links to Amanda Barrentine's published clips"
    @works = "active"
    erb :works
end

get '/tweets' do
    require 'twitter'
        client = Twitter::REST::Client.new do |config|
            config.consumer_key        = "0B03jTBLxsD90BAkuTb710k7C"
            config.consumer_secret     = "rFp7ALGjr66s2USoXFufkowhhnLro7G7nf50GVdByllXH1TPoL"
            config.access_token        = "1703724636-oHBnVKaty57NyVLrYC228IxPtmfUsEaFmqYsHbj"
            config.access_token_secret = "rrb3dIWkA8o5uKQL1Pfci06QooKOFvmk2SjEbeCJ0Po5W"
        end
    
    @search_results = client.search("@merceryou", result_type: "recent").take(30).collect do |tweet|
        #"#{tweet.user.screen_name}: #{tweet.text}"
        tweet 
    end
    
    @title = "Mercer Tweets"
    @description = "This page provides links to the several wonderful tweets about Mercer University"
    @works = "active"
    erb :tweets
end

get '/news' do 
    require 'google-search'
    query =  "Mercer University"
    @results = Array.new
    Google::Search::News.new do |search|
        search.query = query
        #search.size = :large
  end.each { |item| @results.push item }
  erb :news
end

get '/insta' do
    require 'instagram'
    @title = "Mercer on Instagram"
    @description = "This page shows off Mercer on the most photogenic social media site."
    @works = "active"
    
        Instagram.configure do |config|
            config.client_id = "8ed07fbd3f7f4329a705ba8167bb00ff"
            config.client_secret = "f828ac8eabd24a9c979d6fdbcfeaf94c"
            # For secured endpoints only
            #config.client_ips = '<Comma separated list of IPs>'
        end
   
        client = Instagram.client(:access_token => session[:access_token])
        tags = client.tag_search('MercerBears')
            @photos = Array.new
        for media_item in client.tag_recent_media(tags[0].name)
            #html << "<img src='#{media_item.images.thumbnail.url}'>"
            @photos.push(media_item)
        end
    erb :insta
end