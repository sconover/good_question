require "./test/test_helper"

require "good_question/query_precursor_default_grammar"
include GoodQuestion

regarding "default grammar for a query precursor" do
  
  test "acceptable resource types" do
    grammar = new_grammar(:allowed_resource_types => ["foo", "bar"])
    
    assert { grammar.apply_to(new_query_precursor("resource_type" => "foo")).well_formed? }
    deny   { grammar.apply_to(new_query_precursor("resource_type" => "ZZZ")).well_formed? }

    error = rescuing{grammar.apply_to(new_query_precursor("resource_type" => "ZZZ")).well_formed!}
    assert { error.message == "'ZZZ' is not an allowed resource type." }
    assert { error.problems.first.details == {:allowed => ["foo", "bar"], 
                                              :not_allowed => ["ZZZ"]} }
  end  
  
  test "acceptable show attributes" do
    grammar = new_grammar(:allowed_show_attributes => ["id", "name"])
    
    assert { grammar.apply_to(new_query_precursor("show" => ["name"])).well_formed? }
    assert { grammar.apply_to(new_query_precursor("show" => ["id", "name"])).well_formed? }
    deny   { grammar.apply_to(new_query_precursor("show" => ["id", "ZZZ"])).well_formed? }

    error = rescuing{grammar.apply_to(new_query_precursor("show" => ["YYY", "id", "ZZZ"])).well_formed!}
    assert { error.message == "YYY, ZZZ not allowed in show." }
    assert { error.problems.first.details == {:allowed => ["id", "name"], 
                                              :not_allowed => ["YYY", "ZZZ"]} }
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
      "resource_type" => "foo",
      "show" => ["id", "name"]
    }
    args = defaults.merge(args)
    
    QueryPrecursor.new(args)
  end
    
end