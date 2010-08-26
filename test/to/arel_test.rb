require "./test/test_helper"

unless RUBY_VERSION=="1.8.6"
  
require "good_question/to/arel"
include GoodQuestion

regarding "convert a query to an arel select statement" do
  
  class FakeEngine
    def connection
    end
    
    def table_exists?(name)
      true
    end
  end
  
  class FakeColumn
    attr_reader :name, :type
    def initialize(name, type)
      @name = name
      @type = type
    end
    
    def type_cast(value)
      value
    end
  end
  
  @table = Arel::Table.new(:foo, :engine => FakeEngine.new)
  Arel::Table.tables = [@table]
  @table.instance_variable_set("@columns".to_sym, [
    FakeColumn.new("a", :integer), 
    FakeColumn.new("b", :integer),
    FakeColumn.new("c", :integer)
  ])
  
  test "select columns, table" do
    assert{ 
      Query.new(:resource_type => "foo", :show => ["id", "name"]).
        to_arel(FakeEngine.new) == 
          Arel::Table.new(:foo, :engine => FakeEngine.new)
    }
  end
end

end