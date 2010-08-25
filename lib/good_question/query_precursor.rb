module GoodQuestion
  class QueryPrecursor
    def initialize(args)
      defaults = {
        :resource_type => nil,
        :show => []
      }
      @data = defaults.merge(args)
    end
    
    def resource_type
      @data[:resource_type]
    end

    def show
      @data[:show]
    end
  end
end