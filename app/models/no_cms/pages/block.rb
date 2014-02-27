module NoCMS::Pages
  class Block < ActiveRecord::Base

    belongs_to :page

    translates :layout

    validates :page, :layout, presence: true

    def layout_config
      NoCMS::Pages.block_layouts.stringify_keys[layout]
    end

    def method_missing(m, *args, &block)
      layout_fields = layout_config[:fields]

      if layout_fields[m]
        m
      else
        super
      end
    end

  end
end
