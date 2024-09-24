module Rulers
  class Application
    class RouteObject
      def initialize
        @rules = []
      end

      def match(url, *args)
        options = {}
        options = args.pop if args[-1].is_a?(Hash)
        options[:default] ||= {}
        dest = nil
        dest = args.pop if args.size > 0
        raise "Too many args" if args.size > 0

        parts = url.split("/")
        parts.select! { |p| !p.empty? }

        vars = []

        regexp_parts = parts.map do |part|
          if part[0] == ":"
            vars << part[1..]
            "([a-zA-Z0-9]+)"
          elsif part[0] == "*"
            vars << part[1..]
            "(.*)"
          else
            part
          end
        end

        regexp = regexp_parts.join("/")

        @rules.push({
                      regexp: Regexp.new("^/#{regexp}$"),
                      vars: vars,
                      dest: dest,
                      options: options
                    })
      end

      def check_url(url)
        @rules.each do |r|
          m = r[:regexp].match(url)

          next unless m
          puts "Matched rule: #{r.inspect} on #{url}"
          puts "Match data: #{m.inspect}"

          options = r[:options]
          puts "Options: #{options}"
          params = options[:default].dup

          r[:vars].each_with_index do |v, i|
            params[v] = m.captures[i]
          end

          puts "Params: #{params}"

          puts "Routed to: #{r[:dest]}" if r[:dest]
          return get_dest(r[:dest], params) if r[:dest]

          puts "No destination"
          controller = params["controller"]
          action = params["action"]

          puts "Mapping to:  #{controller}##{action}"
          return get_dest("#{controller}##{action}", params)
        end
        nil
      end

      def get_dest(dest, routing_params = {})
        return dest if dest.respond_to?(:call)

        if dest =~ /^([^#]+)#([^#]+)$/
          name = ::Regexp.last_match(1).capitalize
          con = Object.const_get("#{name}Controller")
          return con.action(::Regexp.last_match(2), routing_params)
        end

        raise "No destination: #{dest.inspect}"
      end
    end
  end
end
