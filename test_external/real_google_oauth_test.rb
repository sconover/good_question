require "./test_external/integration_test_helper"

regarding "really use google oauth" do
  
  regarding "oauth" do

    def rack_client
      Rack::Client.new("https://www.google.com")
    end

    test "foo" do
      body, headers, code = POST("/accounts/OAuthGetRequestToken", {
        :headers => {
          "Content-Type" => "application/x-www-form-urlencoded",
          "Authorization" => "OAuth"
        },
        :params => {
          "oauth_consumer_key"=> "yourwebapp.com",
          "oauth_signature_method" => "RSA-SHA1",
          "oauth_signature" => "wOJIO9A2W5mFwDgiDvZbTSMK%2FPY%3D",
          "oauth_timestamp" => Time.now.to_i,
          "oauth_nonce" => "4572616e48616d6d65724c61686176",
          "oauth_version" => "1.0",
          "oauth_callback" => "http://www.yourwebapp.com/showcalendar.html",
          "scope" => "http://www.google.com/calendar/feeds http://picasaweb.google.com/data"
        }
      })
      p code
      p headers
      p body
    end
  end
  
  #timestamp failure
  #consumer not registered failure
  
end