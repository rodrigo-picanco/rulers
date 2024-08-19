require "rulers/version"
require "rulers/array"
require "rulers/routing"
require "rulers/render"
require "rulers/errors"
require "rulers/utils"
require "rulers/dependencies"
require "rulers/controller"
require "rulers/file_model"

module Rulers
  class Application
    def call(env)
      return [404, { "Content-Type" => "text/html" }, []] if env["PATH_INFO"] == "/favicon.ico"
      return [200, {}, [html("public/index.html")]] if env["PATH_INFO"] == "/"

      klass, act = get_controller_and_action(env)
      controller = klass.new(env)
      text = controller.send(act)
      [200, { "Content-Type" => "text/html" }, [text]]
    end
  end

  def self.framework_root
    __dir__
  end
end
