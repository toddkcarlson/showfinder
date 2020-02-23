class ShowsController < ApplicationController
  def index
  	@shows = Show.all(query)
  end

  def show
  	@show = Show.find(params[:id])
  end
end