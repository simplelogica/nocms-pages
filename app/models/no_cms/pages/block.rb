module NoCms::Pages
  class Block < ActiveRecord::Base

    belongs_to :page

    translates :layout, :fields_info

    class Translation
      serialize :fields_info, Hash
    end

    after_initialize :set_blank_fields

    def assign_attributes new_attributes
      fields = []

      set_blank_fields

      new_layout = new_attributes[:layout] || new_attributes['layout']
      self.layout = new_layout unless new_layout.nil?
      fields = new_attributes.select{|k, _| has_field? k }.symbolize_keys
      new_attributes.reject!{|k, _| has_field? k }

      super(new_attributes)

      fields.each do |field_name, value|
        self.write_field field_name, value
      end

    end

    validates :fields_info, presence: { allow_blank: true }
    validates :page, :layout, presence: true

    def layout_config
      NoCms::Pages.block_layouts.stringify_keys[layout]
    end

    def method_missing(m, *args, &block)
      field = m.to_s
      write_accessor = field.ends_with? '='
      field.gsub!(/\=$/, '')

      if has_field?(field)
        write_accessor ?
          write_field(field, args.first) :
          read_field(field.to_sym)
      else
        super
      end
    end

    def has_field? field
      !layout_config.nil? && !layout_config[:fields].symbolize_keys[field.to_sym].nil?
    end

    def read_field field
      fields_info[field.to_sym] if has_field?(field)
    end

    def write_field field, value
      fields_info[field.to_sym] = value if has_field?(field)
    end

    private

    def set_blank_fields
      self.fields_info ||= {}
    end
  end
end
