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
  
  regarding "failure scenarios" do

    test_GET "/1/statuses/user_timeline.ZZZZZZ?screen_name=gq_amy" do |body, headers, code|
      assert{ code == 403 }
      assert{ headers["Content-Type"] == "text/html; charset=utf-8" }
      assert{ body.strip == "" }
    end

    test_GET "/1/statuses/user_timeline.json?screen_name=gq_amyZZ" do |json, headers, code|
      assert{ code == 404 }
      assert{ headers["Content-Type"] == "application/json; charset=utf-8" }
      assert{ json == {"request"=>"/1/statuses/user_timeline.json?screen_name=gq_amyZZ", 
                        "error"=>"Not found"} }
    end

    test_GET "/1/statuses/user_timeline.xml?screen_name=gq_amyZZ" do |doc, headers, code|
      assert{ code == 404 }
      assert{ headers["Content-Type"] == "application/xml; charset=utf-8" }
      assert{ doc.xpath("/hash/request").first.text == "/1/statuses/user_timeline.xml?screen_name=gq_amyZZ" }
      assert{ doc.xpath("/hash/error").first.text == "Not found" }
    end

  end
end