module GoodQuestion
  class Query
    ATTRS = [:version, :resource_type]
    
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
    
    def ==(other)
      @data == other.instance_variable_get("@data".to_sym)
    end
  end
end