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

    # def initialize(args = {})
    #   super(args)
    #   self.ingredients = parse_ingredients(args)
    # end

    # def parse_ingredients(args = {})
    #   args.fetch("extendedIngredients", []).map { |ingredient| Ingredient.new(ingredient) }
    # end

  end
end