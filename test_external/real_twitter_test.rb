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
  
    test_GET "/1/statuses/user_timeline.xml?screen_name=gq_amy" do |xml|
      assert{ xml.xpath("//text").texts == [
                "dog bit me",
                "watching paint dry",
                "i went to the store"
              ] }
    end
    
  end
  
  regarding "failure scenarios" do

    test_GET "/1/statuses/user_timeline.ZZZZZZ?screen_name=gq_amy",
             "bad document type" do |body, headers, code|
      assert{ code == 403 }
      assert{ headers["Content-Type"] == "text/html; charset=utf-8" }
      assert{ body.text.strip == "" }
    end

    test_GET "/1/statuses/user_timeline.json?screen_name=gq_amyZZ", 
             "bad screen name, json" do |json, headers, code|
      assert{ code == 404 }
      assert{ headers["Content-Type"] == "application/json; charset=utf-8" }
      assert{ json == {"request"=>"/1/statuses/user_timeline.json?screen_name=gq_amyZZ", 
                        "error"=>"Not found"} }
    end

    test_GET "/1/statuses/user_timeline.xml?screen_name=gq_amyZZ", 
             "bad screen name, xml" do |xml, headers, code|
      assert{ code == 404 }
      assert{ headers["Content-Type"] == "application/xml; charset=utf-8" }
      assert{ xml.xpath("/hash/request").first.text == "/1/statuses/user_timeline.xml?screen_name=gq_amyZZ" }
      assert{ xml.xpath("/hash/error").first.text == "Not found" }
    end
    
    test_GET "/4/statuses/user_timeline.json?screen_name=gq_amy", 
             "invalid version" do |html, headers, code|
      assert{ code == 404 }
      assert{ headers["Content-Type"] == "text/html; charset=utf-8" }
      assert{ html.to_s.include?("Sorry, that page doesn’t exist!") }
    end
  end
end