require "./test/test_helper"

require "good_question/rule_builders/rack_request"
include GoodQuestion


regarding "describe and constrain a rack request" do

  test "integration test- path" do
    rule = 
      RackRequestRuleBuilder.new(:my_page_request) {
        path{
          parts_are(:book, :page_number)
          rule(:book){
            in_list{%w{coraline lincoln infidel}}
          }
          rule(:page_number){
            type_is{Integer}
            change_self_to{self.to_i}
            in_range{1..10}
          }
        }
      }.build
  
    assert{ rule.apply_to(req("PATH_INFO" => "/coraline/7")).satisfied? }
    
    deny  { rule.apply_to(req("PATH_INFO" => "/ZZZ/7")).satisfied? }
    deny  { rule.apply_to(req("PATH_INFO" => "/coraline/999")).satisfied? }
  end

  test "integration test - query string" do
    rule = 
      RackRequestRuleBuilder.new(:my_page_request) {
        query_string{
          params_are(:optional => {"show" => :show, "q" => :criteria})
          rule(:show){
            change_self_to{self.first.split(",")}
            in_list{%w{id name price}}
          }
          rule(:criteria){
            declare{self.first=="color=pink"}
          }
        }
      }.build

    assert{ rule.apply_to(req("QUERY_STRING" => "q=color=pink&show=id,name")).satisfied? }

    deny  { rule.apply_to(req("QUERY_STRING" => "q=color=blue&show=id,name")).satisfied? }
    deny  { rule.apply_to(req("QUERY_STRING" => "q=color=pink&show=ZZZ,id,name")).satisfied? }
  end


  def req(args={})
    defaults = {
      "PATH_INFO" => "/foo/bar",
      "QUERY_STRING" => "q=222",
      "rack.input" => StringIO.new
    }
    args = defaults.merge(args)
    
    Rack::Request.new(args)
  end
   

end