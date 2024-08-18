require "rulers/version"
require "rulers/array"

module Rulers
  class Application
    def call(_env)
      `echo debug > debug.txt`
      [200, { "Content-Type" => "text/html" }, ["Hello from rulers"]]
    end
  end
end
