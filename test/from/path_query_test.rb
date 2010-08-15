require "./test/test_helper"

require "good_question/from/path_query"
include GoodQuestion

regarding "parse url path + query and make a query out of it" do

  regarding "intelligent defaults" do

    test "version and resource" do
      assert { Query.from_path_query("/v2/foo") == 
               Query.new(:version => 2, :resource_type => "foo") }
    end

  end

  regarding "custom mapping" do
    
    test "version and resource" do
      class CustomPathQueryToQueryMap < DefaultPathQueryToQueryMap
        def version(uri)       uri.query.split("version=")[1].to_i end
        def resource_type(uri) uri.path.split("/")[1] end
      end
      
      assert { Query.from_path_query("/foo?version=2", CustomPathQueryToQueryMap.new) == 
               Query.new(:version => 2, :resource_type => "foo") }
    end
    
  end
end