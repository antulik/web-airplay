class Mediabox
  include Singleton

  attr_accessor :player

  def initialize
  end

  def default_device_index
    @default_device_index || 0
  end

  def default_device_index= device_index
    @default_device_index = device_index
  end

  def play url, device_index = default_device_index
    puts 7.chr
    url = parse_url url

    if device_index
      device_index = device_index.to_i
      device = Airplay.devices.to_a[device_index]
    else
      device = Airplay.devices.to_a.last
    end

    if url
      play_on_device device, url
    end
  end

  def play_on_device device, url

    if player && !player.alive?
      self.player = nil
    end

    if player && (player.playing? || player.loading?)
      begin
        player.stop
      rescue Exception => e
        puts e.inspect
      end
    end

    self.player = device.play url
  end

  def parse_url url
    if url.match /youtube\.com/
      Youtuber.new(url).airplay_link
    else
      url
    end
  end

  def seek seconds
    if player && player.alive?
      player.seek seconds
    end
  end

  def resume
    if player && player.alive?
      player.resume
    end
  end

  def pause
    if player && player.alive?
      player.pause
    end
  end
end
