require "pstore"

class Video
  attr_accessor :url, :title, :author, :playback_urls, :id
  attr_accessor :created_at

  def self.storage
    @storage ||= PStore.new("db/data.pstore")
  end

  def self.all
    @all ||= storage.transaction { storage.fetch :videos, [] }
  end

  def self.save_to_disk
    puts '+' * 50
    puts 'saving to disk'
    storage.transaction do
      storage[:videos] = all
    end
  end

  def self.find_by_url url
    all.detect { |video| video.url == url }
  end

  def self.find_by_id id
    all.detect { |video| video.id == id }
  end

  def self.add_to_list video
    if all.last && all.last.url == video.url
    else
      all << video
    end
    save_to_disk
  end

  def self.delete_by_id id
    obj = find_by_id id
    if obj
      all.delete obj
      save_to_disk
    end
  end

  def initialize opts = {}
    self.url = opts.fetch :url
    self.title = url

    @playback_urls = []
    VideoFetcher.new(self, url).async.fetch

    self.created_at = DateTime.now
    self.id = SecureRandom.urlsafe_base64
  end

end
