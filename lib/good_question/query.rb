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
      class_eval(%{
        def #{attr_sym}
          @data[:#{attr_sym.to_s}]
        end
      })
    end
  end
end