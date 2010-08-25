require "./test/test_helper"

require "good_question/query_precursor_default_grammar"
include GoodQuestion

regarding "default grammar for a query precursor" do
  
  test "acceptable resource types" do
    grammar = new_grammar(:allowed_resource_types => ["foo", "bar"])
    
    assert { grammar.apply_to(new_query_precursor(:resource_type => "foo")).well_formed? }
    deny   { grammar.apply_to(new_query_precursor(:resource_type => "ZZZ")).well_formed? }
  end
  
  test "acceptable show attributes" do
    grammar = new_grammar(:allowed_show_attributes => ["id", "name"])
    
    assert { grammar.apply_to(new_query_precursor(:show => ["name"])).well_formed? }
    assert { grammar.apply_to(new_query_precursor(:show => ["id", "name"])).well_formed? }
    deny   { grammar.apply_to(new_query_precursor(:show => ["id", "ZZZ"])).well_formed? }
  end
  
  def new_grammar(args={})
    defaults = {
      :allowed_resource_types => ["foo", "bar"],
      :allowed_show_attributes => ["id", "name", "price"],
    }
    args = defaults.merge(args)
    
    QueryPrecursorDefaultGrammar.new(args)
  end
  
  def new_query_precursor(args={})
    defaults = {
      :resource_type => "foo",
      :show => ["id", "name"]
    }
    args = defaults.merge(args)
    
    QueryPrecursor.new(args)
  end
    
end