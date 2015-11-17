class Mediabox
  include Singleton

  attr_accessor :player, :devices

  def initialize
    browse
  end

  def browse
    Airplay.browse
    self.devices = Airplay.devices.to_a.dup
  rescue Airplay::Browser::NoDevicesFound
    self.devices = []
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
    device = devices[device_index.to_i]

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

  def playback_info
    if player && (!player.alive? || player.stopped?)
      self.player = nil
      Airplay.clear_browser
    end

    # info
    #
    # {"duration":134.97666931152344,
    # "loadedTimeRanges":[
    #   {"duration":7.535599546,"start":32.422733787}
    # ],
    # "playbackBufferEmpty":true,
    # "playbackBufferFull":false,
    # "playbackLikelyToKeepUp":true,
    # "position":32.92290115356445,
    # "rate":1.0,
    # "readyToPlay":true,
    # "seekableTimeRanges":[
    #   {"duration":134.97666666666666,"start":0.0}
    # ]
    # }

    if player
      player.info.info
    else
      {}
    end
  end

  def play_state
    if player && player.playing?
      'playing'
    elsif player && player.stopped?
      'stopped'
    else
      'paused'
    end
  end
end
