module NoCms
  module Pages
    class Engine < ::Rails::Engine
      isolate_namespace NoCms::Pages
    end
  end
end
