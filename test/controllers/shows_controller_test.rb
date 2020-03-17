require 'test_helper'

class ShowsControllerTest < ActionDispatch::IntegrationTest
	WebMock.stub_request(:get, "http://api.themoviedb.org").
  		with(body:{"results"=>[]})

  	get "/"
  	assert_response :success 
end