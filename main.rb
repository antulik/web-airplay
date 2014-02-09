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

get '/info' do
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

  info.to_json
end

post '/test' do
  raise URI.unescape(params[:fmt]).inspect
end

post '/play' do
  $media_box.play params[:url], params[:device_index]
  redirect to('/')
end

get '/jsonp' do
  content_type "text/javascript"

  referer = request.referrer
  if referer
    $media_box.play referer, 0
  end
  erb :jsonp, :layout => false
end
