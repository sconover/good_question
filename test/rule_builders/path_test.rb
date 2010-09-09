require "./test/test_helper"

require "good_question/rule_builders/path"
include GoodQuestion

#what about when we put criteria in the path?


regarding "describe and constrain http path_info" do
  
  regarding "parts are... (basic path length and splitting up)" do
    
    test "on success, break up the path into parts" do
      rule = 
        PathRuleBuilder.new(:my_path_info) {
          parts_are(:book, :page_number)
          rule(:book){}
          rule(:page_number){}
        }.build
    
      result = rule.apply_to("/coraline/7")
      assert{ result.memory[:book] == "coraline" }
      assert{ result.memory[:page_number] == "7" }
    end
  
    test "constrain the length of the path" do
      rule = 
        PathRuleBuilder.new(:my_path_info) {
          parts_are(:book, :page_number)
          rule(:book){}
          rule(:page_number){}
        }.build
  
      assert{ rule.apply_to("/coraline/7").satisfied? }
      
      deny  { rule.apply_to("/coraline/7/zzz").satisfied? }
      deny  { rule.apply_to("/coraline").satisfied? }
    end

    test "say something about the path parts on failure" do
      rule = 
        PathRuleBuilder.new(:my_path_info) {
          parts_are(:book, :page_number)
          rule(:book){}
          rule(:page_number){}
        }.build
  
      assert{ rule.apply_to("/coraline/7").satisfied? }
      assert{ rescuing{rule.apply_to("/coraline/7/zzz").satisfied!}.
                message == "Path must be in the form '/book/page_number'" }
    end
    
  end
  
  regarding "apply rule with path part name" do
    
    test "basic" do
      rule = 
        PathRuleBuilder.new(:my_path_info) {
          parts_are(:book, :page_number)
          rule(:book){
            in_list{%w{coraline lincoln infidel}}
          }
          rule(:page_number){
            type_is{Integer}
            change_self_to{self.to_i}
            in_range{1..10}
          }
        }.build
    
      assert{ rule.apply_to("/coraline/7").satisfied? }
      
      deny  { rule.apply_to("/ZZZ/7").satisfied? }
      deny  { rule.apply_to("/coraline/999").satisfied? }
    end

  end
  
end
   
