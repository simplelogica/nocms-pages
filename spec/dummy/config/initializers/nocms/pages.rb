NoCms::Pages.configure do |config|

  # Enable Rails fragment cache for the block templates when you call the render_block helper
  # You can override this cache setting in any block configuration below or sending
  # the cache option true or false when calling the menu helpers
  # e.g: render_block block, cache: true
  # config.cache_enabled = false

  # In this section we configure block layouts. It's just an array of layouts, each consisting on a hash.
  # Each layout has a template and a list of fields with a type.
  # E.g: config.block_layouts = {
  #   'title-long_text' => {
  #     template: 'title-long_text',
  #     fields: {
  #       title: :string,
  #       long_text: :text
  #     }
  #   },
  #   'title-3_columns_text' => {
  #     template: 'title-3_columns_text',
  #     fields: {
  #       title: :string,
  #       column_1: :text,
  #       column_2: :text,
  #       column_3: :text
  #     }
  #   }
  # }
  # config.block_layouts = {}

  # By default we use all the layouts in the app/views/layouts from the app
  # config.page_layouts = ['application', ...]

  config.use_body = true

end
