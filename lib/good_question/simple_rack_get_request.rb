require "rack/request"
require "good_question/query_precursor"

module GoodQuestion
  class SimpleRackGetRequest
    def initialize(rack_request)
      @rack_request = rack_request
    end
    
    def to_query_precursor
      QueryPrecursor.new(
        :resource_type => @rack_request.path_info.split("/")[2],
        :show => @rack_request.params["show"].split(",")
      )
    end
  end
end