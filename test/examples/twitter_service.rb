require 'rack/request'
require 'rack/response'

class TwitterService
  def call(env)
    request = Rack::Request.new(env)
    
    response = Rack::Response.new
    
    path_info, query_string = request.path_info.split("?")
    query_params = Rack::Utils.parse_nested_query(query_string)

    if DATABASE[path_info] && DATABASE[path_info][query_params["screen_name"]]
      content_type, body = DATABASE[path_info][query_params["screen_name"]]
      response["Content-Type"] = content_type
      response.body = body
    end
    
    response
  end
  
  GQ_AMY_JSON = %{[{"in_reply_to_screen_name":null,"in_reply_to_user_id":null,"retweeted":false,"truncated":false,"created_at":"Fri Sep 10 03:09:14 +0000 2010","source":"web","retweet_count":null,"contributors":null,"favorited":false,"place":null,"geo":null,"user":{"listed_count":0,"contributors_enabled":false,"profile_sidebar_fill_color":"DDEEF6","description":"","geo_enabled":false,"url":null,"profile_use_background_image":true,"profile_sidebar_border_color":"C0DEED","lang":"en","verified":false,"created_at":"Fri Sep 10 02:12:16 +0000 2010","location":"","follow_request_sent":null,"profile_background_image_url":"http://s.twimg.com/a/1284159889/images/themes/theme1/bg.png","profile_background_color":"C0DEED","following":null,"profile_background_tile":false,"followers_count":0,"profile_text_color":"333333","protected":false,"profile_image_url":"http://s.twimg.com/a/1284076072/images/default_profile_6_normal.png","show_all_inline_media":false,"friends_count":0,"name":"gq_amy","statuses_count":3,"notifications":null,"profile_link_color":"0084B4","screen_name":"gq_amy","id":188985362,"time_zone":"Pacific Time (US & Canada)","utc_offset":-28800,"favourites_count":0},"in_reply_to_status_id":null,"id":24070724479,"coordinates":null,"text":"dog bit me"},{"in_reply_to_screen_name":null,"in_reply_to_user_id":null,"retweeted":false,"truncated":false,"created_at":"Fri Sep 10 03:08:38 +0000 2010","source":"web","retweet_count":null,"contributors":null,"favorited":false,"place":null,"geo":null,"user":{"listed_count":0,"contributors_enabled":false,"profile_sidebar_fill_color":"DDEEF6","description":"","geo_enabled":false,"url":null,"profile_use_background_image":true,"profile_sidebar_border_color":"C0DEED","lang":"en","verified":false,"created_at":"Fri Sep 10 02:12:16 +0000 2010","location":"","follow_request_sent":null,"profile_background_image_url":"http://s.twimg.com/a/1284159889/images/themes/theme1/bg.png","profile_background_color":"C0DEED","following":null,"profile_background_tile":false,"followers_count":0,"profile_text_color":"333333","protected":false,"profile_image_url":"http://s.twimg.com/a/1284076072/images/default_profile_6_normal.png","show_all_inline_media":false,"friends_count":0,"name":"gq_amy","statuses_count":3,"notifications":null,"profile_link_color":"0084B4","screen_name":"gq_amy","id":188985362,"time_zone":"Pacific Time (US & Canada)","utc_offset":-28800,"favourites_count":0},"in_reply_to_status_id":null,"id":24070679769,"coordinates":null,"text":"watching paint dry"},{"in_reply_to_screen_name":null,"in_reply_to_user_id":null,"retweeted":false,"truncated":false,"created_at":"Fri Sep 10 03:08:16 +0000 2010","source":"web","retweet_count":null,"contributors":null,"favorited":false,"place":null,"geo":null,"user":{"listed_count":0,"contributors_enabled":false,"profile_sidebar_fill_color":"DDEEF6","description":"","geo_enabled":false,"url":null,"profile_use_background_image":true,"profile_sidebar_border_color":"C0DEED","lang":"en","verified":false,"created_at":"Fri Sep 10 02:12:16 +0000 2010","location":"","follow_request_sent":null,"profile_background_image_url":"http://s.twimg.com/a/1284159889/images/themes/theme1/bg.png","profile_background_color":"C0DEED","following":null,"profile_background_tile":false,"followers_count":0,"profile_text_color":"333333","protected":false,"profile_image_url":"http://s.twimg.com/a/1284076072/images/default_profile_6_normal.png","show_all_inline_media":false,"friends_count":0,"name":"gq_amy","statuses_count":3,"notifications":null,"profile_link_color":"0084B4","screen_name":"gq_amy","id":188985362,"time_zone":"Pacific Time (US & Canada)","utc_offset":-28800,"favourites_count":0},"in_reply_to_status_id":null,"id":24070652683,"coordinates":null,"text":"i went to the store"}]}
  
  GQ_AMY_XML = %{<statuses type="array"> 
<status> 
  <created_at>Fri Sep 10 03:09:14 +0000 2010</created_at> 
  <id>24070724479</id> 
  <text>dog bit me</text> 
  <source>web</source> 
  <truncated>false</truncated> 
  <in_reply_to_status_id></in_reply_to_status_id> 
  <in_reply_to_user_id></in_reply_to_user_id> 
  <favorited>false</favorited> 
  <in_reply_to_screen_name></in_reply_to_screen_name> 
  <retweet_count></retweet_count> 
  <retweeted>false</retweeted> 
  <user> 
    <id>188985362</id> 
    <name>gq_amy</name> 
    <screen_name>gq_amy</screen_name> 
    <location></location> 
    <description></description> 
    <profile_image_url>http://s.twimg.com/a/1284076072/images/default_profile_6_normal.png</profile_image_url> 
    <url></url> 
    <protected>false</protected> 
    <followers_count>0</followers_count> 
    <profile_background_color>C0DEED</profile_background_color> 
    <profile_text_color>333333</profile_text_color> 
    <profile_link_color>0084B4</profile_link_color> 
    <profile_sidebar_fill_color>DDEEF6</profile_sidebar_fill_color> 
    <profile_sidebar_border_color>C0DEED</profile_sidebar_border_color> 
    <friends_count>0</friends_count> 
    <created_at>Fri Sep 10 02:12:16 +0000 2010</created_at> 
    <favourites_count>0</favourites_count> 
    <utc_offset>-28800</utc_offset> 
    <time_zone>Pacific Time (US &amp; Canada)</time_zone> 
    <profile_background_image_url>http://s.twimg.com/a/1284159889/images/themes/theme1/bg.png</profile_background_image_url> 
    <profile_background_tile>false</profile_background_tile> 
    <profile_use_background_image>true</profile_use_background_image> 
    <notifications></notifications> 
    <geo_enabled>false</geo_enabled> 
    <verified>false</verified> 
    <following></following> 
    <statuses_count>3</statuses_count> 
    <lang>en</lang> 
    <contributors_enabled>false</contributors_enabled> 
    <follow_request_sent></follow_request_sent> 
    <listed_count>0</listed_count> 
    <show_all_inline_media>false</show_all_inline_media> 
  </user> 
  <geo/> 
  <coordinates/> 
  <place/> 
  <contributors/> 
</status> 
<status> 
  <created_at>Fri Sep 10 03:08:38 +0000 2010</created_at> 
  <id>24070679769</id> 
  <text>watching paint dry</text> 
  <source>web</source> 
  <truncated>false</truncated> 
  <in_reply_to_status_id></in_reply_to_status_id> 
  <in_reply_to_user_id></in_reply_to_user_id> 
  <favorited>false</favorited> 
  <in_reply_to_screen_name></in_reply_to_screen_name> 
  <retweet_count></retweet_count> 
  <retweeted>false</retweeted> 
  <user> 
    <id>188985362</id> 
    <name>gq_amy</name> 
    <screen_name>gq_amy</screen_name> 
    <location></location> 
    <description></description> 
    <profile_image_url>http://s.twimg.com/a/1284076072/images/default_profile_6_normal.png</profile_image_url> 
    <url></url> 
    <protected>false</protected> 
    <followers_count>0</followers_count> 
    <profile_background_color>C0DEED</profile_background_color> 
    <profile_text_color>333333</profile_text_color> 
    <profile_link_color>0084B4</profile_link_color> 
    <profile_sidebar_fill_color>DDEEF6</profile_sidebar_fill_color> 
    <profile_sidebar_border_color>C0DEED</profile_sidebar_border_color> 
    <friends_count>0</friends_count> 
    <created_at>Fri Sep 10 02:12:16 +0000 2010</created_at> 
    <favourites_count>0</favourites_count> 
    <utc_offset>-28800</utc_offset> 
    <time_zone>Pacific Time (US &amp; Canada)</time_zone> 
    <profile_background_image_url>http://s.twimg.com/a/1284159889/images/themes/theme1/bg.png</profile_background_image_url> 
    <profile_background_tile>false</profile_background_tile> 
    <profile_use_background_image>true</profile_use_background_image> 
    <notifications></notifications> 
    <geo_enabled>false</geo_enabled> 
    <verified>false</verified> 
    <following></following> 
    <statuses_count>3</statuses_count> 
    <lang>en</lang> 
    <contributors_enabled>false</contributors_enabled> 
    <follow_request_sent></follow_request_sent> 
    <listed_count>0</listed_count> 
    <show_all_inline_media>false</show_all_inline_media> 
  </user> 
  <geo/> 
  <coordinates/> 
  <place/> 
  <contributors/> 
</status> 
<status> 
  <created_at>Fri Sep 10 03:08:16 +0000 2010</created_at> 
  <id>24070652683</id> 
  <text>i went to the store</text> 
  <source>web</source> 
  <truncated>false</truncated> 
  <in_reply_to_status_id></in_reply_to_status_id> 
  <in_reply_to_user_id></in_reply_to_user_id> 
  <favorited>false</favorited> 
  <in_reply_to_screen_name></in_reply_to_screen_name> 
  <retweet_count></retweet_count> 
  <retweeted>false</retweeted> 
  <user> 
    <id>188985362</id> 
    <name>gq_amy</name> 
    <screen_name>gq_amy</screen_name> 
    <location></location> 
    <description></description> 
    <profile_image_url>http://s.twimg.com/a/1284076072/images/default_profile_6_normal.png</profile_image_url> 
    <url></url> 
    <protected>false</protected> 
    <followers_count>0</followers_count> 
    <profile_background_color>C0DEED</profile_background_color> 
    <profile_text_color>333333</profile_text_color> 
    <profile_link_color>0084B4</profile_link_color> 
    <profile_sidebar_fill_color>DDEEF6</profile_sidebar_fill_color> 
    <profile_sidebar_border_color>C0DEED</profile_sidebar_border_color> 
    <friends_count>0</friends_count> 
    <created_at>Fri Sep 10 02:12:16 +0000 2010</created_at> 
    <favourites_count>0</favourites_count> 
    <utc_offset>-28800</utc_offset> 
    <time_zone>Pacific Time (US &amp; Canada)</time_zone> 
    <profile_background_image_url>http://s.twimg.com/a/1284159889/images/themes/theme1/bg.png</profile_background_image_url> 
    <profile_background_tile>false</profile_background_tile> 
    <profile_use_background_image>true</profile_use_background_image> 
    <notifications></notifications> 
    <geo_enabled>false</geo_enabled> 
    <verified>false</verified> 
    <following></following> 
    <statuses_count>3</statuses_count> 
    <lang>en</lang> 
    <contributors_enabled>false</contributors_enabled> 
    <follow_request_sent></follow_request_sent> 
    <listed_count>0</listed_count> 
    <show_all_inline_media>false</show_all_inline_media> 
  </user> 
  <geo/> 
  <coordinates/> 
  <place/> 
  <contributors/> 
</status> 
</statuses> }
  
  DATABASE = {
    "/1/statuses/user_timeline.json" => {
      "gq_amy" => ["application/json", GQ_AMY_JSON]
    },
    "/1/statuses/user_timeline.xml" => {
      "gq_amy" => ["text/xml", GQ_AMY_XML]
    }
  }
end