class VideoFetcher
  include Celluloid

  attr_reader :video, :url

  def initialize video, url
    @url = url
    @video = video
  end

  def fetch
    if url.match /youtube\.com/
      y = Youtuber.new(url)
      video.title = y.title
      video.author = y.author
      video.playback_urls = y.urls_playable_by_airplay
    else

    end

    Video.save_to_disk
  end
end
