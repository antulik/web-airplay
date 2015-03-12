#!/usr/bin/env ruby

require_relative 'app'

require 'launchy'
Launchy.open 'http://localhost:4567'

Rack::Server.start(
  :app => Cuba,
  debug: true,
  # warn: false,
  :Port => 4567,
  # environment: 'none',
  # daemonize: true
)
