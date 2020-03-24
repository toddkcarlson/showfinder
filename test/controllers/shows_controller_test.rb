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

    def test_main_page
        got = {
            "original_name" => "Game of Thrones",
            "vote_average" => 10,
            "poster_path" => "path/to/some_image.jpg"
        }

        ad = {
            "original_name" => "Arrested Development",
            "vote_average" => 10
        }

        results = [got, ad]

        mock_tv_api({
            path: '/trending/tv/week',
            body: {"results" => results}})

      get "/"
      assert_response :success

      results.each do |r|
          # Names of the shows should appear:
          assert_match r["original_name"], response.body

          # Links should contain correct data:
          assert_match '/shows?data=' + CGI::escape(r.to_json), response.body
      end

      # Poster url should appear:
      assert_match got["poster_path"], response.body

      # Default image should appear for show without poster_path:
      assert_match 'class="poster_default"', response.body
    end

    def test_search
        got = {
            "original_name" => "Game of Thrones",
            "vote_average" => 10,
            "poster_path" => "path/to/some_image.jpg"
        }

        ad = {
            "original_name" => "Arrested Development",
            "vote_average" => 10
        }

        results = [got, ad]

        mock_tv_api({
            path: '/?search=',
            body: {"results" => results}})

      get "/"
      assert_response :success

      results.each do |r|
          # Names of the shows should appear:
          assert_match r["original_name"], response.body

          # Links should contain correct data:
          assert_match '/shows?data=' + CGI::escape(r.to_json), response.body
      end

      # Poster url should appear:
      assert_match got["poster_path"], response.body

      # Default image should appear for show without poster_path:
      assert_match 'class="poster_default"', response.body
    end

    def test_show_page
        got = {
            "original_name" => "Game of Thrones",
            "vote_average" => 10,
            "poster_path" => "path/to/some_image.jpg"
        }

        ad = {
            "original_name" => "Arrested Development",
            "vote_average" => 10
        }

        results = [got, ad]

        mock_tv_api({
            path: '/shows?data=',
            body: {"results" => results}})

      get "/"
      assert_response :success

      results.each do |r|
          # Names of the shows should appear:
          assert_match r["original_name"], response.body

          # Links should contain correct data:
          assert_match '/shows?data=' + CGI::escape(r.to_json), response.body
      end

      # Poster url should appear:
      assert_match got["poster_path"], response.body

      # Default image should appear for show without poster_path:
      assert_match 'class="poster_default"', response.body
    end    
end