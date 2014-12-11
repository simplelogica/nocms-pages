require 'globalize'
require 'nocms-blocks'
require 'awesome_nested_set'

module NoCms
  module Pages
    class Engine < ::Rails::Engine
      isolate_namespace NoCms::Pages
    end
  end
end
