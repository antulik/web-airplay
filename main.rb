#!/usr/bin/env ruby

require_relative 'app'

STDOUT.write "Location: http://localhost:4567\n"

Rack::Server.start :app => Cuba
