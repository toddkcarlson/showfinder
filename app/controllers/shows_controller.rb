require "net/http"
require "uri"

class ShowsController < ApplicationController

  def index
  	url =''
  	if params.key? :search then
  		url = "http://api.themoviedb.org/3/search/tv?api_key="+ ENV['API_KEY'] + "&query=" + params[:search]
  	else	
  		url = "http://api.themoviedb.org/3/trending/tv/week?api_key="+ ENV['API_KEY']
  	end

	uri = URI.parse(url)
	response = Net::HTTP.get_response(uri)
	
	@shows = JSON.parse(response.body)["results"]
	@shows = @shows.map! { |x| x.merge({'json_data' => x.to_json}) }
  end

  def show
  	@show = JSON.parse(params[:data])
  end

end