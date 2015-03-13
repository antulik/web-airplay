#!/usr/bin/env ruby

require 'rack'
require 'rack/showexceptions'

require_relative 'app'


Rack::Server.start(
  :app => Rack::ShowExceptions.new(Rack::Lint.new(Cuba.app)),
  # debug: true,
  # warn: false,
  :Port => 4567,
  # environment: 'none',
  # daemonize: true
)
