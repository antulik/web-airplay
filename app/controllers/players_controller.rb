class PlayersController < ApplicationController

  def create
    url = params[:url]
    Mediabox.instance.play url

    if request.xhr?
      render
    else
      redirect_to root_path
    end
  end

  def current_device
    id = params[:device_id]

    Mediabox.instance.default_device_index = id.to_i

    if request.xhr?
      head :ok
    else
      redirect_to root_path
    end
  end

  def seek
    Mediabox.instance.seek params[:seconds]
    head :ok
  end

  def resume
    Mediabox.instance.resume
    head :ok
  end

  def pause
    Mediabox.instance.pause
    head :ok
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


end
