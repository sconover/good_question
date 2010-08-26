require "good_question/query"
require "arel"

module GoodQuestion
  class Query
    def to_arel(engine=nil)
      Arel::Table.new(self.resource_type.to_sym, :engine => engine)
    end
  end
end