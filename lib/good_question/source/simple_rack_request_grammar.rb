require "pinker"
require "good_question/source/simple_rack_request"

module GoodQuestion

  class SimpleRackGetRequestGrammar < Pinker::Grammar
  
    def initialize(request_plan={})
      defaults = {
        :path => ["version", "resource_type"],
        :query_param_names => {"show" => :list}
      }
      request_plan = defaults.merge(request_plan)
      super(SimpleRackGetRequestGrammar) do
        rule(SimpleRackGetRequest) do
          
          declare("Path must have exactly #{request_plan[:path].length} parts.") do |call, context|
            context[:path_parts] = @rack_request.path_info.split("/").slice(1..-1)
            context[:path_parts].length == request_plan[:path].length
          end
          
          remember do |memory, context|
            request_plan[:path].inject(memory) do |memory, path_part_label|
              memory[path_part_label] = context[:path_parts].shift
              memory
            end
          end
          
          
          declare do |call, context|
            context[:params] = Rack::Utils.parse_nested_query(@rack_request.query_string)
            not_allowed = context[:params].keys - request_plan[:query_param_names].keys
            if not_allowed.empty?
              true
            else
              call.fail("Query params can be: #{request_plan[:query_param_names].keys.join(', ')}.",
                :allowed => request_plan[:query_param_names].keys.sort, 
                :not_allowed => not_allowed.sort)
            end
          end

          remember do |memory, context|
            request_plan[:query_param_names].each do |param_name, value_type|
              if context[:params].key?(param_name)
                if value_type == :list
                  memory[param_name] = context[:params][param_name].split(",")
                else
                  memory[param_name] = context[:params][param_name]
                end
              end
            end
          end
          
        end
      end
    end
  
  end
  
end