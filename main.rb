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

set :environment, :development
set :logging, Logger::DEBUG

$pl = nil

class Player
	include Celluloid

	attr_accessor :player

	def play url, device
    @player = device.play url
  end

  def stop
    player.stop
  end
end


helpers do
  def parse_url url
    if url.match /youtube\.com/
      Youtuber.new(url).airplay_link
    else
      url
    end
  end

  def play url
    if $pl
      begin
        player = $pl
        player.stop
      rescue

      end

      player.terminate
    end

    url = parse_url url

    if url
      if params[:device_index]
        device_index = params[:device_index].to_i
        device = Airplay.devices.to_a[device_index]
      else
        device = Airplay.devices.to_a.last
      end

      $pl = Player.new
      #raise url.inspect
      $pl.play url, device
    end
  end
end

get '/' do
  device_names = Airplay.devices.to_a.map(&:name)

  erb :home, :locals => { :device_names => device_names }
end

post '/action' do
  #pause, resume, stop, scrub, info, seek
end

get '/info' do
  info = if $pl
    $pl.player.info.info
  else
    {}
  end

  content_type :json

  info.to_json
end

post '/test' do
  raise URI.unescape(params[:fmt]).inspect
end

post '/play' do
  play params[:url]
  redirect to('/')
end

get '/jsonp' do
  content_type "text/javascript"

  referer = request.referrer
  if referer
    play referer
  end
  erb :jsonp, :layout => false
end
