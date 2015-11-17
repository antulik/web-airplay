class ApiV1::DevicesController < ApplicationController

  def index
    data = Mediabox.instance.devices.each_with_index.map do |device, index|
      {
        id: index,
        name: device.name,
      }
    end

    render json: data
  end

  def refresh
    Mediabox.instance.browse
    head :ok
  end

  def playback
    info = Mediabox.instance.playback_info
    play_state = Mediabox.instance.play_state

    info['playState'] = play_state

    render json: info
  end

  def pause
    Mediabox.instance.pause
    head :ok
  end

  def seek
    Mediabox.instance.seek params[:seconds]
    head :ok
  end

  def resume
    Mediabox.instance.resume
    head :ok
  end

  def play_url
    index = Mediabox.instance.default_device_index
    device = Mediabox.instance.devices[index.to_i]

    Mediabox.instance.play_on_device device, params[:url]

    render json: { message: 'ok' }
  end

end
