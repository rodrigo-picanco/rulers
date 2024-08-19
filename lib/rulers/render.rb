module Rulers
  class Application
    def html(path)
      File.read(File.expand_path(path))
    end
  end
end
