require "pinker"
require "good_question/query_precursor"

module GoodQuestion

  class QueryPrecursorRuleBuilder < Pinker::RuleBuilder
    include RuleBuilderAddons::DeclareList
    
    def initialize
      super(QueryPrecursor)
    end
    
    def declare_resource_type(allowed_resource_types, failure_message_proc=nil)
      declare_list{{:allowed => allowed_resource_types, :actual => self.resource_type}}
    end
    
    def declare_show(allowed_show_attributes, failure_message_proc=nil)
      declare_list{{:allowed => allowed_show_attributes, :actual => self.show}}
    end
    
  end
  
end