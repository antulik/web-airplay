require 'minitest/spec'
require "minitest/autorun"

require './lib/youtuber'

describe Youtuber do

  it 'runs' do
    url_hash = Youtuber.new(nil).get_urls 'RuPdJnFVPuY'

    raise url_hash.inspect
  end

  it 'extracts id' do
    obj = Youtuber.new("http://www.youtube.com/watch?v=RuPdJnFVPuY")
    obj.video_id.must_equal 'RuPdJnFVPuY'
  end
end
