NoCms::Pages.configure do |config|

  # In this section we configure block layouts. It's just an array of layouts, each consisting on a hash.
  # Each layout has a series of options
  # E.g: config.block_layouts = {
  #   'title-long_text' => {
  #     template: 'title-long_text', # This is the template of this block,
  #                                  # used as a partial both in the front
  #                                  # and the admin (if you use the nocms-admin-pages gem)
  #     fields: { # This is the list of fields a block with this layout would have
  #       title: :string,
  #       long_text: :text,
  #       image: Image, # You may use another ActiveRecord classes of your own
  #     }
  #    allow_nested_blocks: true, # A block with this layout may include a list of nested blocks
  #                               # This setting is actually used by nocms-admin-pages gem to show
  #                               # nested forms
  #    nest_levels: [0] # Some layout may not be nestable, or useful only in certain nesting level
  #                     # Once again, this setting is used by nocms-admin-pages gem to hide certain
  #                     # in nested blocks. When blank, it's assumed there's no restriction.
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

end
