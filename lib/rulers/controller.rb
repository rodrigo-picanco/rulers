require "erubis"
require "rulers/file_model"

module Rulers
  class Controller
    include Rulers::Model
    def initialize(env)
      @env = env
    end

    attr_reader :env

    def render(view_name, locals = {})
      filename = File.join "app", "views", controller_name, "#{view_name}.html.erb"
      template = File.read filename
      eruby = Erubis::Eruby.new(template)

      eruby.result locals.merge(env: env).merge(variables)
    end

    def variables
      instance_variables.each_with_object({}) do |variable, hash|
        hash[variable] = instance_variable_get variable
      end
    end

    def controller_name
      klass = self.class
      klass = klass.to_s.gsub(/Controller$/, "")
      Rulers.to_underscore klass
    end
  end
end
