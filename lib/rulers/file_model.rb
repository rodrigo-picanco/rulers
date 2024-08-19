require "multi_json"

module Rulers
  module Model
    class FileModel
      def initialize(filename, attrs)
        @filename = filename
        basename = File.split(filename)[-1]
        @id = File.basename(basename, ".json").to_i
        @hash = MultiJson.load(MultiJson.dump(attrs))
      end

      def [](name)
        @hash[name.to_s]
      end

      def []=(name, value)
        @hash[name.to_s] = value
      end

      def self.find(id)
        FileModel.new("db/quotes/#{id}.json", MultiJson.load(File.read("db/quotes/#{id}.json")))
      rescue StandardError
        nil
      end

      def self.all
        files = Dir["db/quotes/*.json"]
        files.map { |f| FileModel.new f, MultiJson.load(File.read(f)) }
      end

      def self.create(attrs)
        id = Dir["db/quotes/*.json"].map { |f| File.split(f)[-1] }.map(&:to_i).max + 1
        obj = FileModel.new "db/quotes/#{id}.json", attrs
        obj.save
        obj
      end

      def self.update(id, attrs)
        obj = find(id)
        attrs.each { |key, value| obj[key] = value }
        obj.save
        obj
      end

      def self.where(attrs)
        all.find { |o|  attrs.map { |key, value| o[key] = value }.reduce {|a, b| a && b } }
      end

      def save
        File.open(instance_variable_get("@filename"), "w") do |f|
          f.write MultiJson.dump(@hash)
        end
      end
    end
  end
end
