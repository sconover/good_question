require "./test/test_helper"

require "good_question/query"
include GoodQuestion

regarding "prove query value equality" do
  
  test "version and resource" do
    assert { Query.new(:version => 2, :resource_type => "foo") == 
             Query.new(:version => 2, :resource_type => "foo") }

    deny   { Query.new(:version => 2, :resource_type => "foo") == 
             Query.new(:version => 99, :resource_type => "foo") }
    deny   { Query.new(:version => 2, :resource_type => "foo") == 
             Query.new(:version => 2, :resource_type => "ZZZZZZ") }
  end
end