require "./test_external/integration_test_helper"
require "./test/examples/common_twitter"

regarding "really use twitter (this is a control, and to prove out a test suite, to be reused)" do

  def rack_client
    Rack::Client.new("http://api.twitter.com")
  end
  
  instance_eval(&COMMON_TWITTER)

end