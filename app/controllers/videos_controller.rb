class VideosController < ApplicationController

  def index
    list = Video.all.sort_by(&:created_at).reverse

    render partial: 'videos/list', locals: { videos: list }
  end

  def create
    Video.add_to_list Video.new(:url => params[:url])

    if request.xhr?
      render
    else
      redirect_to root_path
    end
  end

end

