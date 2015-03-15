require 'airplay'

class HomeController < ApplicationController

  helper_method :device_names

  BLANK_GIF = Base64.decode64("R0lGODlhAQABAPAAAAAAAAAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==")

  def show
    @device_names = Mediabox.instance.devices.map(&:name)
  end

  def refresh_devices
    Mediabox.instance.browse
    redirect_to root_path
  end

  def version_check
    @release = Github.latest_release

    if WebAirplay::RELEASE_ID == @release.id
      head :ok
    else
      render
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

  private

  def device_names
    @device_names
  end

end
