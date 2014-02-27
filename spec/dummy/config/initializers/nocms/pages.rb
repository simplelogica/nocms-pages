NoCMS::Pages.configure do |config|

  # In this section we configure block layouts. It's just an array of layouts, each consisting on a hash.
  # Each layout has a template and a list of fields with a type.
  # E.g: config.block_layouts = [
  #   {
  #     template: 'title-long_text',
  #     fields: {
  #       title: :string,
  #       long_text: :text
  #     }
  #   },
  #   {
  #     template: 'title-3_columns_text',
  #     fields: {
  #       title: :string,
  #       column_1: :text,
  #       column_2: :text,
  #       column_3: :text
  #     }
  #   }
  # ]
  # config.block_layouts = []

end
