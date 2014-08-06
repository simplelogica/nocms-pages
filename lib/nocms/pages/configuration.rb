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

    # By default, page layouts are every layout in the app/views/layouts on the Rails app (partials are excluded)
    self.page_layouts = Dir["#{Rails.root}/app/views/layouts/*.html.erb"]. # We get all the files in app/views/layouts
      map { |f| File.basename(f, '.html.erb') }. # Get the name without any extension
      reject {|l| l.starts_with? '_'}. # reject partials
      sort # and sort

    def self.use_body?
      use_body
    end

  end
end
