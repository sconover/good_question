require "./test/test_helper"

require "good_question/rule_builders/query_string"
include GoodQuestion

#what about when we put criteria in the path?


regarding "describe and constrain http query_string" do
  
  regarding "the query params are..." do

    test "on success, break up the query string into params" do
      rule = 
        QueryStringRuleBuilder.new(:my_query_string) {
          params_are(:optional => {"show" => :show, "q" => :criteria})
          rule(:show){}
          rule(:criteria){}
        }.build
  
      result = rule.apply_to("q=foo&show=bar")
      assert{ result.memory[:criteria] == ["foo"] }
      assert{ result.memory[:show] == ["bar"] }
    end

    test "optional params" do
      rule = 
        QueryStringRuleBuilder.new(:my_query_string) {
          params_are(:optional => {"show" => :show, "q" => :criteria})
          rule(:show){}
          rule(:criteria){}
        }.build
  
      assert{ rule.apply_to("q=foo&show=bar").satisfied? }
      assert{ rule.apply_to("q=foo").satisfied? }
      assert{ rule.apply_to("show=bar").satisfied? }
      assert{ rule.apply_to("").satisfied? }
    
      deny  { rule.apply_to("ZZZ=YYY").satisfied? }
    end

    test "required params" do
      rule = 
        QueryStringRuleBuilder.new(:my_query_string) {
          params_are(:required => {"format" => :format})
          rule(:format){}
        }.build
  
      assert{ rule.apply_to("format=json").satisfied? }

      deny  { rule.apply_to("").satisfied? }
      deny  { rule.apply_to("ZZZ=YYY").satisfied? }
    end
  
    test "params are returned even if there is a problem" do
      rule = 
        QueryStringRuleBuilder.new(:my_query_string) {
          params_are(:required => {"format" => :format, "zzz" => :zzz})
          rule(:show){}
          rule(:criteria){}
        }.build
  
      deny  { rule.apply_to("format=json").satisfied? }

      assert{ rule.apply_to("format=json").memory[:format] == ["json"] }
    end
  end
  
  regarding "apply rule with param name" do

    test "basic rules" do
      rule = 
        QueryStringRuleBuilder.new(:my_query_string) {
          params_are(:optional => {"show" => :show, "q" => :criteria})
          rule(:show){
            change_self_to{self.first.split(",")}
            in_list{%w{id name price}}
          }
          rule(:criteria){
            declare{self.first=="color=pink"}
          }
        }.build
  
      assert{ rule.apply_to("q=color=pink&show=id,name").satisfied? }

      deny  { rule.apply_to("q=color=blue&show=id,name").satisfied? }
      deny  { rule.apply_to("q=color=pink&show=ZZZ,id,name").satisfied? }
    end

  end
end
   
