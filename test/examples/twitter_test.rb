require "./test_external/integration_test_helper"
require "./test/examples/twitter_service"
require "./test/examples/common_twitter"

regarding "good_question-based twitter implementation" do

  def rack_client
    Rack::Client::Simple.new(TwitterService.new)
  end
  
  instance_eval(&COMMON_TWITTER)

end