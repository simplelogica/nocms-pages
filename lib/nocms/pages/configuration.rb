module NoCms
  module Pages
    include ActiveSupport::Configurable

    config_accessor :block_layouts
    config_accessor :use_body

    self.use_body = false
    self.block_layouts = {
      'default' => {
        template: 'default',
        fields: {
          title: :string,
          body: :text
        }
      }
    }

  end
end
