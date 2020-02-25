module theMovieDB
  class Shows < Base
    attr_accessor :name

    def self.random(query = {})
      response = Request.where('shows/random', query.merge({ number: MAX_LIMIT }))
      shows = response.fetch('shows', []).map { |show| Show.new(show) }
      [ shows, response[:errors] ]
    end

    def self.find(id)
      response = Request.get("/tv/{tv_id}")
      Show.new(response)
    end

  end
end