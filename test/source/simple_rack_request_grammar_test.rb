require "./test/test_helper"

require "good_question/source/simple_rack_request_grammar"
include GoodQuestion

regarding "grammar that describes now a simple rack get request should look" do
  
  #path => [:ignored, :version, :resource_type]
  #query_string => {:show => :list}
  
  test "the path conforms to a struture" do
    grammar = 
      SimpleRackGetRequestGrammar.new(
        :path => ["version", "resource_type"]
      )
    assert { grammar.apply_to(new_request("PATH_INFO" => "/v1/foo")).well_formed? }

    assert { rescuing{grammar.apply_to(new_request("PATH_INFO" => "/v1/foo/bar")).well_formed!}.message ==
               "Path must have exactly 2 parts." }
    assert { rescuing{grammar.apply_to(new_request("PATH_INFO" => "/v1")).well_formed!}.message ==
               "Path must have exactly 2 parts." }
    
    assert { grammar.apply_to(new_request("PATH_INFO" => "/v1/foo", "QUERY_STRING" => "")).memory == 
               {"version" => "v1", "resource_type" => "foo"} }
  end
  
  test "the query params are constrained to a list of acceptable params" do
    grammar = SimpleRackGetRequestGrammar.new(:query_param_names => {"show" => :list})
    
    assert { grammar.apply_to(new_request("QUERY_STRING" => "show=id,name")).well_formed? }
    assert { grammar.apply_to(new_request("QUERY_STRING" => "show=id,name")).memory ==
              {"version" => "v1", "resource_type" => "foo", "show" => ["id", "name"] } }

    deny   { grammar.apply_to(new_request("QUERY_STRING" => "show=id,name&YYY=ZZZ")).well_formed? }
  end
  
  test "the exception contains the problems that were encountered" do
    grammar = SimpleRackGetRequestGrammar.new
    error = rescuing{grammar.apply_to(
              new_request("PATH_INFO" => "/v1", 
                          "QUERY_STRING" => "YYY=ZZZ")).well_formed!}
    assert { error.problems.collect{|p|p.message} == [
               "Path must have exactly 2 parts.",
               "Query params can be: show."
             ] }
  end

  test "problems have appropriate details, for instance the list of what you provided vs what's actually allowed" do
    grammar = SimpleRackGetRequestGrammar.new(:query_param_names => {"show" => :list})
    error = rescuing{grammar.apply_to(
              new_request("QUERY_STRING" => "show=y,z&YYY=111&ZZZ=222")).well_formed!}
    assert { error.problems.collect{|p|p.message} == ["Query params can be: show."] }
    
    assert { error.problems.first.details == {:allowed => ["show"], :not_allowed => ["YYY", "ZZZ"]} }
  end

  test "some query params are optional" do
    grammar = SimpleRackGetRequestGrammar.new
    assert { grammar.apply_to(new_request("QUERY_STRING" => "show=id,name")).well_formed? }
    assert { grammar.apply_to(new_request("QUERY_STRING" => "")).well_formed? }
    assert { grammar.apply_to(new_request("QUERY_STRING" => nil)).well_formed? }
  end
  
  def apply(args={})
    grammar.apply_to(new_request(args))
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