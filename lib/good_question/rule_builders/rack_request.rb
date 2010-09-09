require "good_question/rule_builders/base"
require "good_question/rule_builders/path"
require "good_question/rule_builders/query_string"
require "rack/request"

module GoodQuestion
  class RackRequestRuleBuilder < BaseRuleBuilder
    
    def path(&block)
      add_rule(:path,         
        PathRuleBuilder.new("#{rule_key}_path".to_sym){
          instance_eval(&block)
        }.build
      )
      
      with_rule(:path){|rule|rule.apply_to(self.path_info)}
    end
    
    def query_string(&block)
      add_rule(:query_string,         
        QueryStringRuleBuilder.new("#{rule_key}_query_string".to_sym){
          instance_eval(&block)
        }.build
      )
      
      with_rule(:query_string){|rule|rule.apply_to(self.query_string)}
    end
  end
end