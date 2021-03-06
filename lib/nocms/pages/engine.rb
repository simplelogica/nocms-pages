require 'globalize'
require 'nocms-blocks'
require 'awesome_nested_set'

module NoCms
  module Pages
    class Engine < ::Rails::Engine
      isolate_namespace NoCms::Pages

      config.to_prepare do
        Dir.glob(NoCms::Pages::Engine.root + "app/decorators/**/*_decorator*.rb").each do |c|
          require_dependency(c)
        end
      end
    end
  end
end
