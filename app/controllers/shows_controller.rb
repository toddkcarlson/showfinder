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

	begin
      response = Net::HTTP.get_response(uri)

      if !response.is_a?(Net::HTTPSuccess)
        raise Exception.new("Error contacting TV API")
      end

      @shows = JSON.parse(response.body)["results"]
      @shows = @shows.map! { |x| x.merge({'json_data' => x.to_json}) }
      @error = nil

    rescue Exception => ex
      @shows = []
      @error = ex.message
    end

  end

  def show
  	@show = JSON.parse(params[:data])
  end

end