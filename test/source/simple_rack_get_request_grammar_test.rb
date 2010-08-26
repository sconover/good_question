require "./test/test_helper"

require "good_question/source/simple_rack_get_request"
require "good_question/source/simple_rack_get_request_grammar"
include GoodQuestion

regarding "grammar that describes now a simple rack get request should look" do
  
  test "there are at least two elements in the path" do
    grammar = SimpleRackGetRequestGrammar.new
    assert { grammar.apply_to(new_request("PATH_INFO" => "/v1/foo")).well_formed? }
    assert { grammar.apply_to(new_request("PATH_INFO" => "/v1/foo/bar")).well_formed? }

    deny   { grammar.apply_to(new_request("PATH_INFO" => "/v1")).well_formed? }
  end
  
  test "the query params are constrained to a list of acceptable params" do
    grammar = SimpleRackGetRequestGrammar.new
    assert { grammar.apply_to(new_request("QUERY_STRING" => "show=id,name")).well_formed? }

    deny   { grammar.apply_to(new_request("QUERY_STRING" => "show=id,name&YYY=ZZZ")).well_formed? }
  end

  test "some query params are optional" do
    grammar = SimpleRackGetRequestGrammar.new
    assert { grammar.apply_to(new_request("QUERY_STRING" => "show=id,name")).well_formed? }
    assert { grammar.apply_to(new_request("QUERY_STRING" => "")).well_formed? }
    assert { grammar.apply_to(new_request("QUERY_STRING" => nil)).well_formed? }
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