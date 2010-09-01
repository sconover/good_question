require "pinker"
require "good_question/query_precursor"

module GoodQuestion

  class QueryPrecursorDefaultGrammar < Pinker::Grammar
  
    def initialize(args)
      super(QueryPrecursorDefaultGrammar) do
        rule(QueryPrecursor) do
          
          declare do |call|
            args[:allowed_resource_types].include?(resource_type) ||
              call.fail("'#{resource_type}' is not an allowed resource type.", 
                        :allowed => args[:allowed_resource_types],
                        :not_allowed => [resource_type])
          end
          
          declare do |call|
            not_allowed = (show - args[:allowed_show_attributes])
            not_allowed.empty? ||
              call.fail("#{not_allowed.join(", ")} not allowed in show.", 
                        :allowed => args[:allowed_show_attributes],
                        :not_allowed => not_allowed)
          end
      
        end
      end
    end
  
  end
  
end