class Video
  attr_accessor :url, :title, :author, :playback_urls
  attr_accessor :created_at

  def self.all
    @all ||= []
  end

  def self.find_by_url url
    all.detect { |video| video.url == url }
  end

  def self.add_to_list video
    if all.last && all.last.url == video.url
    else
      all << video
    end
  end

  def initialize opts = {}
    self.url = opts.fetch :url
    self.title = url

    @playback_urls = []
    VideoFetcher.new(self, url).async.fetch

    self.created_at = DateTime.now
  end

end
