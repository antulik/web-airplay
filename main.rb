#!/usr/bin/env ruby

# ENV['RAILS_ENV'] = 'production'
# ENV['RAILS_SERVE_STATIC_FILES'] = 'true'
# ENV['SECRET_KEY_BASE'] = '5f697c6f9beeae6d18a1a9d49fd7f4916f0212ee03500ebf9182cb36a13e33ee9f7d08d8ac6f2ead5408c079259f5a36e684fff435243998bc54f2708f82b98a'

orig_stdout = $stdout.dup # does a dup2() internally
$stdout.reopen('/dev/null', 'w')

orig_stderr = $stdout.dup # does a dup2() internally
$stderr.reopen('/dev/null', 'w')

require ::File.expand_path('../config/environment', __FILE__)

Rack::Server.start(
  :app => Rack::ShowExceptions.new(Rack::Lint.new(Rails.application)),
  # debug: true,
  # warn: false,
  :Port => 4567,
  # environment: 'none',
  # quiet: true,
  # daemonize: true
)
