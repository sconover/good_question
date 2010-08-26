require "pinker"
require "good_question/query_precursor"

module GoodQuestion

  class QueryPrecursorDefaultGrammar < Pinker::Grammar
  
    def initialize(args)
      super(QueryPrecursorDefaultGrammar) do
        rule(QueryPrecursor) do
          declare{args[:allowed_resource_types].include?(resource_type)}
          declare{(show - args[:allowed_show_attributes]).empty?}
        end
      end
    end
  
  end
  
end