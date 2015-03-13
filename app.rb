# require 'rubygems'
# require 'bundler/setup'
# require_relative './vendor/bundle/bundler/setup'

require "cuba"
require "cuba/render"
require "erb"

require "airplay"
require 'celluloid/autostart'

require_relative 'lib/airplay'
require_relative 'lib/mediabox'
require_relative 'lib/youtuber'

Cuba.use Rack::Static,
  root: "public",
  urls: ["/js", "/css", "/fonts", '/messenger']

Cuba.plugin(Cuba::Render)

$media_box = Mediabox.new

Cuba.define do

  on root do
    begin
      device_names = Airplay.devices.to_a.map(&:name)
    rescue Airplay::Browser::NoDevicesFound
      device_names = []
    end

    res.write view 'home', :device_names => device_names
  end

  on 'backbone_info' do
    if $media_box.player && (!$media_box.player.alive? || $media_box.player.stopped?)
      $media_box.player = nil
      Airplay.clear_browser
    end

    info = if $media_box.player
      $media_box.player.info.info
    else
      {}
    end

    # info
    #
    # {"duration":134.97666931152344,
    # "loadedTimeRanges":[
    #   {"duration":7.535599546,"start":32.422733787}
    # ],
    # "playbackBufferEmpty":true,
    # "playbackBufferFull":false,
    # "playbackLikelyToKeepUp":true,
    # "position":32.92290115356445,
    # "rate":1.0,
    # "readyToPlay":true,
    # "seekableTimeRanges":[
    #   {"duration":134.97666666666666,"start":0.0}
    # ]
    # }

    result = {
      :_position => info['position'].to_i,
      :_duration => info['duration'].to_i
    }
    res['Content-Type'] = 'application/json'
    res.write result.to_json
  end


  on 'jsonp', param(:url) do |url|
    res['Content-Type'] = "text/javascript"

    url ||= request.referrer
    if url
      $media_box.play url, 0
    end
    res.write partial 'jsonp'
  end

  on 'img_play/:id' do |url|
    res[ 'Content-Type' ] = "image/gif"

    if !url.empty?
      $media_box.play url, 0
    end

    res.write Base64.decode64("R0lGODlhAQABAPAAAAAAAAAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==")
  end

  on post do
    on 'action' do
      #pause, resume, stop, scrub, info, seek
    end

    on 'test' do
      raise URI.unescape(params[:fmt]).inspect
    end

    on 'play', param(:url), param(:device_index) do |url, device_index|
      $media_box.play url, device_index
      res.redirect '/'
    end

    on 'seek', param(:seconds) do |seconds|
      $media_box.seek seconds
    end
  end
end
