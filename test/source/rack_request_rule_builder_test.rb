require "./test/test_helper"

require "good_question/source/rack_request_rule_builder"
include GoodQuestion


#reuse the path rule on another param?
#with_rule(:path){|rule|rule.apply_to(self["PATH_INFO"])}

#path rule builder...

regarding "describe and constrain a rack request" do

  regarding "the path" do
    
    regarding "parts are... (basic path length and splitting up)" do
      
      test "on success, break up the path into parts" do
        rule = 
          RackRequestRuleBuilder.new(:my_page_request) {
            path{
              parts_are(:book, :page_number)
              rule(:book){}
              rule(:page_number){}
            }
          }.build
      
        result = rule.apply_to(req("PATH_INFO" => "/coraline/7"))
        assert{ result.memory[:book] == "coraline" }
        assert{ result.memory[:page_number] == "7" }
      end
    
      test "constrain the length of the path" do
        rule = 
          RackRequestRuleBuilder.new(:my_page_request) {
            path{
              parts_are(:book, :page_number)
              rule(:book){}
              rule(:page_number){}
            }
          }.build
    
        assert{ rule.apply_to(req("PATH_INFO" => "/coraline/7")).satisfied? }
        deny  { rule.apply_to(req("PATH_INFO" => "/coraline/7/zzz")).satisfied? }
        deny  { rule.apply_to(req("PATH_INFO" => "/coraline")).satisfied? }
      end

      test "say something about the path parts on failure" do
        rule = 
          RackRequestRuleBuilder.new(:my_page_request) {
            path{
              parts_are(:book, :page_number)
              rule(:book){}
              rule(:page_number){}
            }
          }.build
    
        assert{ rule.apply_to(req("PATH_INFO" => "/coraline/7")).satisfied? }
        assert{ rescuing{rule.apply_to(req("PATH_INFO" => "/coraline/7/zzz")).satisfied!}.
                  message == "Path must be in the form '/book/page_number'" }
      end
      
    end
    
    regarding "apply rule with path part name" do
      
      test "basic" do
        rule = 
          RackRequestRuleBuilder.new(:my_page_request) {
            path{
              parts_are(:book, :page_number)
              rule(:book){
                declare_list{{:allowed => %w{coraline lincoln infidel}}}
              }
              rule(:page_number){
                declare{(1..10).include?(self.to_i)}
                #range{1..10}
                #type conversion?
              }
            }
          }.build
      
        assert{ rule.apply_to(req("PATH_INFO" => "/coraline/7")).satisfied? }
        deny  { rule.apply_to(req("PATH_INFO" => "/ZZZ/7")).satisfied? }
        deny  { rule.apply_to(req("PATH_INFO" => "/coraline/999")).satisfied? }
      end

    end
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