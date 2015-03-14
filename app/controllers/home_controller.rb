class HomeController < ApplicationController

  helper_method :device_names

  BLANK_GIF = Base64.decode64("R0lGODlhAQABAPAAAAAAAAAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==")

  def show
    begin
      @device_names = Airplay.devices.to_a.map(&:name)
    rescue Airplay::Browser::NoDevicesFound
      @device_names = []
    end
  end

  def jsonp
    url ||= request.referrer
    if url
      Mediabox.instance.play url, 0
    end
    render 'jsonp'
  end

  def img_play
    Video.all << Video.new(:url => params[:url])

    render text: BLANK_GIF, type: 'image/gif'
  end

  def backbone_info
    if Mediabox.instance.player && (!Mediabox.instance.player.alive? || Mediabox.instance.player.stopped?)
      Mediabox.instance.player = nil
      Airplay.clear_browser
    end

    info = if Mediabox.instance.player
      Mediabox.instance.player.info.info
    else
      {}
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

    play_state = if Mediabox.instance.player && Mediabox.instance.player.playing?
      'playing'
    elsif Mediabox.instance.player && Mediabox.instance.player.stopped?
      'stopped'
    else
      'paused'
    end

    result = {
      :_position => info['position'].to_i,
      :_duration => info['duration'].to_i,
      :_playState => play_state
    }

    render json: result.to_json
  end

  private

  def device_names
    @device_names
  end

end
