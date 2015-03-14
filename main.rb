#!/usr/bin/env ruby

require ::File.expand_path('../config/environment', __FILE__)

Rack::Server.start(
  :app => Rack::ShowExceptions.new(Rack::Lint.new(Rails.application)),
  # debug: true,
  # warn: false,
  :Port => 4567,
  # environment: 'none',
  # daemonize: true
)
