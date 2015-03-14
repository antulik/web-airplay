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



end
