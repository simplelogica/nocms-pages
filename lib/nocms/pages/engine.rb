module NoCMS
  module Pages
    class Engine < ::Rails::Engine
      isolate_namespace NoCMS::Pages
    end
  end
end
