require "./test/test_helper"

require "good_question/query_precursor"
require "good_question/query"
include GoodQuestion

regarding "query precursor transforms to a query" do
  
  test "basic transform" do
    assert{ 
      QueryPrecursor.new(      
        "resource_type" => "foo",
        "show" => ["id", "name"]
      ).to_query ==
        Query.new(:resource_type => "foo", :show => ["id", "name"])
    }
  end
    
end