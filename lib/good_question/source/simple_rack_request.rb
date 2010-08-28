require "rack/request"
require "good_question/query_precursor"
require "good_question/source/simple_rack_request_grammar"

module GoodQuestion
  class SimpleRackGetRequest
    def initialize(rack_request)
      @rack_request = rack_request
    end
    
    def to_query_precursor
      QueryPrecursor.new(SimpleRackGetRequestGrammar.new.apply_to(self).memory)
    end
  end
end