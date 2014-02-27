module NoCMS::Pages
  class Block < ActiveRecord::Base

    belongs_to :page

    translates :layout, :fields_info


    after_initialize :set_blank_fields

    class Translation
      serialize :fields_info, Hash
    end

    validates :fields_info, presence: { allow_blank: true }
    validates :page, :layout, presence: true

    def layout_config
      NoCMS::Pages.block_layouts.stringify_keys[layout]
    end

    def method_missing(m, *args, &block)
      field = m.to_s

      write_accessor = field.ends_with? '='
      field.gsub!(/\=$/, '')

      if has_field?(field)
        write_accessor ?
          write_field(field, args.first) :
          read_field(field)
      else
        super
      end
    end

    def has_field? field
      !layout_config.nil? && !layout_config[:fields].symbolize_keys[field.to_sym].nil?
    end

    def read_field field
      fields_info[field] if has_field?(field)
    end

    def write_field field, value
      fields_info[field] = value if has_field?(field)
    end

    private

    def set_blank_fields
      self.fields_info = {}
    end
  end
end
