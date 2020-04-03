require 'test_helper'
require 'cgi'

def mock_tv_api(params)
    params[:qstring] = params[:qstring] || ''
    params[:status] = params[:status] || 200

     url = "http://api.themoviedb.org/3" + params[:path] +
           "?api_key=" + ENV['API_KEY'] + params[:qstring]

     WebMock.stub_request(:get, url).
         to_return(status: params[:status], body: params[:body].to_json)
end

class ShowsControllerTest < ActionDispatch::IntegrationTest

       @@got = {
            "original_name" => "Game of Thrones",
            "vote_average" => 10,
            "poster_path" => "path/to/some_image.jpg",
            "backdrop_path" => "path/to/some_image.jpg",            
            "overview" => "A TV series."            
        }

        @@ad = {
            "original_name" => "Arrested Development",
            "vote_average" => 10,
            "backdrop_path" => "path/to/some_image.jpg",            
            "overview" => "A TV series."               
        }

        @@results = [@@got, @@ad]

    def test_main_page_error

        mock_tv_api({
            path: '/trending/tv/week',
            status: 500
            })

      get "/"
      assert_response :success
      assert_match "Error contacting TV API", response.body
    end

    def test_main_page

        mock_tv_api({
            path: '/trending/tv/week',
            body: {"results" => @@results}})

      get "/"
      assert_response :success

      @@results.each do |r|
          # Names of the shows should appear:
          assert_match r["original_name"], response.body

          # Links should contain correct data:
          assert_match '/shows?data=' + CGI::escape(r.to_json), response.body
      end

      # Rating of the show appear:
      assert_match "User Rating: #{@@got["vote_average"]}", response.body

      # Poster url should appear:
      assert_match @@got["poster_path"], response.body

      # Default image should appear for show without poster_path:
      assert_match 'class="poster_default"', response.body
    end

    def test_search
    	search = "Thrones"

        mock_tv_api({
            path: '/search/tv',
            qstring: "&query=" + search,
            body: {"results" => @@results}})

      get "/?search=" + search
      assert_response :success

      @@results.each do |r|
          # Names of the shows should appear:
          assert_match r["original_name"], response.body

          # Links should contain correct data:
          assert_match '/shows?data=' + CGI::escape(r.to_json), response.body
      end

      # Rating of the show appear:
      assert_match "User Rating: #{@@got["vote_average"]}", response.body

      # Poster url should appear:
      assert_match @@got["poster_path"], response.body

      # Default image should appear for show without poster_path:
      assert_match 'class="poster_default"', response.body
    end

    def test_show_page

      get "/shows?data=" + CGI::escape(@@got.to_json)
      assert_response :success

      # Name should appear:
      assert_match @@got["original_name"], response.body

      # Rating of the show appear:
      assert_match "User Rating: #{@@got["vote_average"]}", response.body

      # Poster url should appear:
      assert_match @@got["backdrop_path"], response.body

      # Description should appear:
      assert_match @@got["overview"], response.body

    end    
end