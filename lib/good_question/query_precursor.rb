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
    
    def to_query
      Query.new(:resource_type => resource_type, :show => show)
    end
  end
end