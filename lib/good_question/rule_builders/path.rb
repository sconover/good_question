require "good_question/rule_builders/base"

module GoodQuestion
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