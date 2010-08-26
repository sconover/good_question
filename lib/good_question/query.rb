require "good_question/core"

module GoodQuestion
  class Query
    include ValueEquality
    
    ATTRS = [:version, :resource_type, :show]
    
    attr_reader *ATTRS
    
    def initialize(args)
      @data = args
    end
    
    ATTRS.each do |attr_sym|
      instance_eval(%{
        def #{attr_sym}
          @data[:#{attr_sym}]
        end
      })
    end
  end
end