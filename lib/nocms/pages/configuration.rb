module NoCMS
  module Pages
    include ActiveSupport::Configurable

    config_accessor :block_layouts

    self.block_layouts = {}

  end
end
