#!/usr/bin/env ruby

STDOUT.write "Location: http://localhost:4567\n"

require_relative './vendor/bundle/bundler/setup'
#require 'rubygems'
#require 'bundler/setup'

$: << File.dirname(__FILE__) + "/lib"

require "airplay"
require 'sinatra'
require 'celluloid/autostart'

require 'youtuber'
require 'mediabox'

set :environment, :development
set :logging, Logger::DEBUG

module Airplay
  class << self
    def clear_browser
      @_browser = nil
    end
  end
end

module Airplay
  module Playable
    def player
      @supervisor ||= Airplay::Player.supervise self
      @_player ||= @supervisor.actors.first
    end

    def supervisor
      @supervisor
    end
  end
end

$media_box = Mediabox.new

helpers do
end

error do
  puts request.env['sinatra.error'].message
  Airplay.clear_browser
  'An error occured: ' + request.env['sinatra.error'].message
end

get '/' do
  device_names = Airplay.devices.to_a.map(&:name)

  erb :home, :locals => { :device_names => device_names }
end

post '/action' do
  #pause, resume, stop, scrub, info, seek
end

get '/backbone_info' do
  content_type :json

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
  result.to_json
end

post '/test' do
  raise URI.unescape(params[:fmt]).inspect
end

post '/play' do
  $media_box.play params[:url], params[:device_index]
  redirect to('/')
end

post '/seek' do
  seconds = params[:seconds]
  $media_box.seek seconds
end

get '/jsonp' do
  content_type "text/javascript"

  url = params[:url] || request.referrer
  if url
    $media_box.play url, 0
  end
  erb :jsonp, :layout => false
end

get %r{/img_play/(.+)} do
  content_type "image/gif"
  url = params[:captures].first

  if !url.empty?
    $media_box.play url, 0
  end

  Base64.decode64("R0lGODlhAQABAPAAAAAAAAAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==")
end
