require 'faraday'
require 'json'

class Connection
  BASE = 'https://api.themoviedb.org/3/movie/76341?api_key=fb6a1d3f38c3d97f67df6d141f936f29'

  def self.api
    Faraday.new(url: BASE) do |faraday|
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
      faraday.headers['Content-Type'] = 'application/json'
    end
  end
end