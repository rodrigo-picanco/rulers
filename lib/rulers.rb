require "rulers/version"
require "rulers/array"
require "rulers/routing"
require "rulers/errors"
require "rulers/utils"
require "rulers/dependencies"
require "rulers/controller"
require "rulers/file_model"

module Rulers
  class Application
    def call(env)
      return [404, { "Content-Type" => "text/html" }, []] if env["PATH_INFO"] == "/favicon.ico"

      get_rack_app(env).call(env)
    end

    def route(&block)
      @route_obj ||= RouteObject.new
      @route_obj.instance_eval(&block)
    end

    def get_rack_app(env)
      raise "No routes!" unless @route_obj

      @route_obj.check_url env["PATH_INFO"]
    end
  end

  def self.framework_root
    __dir__
  end
end
