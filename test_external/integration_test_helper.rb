require "./test/test_helper"
require "rack/client"
require "json"
require "nokogiri"

require 'net/http'
require 'net/https'

module Rack
  module Client
    module Handler
      class NetHTTP

        def connection_for(request)
          connection = Net::HTTP.new(request.host, request.port)

          if request.scheme == 'https'
            connection.use_ssl = true
            connection.verify_mode = OpenSSL::SSL::VERIFY_NONE
          end
          
          #connection.set_debug_output $stderr
          
          connection.start
          connection
        end

      end
    end
  end
end


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
  def check_rack_client
    raise %{you need to define a method called rack_client.  ex:
      def rack_client
        Rack::Client.new("http://api.twitter.com")
      end
    } unless self.respond_to?(:rack_client)
  end
  
  def GET(path_query, headers={})
    check_rack_client
    
    response = rack_client.get(path_query, headers, query_params_not_used={})
    transform_response(response)    
  end
  
  def POST(path_query, headers={}, params={})
    check_rack_client
    
    response = rack_client.post(path_query, headers, params)
    transform_response(response)        
  end

  def transform_response(response)
    full_body = response.body.join
    
    parsed_body = 
      if response.headers["Content-Type"].include?("json")
        JSON.parse(full_body)
      elsif response.headers["Content-Type"].include?("xml")
        Nokogiri::XML(full_body)
      elsif response.headers["Content-Type"].include?("html")
        Nokogiri::HTML(full_body)
      else
        full_body
      end
    [parsed_body, response.headers, response.status]
  end

end

class MiniTest::Spec
  include HttpTestMethods
  
  class << self
    
    def test_GET(*args, &block)
      
      path_query = args[0]
      request_headers = {}
      extra_description = nil
      if args.length == 2
        if args[1].is_a?(String)
          extra_description = args[1]
        else
          request_headers = args[1]
        end
      end
      if args.length == 3
        request_headers = args[1]
        extra_description = args[2]
      end

      test_title = ""
      test_title << extra_description + " " if extra_description
      test_title << path_query
      
      test(test_title) do
        body, headers, code = GET(path_query, request_headers)
        if block.arity == 1
          self.instance_exec(body, &block)
        elsif block.arity == 2
          self.instance_exec(body, headers, &block)
        elsif block.arity == 3
          self.instance_exec(body, headers, code, &block)
        end
      end
    end
  
  end
end

class Nokogiri::XML::NodeSet
  def texts
    collect{|node|node.text}
  end
end