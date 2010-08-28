require "./test/test_helper"

require "good_question/source/simple_rack_request"
include GoodQuestion

regarding "transform a simple rack get request into a query precursor" do
  
  test "populate resource type" do
    query_precursor = new_request("PATH_INFO" => "/v1/foo").to_query_precursor    
    assert { query_precursor.resource_type == "foo" }
  end
  
  test "populate show attributes" do
    query_precursor = new_request("QUERY_STRING" => "show=id,name").to_query_precursor
    assert { query_precursor.show == ["id", "name"] }
  end

  
  def new_request(args={})
    defaults = {
      "PATH_INFO" => "/v1/foo",
      "QUERY_STRING" => "show=id,name",
      "rack.input" => StringIO.new
    }
    args = defaults.merge(args)
    
    request = SimpleRackGetRequest.new(Rack::Request.new(args))
  end
   
end