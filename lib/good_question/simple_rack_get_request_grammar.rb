require "pinker"
require "good_question/simple_rack_get_request"

module GoodQuestion

  class SimpleRackGetRequestGrammar < Pinker::Grammar
  
    def initialize
      super(SimpleRackGetRequestGrammar) do
        rule(SimpleRackGetRequest) do
          declare{@rack_request.path_info.split("/").length >= 3}
          declare{Rack::Utils.parse_nested_query(@rack_request.query_string).keys - ["show"]}
        end
      end
    end
  
  end
  
end