require "pinker"
require "pinker/addons/in_list"
require "pinker/addons/in_range"
require "pinker/addons/type_is"
require "rack/request"

#move into pinker?
#extract into its own project?

module GoodQuestion
  
  class BaseRuleBuilder < Pinker::RuleBuilder
    include Pinker::RuleBuilderAddons::InList
    include Pinker::RuleBuilderAddons::InRange
    include Pinker::RuleBuilderAddons::TypeIs
  end
  
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
  
  class QueryStringRuleBuilder < BaseRuleBuilder
    def params_are(params_definition)
      params_definition[:required] ||= {}
      params_definition[:optional] ||= {}
      full_mapping = 
        {}.
        merge(params_definition[:required]).
        merge(params_definition[:optional])

      declare{|call, context|
        context[:raw_params] = Rack::Utils.parse_nested_query(self)
        context[:params] =
          context[:raw_params].inject({}) do |h, (param_name, value)|
            h[full_mapping[param_name]] = Array(value)
            h
          end
          
        true
        
        (params_definition[:required].keys - context[:raw_params].keys) == []
      }
      
      declare{|call, context|
        remaining = context[:raw_params].keys - params_definition[:required].keys
        (remaining - params_definition[:optional].keys) == []
      }
      
      remember{|memory, context|memory.merge!(context[:params])}
      
      full_mapping.values.each do |param|
        with_rule(param){|rule, context|
          if context[:params].key?(param)
            rule.apply_to(context[:params][param])
          else
            true
          end
        }
      end
      
    end
  end
  
end