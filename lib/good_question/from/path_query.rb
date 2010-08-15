require "good_question/query"
require "uri"

module GoodQuestion
  class Query
    def self.from_path_query(path_query_str, map=DefaultPathQueryToQueryMap.new)
      uri = URI::parse(path_query_str)
      Query.new(
        Query::ATTRS.inject({}) do |h, attr_sym|
          h[attr_sym] = map.send(attr_sym, uri)
          h
        end
      )
    end
  end
  
  
  #grammar goes along with this pretty well
  #would need a default grammar.
  class DefaultPathQueryToQueryMap
    def version(uri)
      #brittle unless validated...
      uri.path.split("/")[1].slice(1..-1).to_i
    end

    def resource_type(uri)
      #brittle unless validated...
      uri.path.split("/")[2]
    end
  end
end