require "./test/integration_test_helper"

regarding "really use twitter (this is a control, and to prove out a test suite, to be reused)" do

  regarding "basics" do
    
    test_GET "/1/statuses/user_timeline.json?screen_name=gq_amy" do |json|
      assert{ json.collect{|entry|entry["text"]} == [
                "dog bit me",
                "watching paint dry",
                "i went to the store"
              ] }
    end
  
    test_GET "/1/statuses/user_timeline.xml?screen_name=gq_amy" do |doc|
      assert{ doc.xpath("//text").texts == [
                "dog bit me",
                "watching paint dry",
                "i went to the store"
              ] }
    end
    
  end
  
end