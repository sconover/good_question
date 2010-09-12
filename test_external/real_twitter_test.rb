require "./test_external/integration_test_helper"

regarding "really use twitter (this is a control, and to prove out a test suite, to be reused)" do

  def url_prefix
    "http://api.twitter.com"
  end
  
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
      assert{ headers["Status"] == "403 Forbidden" }
      assert{ headers["Content-Type"] == "text/html; charset=utf-8" }
      assert{ body.text.strip == "" }
    end

    test_GET "/1/statuses/user_timeline.json?screen_name=gq_amyZZ", 
             "bad screen name, json" do |json, headers, code|
      assert{ code == 404 }
      assert{ headers["Status"] == "404 Not Found" }
      assert{ headers["Content-Type"] == "application/json; charset=utf-8" }
      assert{ json == {"request"=>"/1/statuses/user_timeline.json?screen_name=gq_amyZZ", 
                        "error"=>"Not found"} }
    end

    test_GET "/1/statuses/user_timeline.xml?screen_name=gq_amyZZ", 
             "bad screen name, xml" do |xml, headers, code|
      assert{ code == 404 }
      assert{ headers["Status"] == "404 Not Found" }
      assert{ headers["Content-Type"] == "application/xml; charset=utf-8" }
      assert{ xml.xpath("/hash/request").first.text == "/1/statuses/user_timeline.xml?screen_name=gq_amyZZ" }
      assert{ xml.xpath("/hash/error").first.text == "Not found" }
    end
    
    #over-RF'd?
    [["/4/statuses/user_timeline.json?screen_name=gq_amy", 
      "invalid version"],
     ["/1/statusesZZZZZZZZZ/user_timeline.json?screen_name=gq_amy", 
      "bad path.  obviously twitter is treating bad version the same as bad path"]].each do |url, comments|

      test_GET url, comments do |html, headers, code|
        assert{ code == 404 }
        assert{ headers["Status"] == "404 Not Found" }
        assert{ headers["Content-Type"] == "text/html; charset=utf-8" }
        assert{ html.to_s.include?("Sorry, that page doesn’t exist!") }
      end

    end
    
    test_GET "/1/statuses/user_timeline.json", 
             "unauthorized, json" do |json, headers, code|
      assert{ code == 401 }
      assert{ headers["Status"] == "401 Unauthorized" }
      assert{ headers["Content-Type"] == "application/json; charset=utf-8" }
      assert{ json["request"] == "/1/statuses/user_timeline.json" }
      assert{ json["error"] == "This method requires authentication." }
    end

    test_GET "/1/statuses/user_timeline.xml", 
             "unauthorized, xml" do |xml, headers, code|
      assert{ code == 401 }
      assert{ headers["Status"] == "401 Unauthorized" }
      assert{ headers["Content-Type"] == "application/xml; charset=utf-8" }
      assert{ xml.xpath("/hash/request").first.text == "/1/statuses/user_timeline.xml" }
      assert{ xml.xpath("/hash/error").first.text == "This method requires authentication." }
    end
    
    test_GET "/1/statuses/user_timeline.json", 
             "unauthorized, json" do |json, headers, code|
      assert{ code == 401 }
      assert{ headers["Status"] == "401 Unauthorized" }
      assert{ headers["Content-Type"] == "application/json; charset=utf-8" }
      assert{ json["request"] == "/1/statuses/user_timeline.json" }
      assert{ json["error"] == "This method requires authentication." }
    end

    INCORRECT_GQ_AMY_BASIC_AUTH_HASH = "QWxhZGRpbjpvcGVuIHNlc2FtZQ=="
    test_GET "/1/statuses/user_timeline.json", 
             {"Authorization" => "Basic #{INCORRECT_GQ_AMY_BASIC_AUTH_HASH}"},
             "bad password, json" do |json, headers, code|
      assert{ code == 401 }
      assert{ headers["Status"] == "401 Unauthorized" }
      assert{ headers["Content-Type"] == "application/json; charset=utf-8" }
      assert{ json == {"errors"=> [{"code" => 32, "message" => "Could not authenticate you"}]} }
    end
    
    
    CORRECT_GQ_AMY_BASIC_AUTH_HASH = "Z3FfYW15OmozYW5uMw=="
    test_GET "/1/statuses/user_timeline.json", 
             {"Authorization" => "Basic #{CORRECT_GQ_AMY_BASIC_AUTH_HASH}"},
             "no more basic auth, json" do |json, headers, code|
      assert{ code == 401 }
      assert{ headers["Status"] == "401 Unauthorized" }
      assert{ headers["Content-Type"] == "application/json; charset=utf-8" }
      assert{ json == {"errors"=> [{"code" => 53, "message" => "Basic authentication is not supported"}]} }
    end


  end
end