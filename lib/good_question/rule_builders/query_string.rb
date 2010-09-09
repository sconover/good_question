require "rack/utils"
require "good_question/rule_builders/base"

module GoodQuestion
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