class ApiV1::ItemsController < ApplicationController

  def index
    list = Video.all.sort_by(&:created_at).reverse
    render json: list
  end

  def create
    Video.add_to_list Video.new(:url => params[:url])
    head :ok
  end

  def destroy
    Video.delete_by_id params[:id]
    head :ok
  end
end
