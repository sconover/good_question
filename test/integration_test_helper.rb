require "./test/test_helper"
require "rack/client"
require "json"
require "nokogiri"

unless Object.new.respond_to?(:instance_exec) #true for 1.8.7, 1.9.  false for 1.8.6
  #see http://eigenclass.org/hiki.rb?instance_exec
  class Object
    module InstanceExecHelper; end
    include InstanceExecHelper
    def instance_exec(*args, &block) # !> method redefined; discarding old instance_exec
      mname = "__instance_exec_#{Thread.current.object_id.abs}_#{object_id.abs}"
      InstanceExecHelper.module_eval{ define_method(mname, &block) }
      begin
        ret = send(mname, *args)
      ensure
        InstanceExecHelper.module_eval{ undef_method(mname) } rescue nil
      end
      ret
    end
  end
end

module HttpTestMethods
  def perform_GET(path_query)
    response = exec_request({
      "REQUEST_METHOD" => "GET",
      "SERVER_NAME" => "api.twitter.com",
      "SERVER_PORT" => "80",
      "PATH_INFO" => path_query
    })
    
    if response.headers["Content-Type"].include?("json")
      JSON.parse(response.body.join)
    elsif response.headers["Content-Type"].include?("xml")
      Nokogiri::XML(response.body.join)
    else
      raise "don't know what to do with #{response.headers["Content-Type"]}"
    end
  end

  def exec_request(env)
    Rack::Client.new.call(env)[2]
  end

end

class MiniTest::Spec
  class << self
    
    def test_GET(path_query, &block)
      test(path_query) do
        extend HttpTestMethods
        self.instance_exec(perform_GET(path_query), &block)
      end
    end
  
  end
end

class Nokogiri::XML::NodeSet
  def texts
    collect{|node|node.text}
  end
end