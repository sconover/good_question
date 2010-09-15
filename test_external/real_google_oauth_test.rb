require "./test_external/integration_test_helper"
# require "hmac-sha1"
# require "digest/sha1"
# require "base64"

xregarding "really use google oauth" do
  
  def rack_client
    Rack::Client.new("https://www.google.com")
  end

  test "foo" do
    salt=Digest::SHA1.hexdigest("foo")[0..19]
    passkey=Base64.encode64(HMAC::SHA1.digest("bar", salt)).strip
    p passkey
    
    body, headers, code = POST("/accounts/OAuthGetRequestToken", 
      
      {"Content-Type" => "application/x-www-form-urlencoded",
       "Authorization" => "OAuth"},
       
      {"oauth_consumer_key"=> "yourwebapp.com",
       "oauth_signature_method" => "RSA-SHA1",
       "oauth_signature" => "wOJIO9A2W5mFwDgiDvZbTSMK%2FPY%3D",
       "oauth_timestamp" => Time.now.to_i,
       "oauth_nonce" => "4572616e48616d6d65724c61686176",
       "oauth_version" => "1.0",
       "oauth_callback" => "http://www.yourwebapp.com/showcalendar.html",
       "scope" => "http://www.google.com/calendar/feeds"}
       
    )
    p code
    p headers
    p body
  end
  
  #timestamp failure
  #consumer not registered failure
  
end