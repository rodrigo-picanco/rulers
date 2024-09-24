require "erubis"
require "rack/request"
require "rulers/file_model"

module Rulers
  class Controller
    include Rulers::Model
    def initialize(env)
      @env = env
      @routing_params = {}
    end

    attr_reader :env

    def dispatch(action, routing_params = {})
      @routing_params = routing_params
      text = send(action)
      r = get_response

      puts "Action: #{action}, params: #{routing_params}"
      puts "Response: #{r}"
      puts "Text: #{text}"
      if r
        [r.status, r.headers, [r.body].flatten]
      else
        [200, { "Content-Type" => "text/html" }, [text].flatten]
      end
    end

    def self.action(act, rp = {})
      proc { |e| new(e).dispatch(act, rp) }
    end

    def params
      request.params.merge @routing_params
    end

    def render(view_name, locals = {})
      filename = File.join "app", "views", controller_name, "#{view_name}.html.erb"
      template = File.read filename
      eruby = Erubis::Eruby.new(template)
      variables = instance_variables.each_with_object({}) do |variable, hash|
        hash[variable] = instance_variable_get variable
      end
      response(eruby.result(locals.merge(env: env).merge(variables)))
    end

    def get_response
      @response
    end

    def response(text, status = 200, headers = {})
      raise "Already responded!" if @response

      @response ||= Rack::Response.new([text].flatten, status, headers)
    end

    def controller_name
      klass = self.class
      klass = klass.to_s.gsub(/Controller$/, "")
      Rulers.to_underscore klass
    end

    def request
      @request ||= Rack::Request.new(@env)
    end

    def params
      request.params
    end
  end
end
