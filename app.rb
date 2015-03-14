# require 'rubygems'
# require 'bundler/setup'
# require_relative './vendor/bundle/bundler/setup'

require "cuba"
require "cuba/render"
require "erb"

require "airplay"
require 'celluloid/autostart'


$media_box = Mediabox.new

$play_queue = []

$play_queue << Video.new(url: 'http://www.youtube.com/watch?v=z5pJvhd3lFQ')

Cuba.define do

  on root do
    begin
      device_names = Airplay.devices.to_a.map(&:name)
    rescue Airplay::Browser::NoDevicesFound
      device_names = []
    end


    res.write view 'home', :device_names => device_names
  end


end
