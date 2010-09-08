require "pinker"
require "pinker/addons/in_list"
require "pinker/addons/in_range"
require "pinker/addons/type_is"
require "rack/request"

#move into pinker?
#extract into its own project?

#path {
#  parts_are(:book, :page_number)
#  rule(:book) {
#    in_list(%w{coraline lincoln infidel})
#  }
#  rule(:page_number) {
#    type(Integer)
#    range(1..200)
#  }
#}

module GoodQuestion
  
  class BaseRuleBuilder < Pinker::RuleBuilder
    include Pinker::RuleBuilderAddons::InList
    include Pinker::RuleBuilderAddons::InRange
    include Pinker::RuleBuilderAddons::TypeIs
  end
  
  class RackRequestRuleBuilder < BaseRuleBuilder

    def path(&block)
      
      #hmm
      
      add_rule(:path,         
        PathRuleBuilder.new("#{rule_key}_path".to_sym){
          instance_eval(&block)
        }.build
      )

      with_rule(:path){|rule|rule.apply_to(self.path_info)}
    end
  end
  
  class PathRuleBuilder < BaseRuleBuilder
    def parts_are(*expected_path_parts)
      declare("Path must be in the form '/#{expected_path_parts.join("/")}'"){|call, context|
        path_parts = self.split("/")
        path_parts.shift
        if path_parts.length==expected_path_parts.length
          path_hash = {}
          expected_path_parts.each_with_index do |symbol, i|
            path_hash[symbol] = path_parts[i]
          end
          context[:parts] = path_hash
          true
        else
          false
        end
      }
      
      remember{|memory, context|memory.merge!(context[:parts])}
      
      expected_path_parts.each do |path_part|
        with_rule(path_part){|rule, context|rule.apply_to(context[:parts][path_part])}
      end
    end
  end
  
end