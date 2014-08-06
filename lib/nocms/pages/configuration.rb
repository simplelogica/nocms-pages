module NoCms
  module Pages
    include ActiveSupport::Configurable

    config_accessor :block_layouts
    config_accessor :page_layouts
    config_accessor :use_body
    config_accessor :cache_enabled

    self.use_body = false
    self.cache_enabled = false
    self.block_layouts = {
      'default' => {
        template: 'default',
        fields: {
          title: :string,
          body: :text
        }
      }
    }

    self.page_layouts = []

    def self.use_body?
      use_body
    end

  end
end
