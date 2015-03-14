#!/bin/bash

echo "Loading WebAirplay. Please wait..."
#echo "Location: http://localhost:4567"

(sleep 5 && open "http://localhost:4567")&

set -e

# Figure out where this script is located.
SELFDIR="`dirname \"$0\"`"
SELFDIR="`cd \"$SELFDIR\" && pwd`"

# Tell Bundler where the Gemfile and gems are.
export BUNDLE_GEMFILE="$SELFDIR/lib/vendor/Gemfile"
unset BUNDLE_IGNORE_CONFIG

cd "$SELFDIR/lib/app/"
export SECRET_KEY_BASE=5f697c6f9beeae6d18a1a9d49fd7f4916f0212ee03500ebf9182cb36a13e33ee9f7d08d8ac6f2ead5408c079259f5a36e684fff435243998bc54f2708f82b98a
export RAILS_ENV=production
export RAILS_SERVE_STATIC_FILES=true

# Run the actual app using the bundled Ruby interpreter, with Bundler activated.
exec "$SELFDIR/lib/ruby/bin/ruby" -rbundler/setup "$SELFDIR/lib/app/main.rb"
