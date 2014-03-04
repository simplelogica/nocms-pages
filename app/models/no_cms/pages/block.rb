module NoCms::Pages
  class Block < ActiveRecord::Base

    belongs_to :page

    translates :layout, :fields_info

    class Translation
      serialize :fields_info, Hash
    end

    after_initialize :set_blank_fields
    after_create :set_default_position
    before_save :save_related_objects

    validates :fields_info, presence: { allow_blank: true }
    validates :page, :layout, presence: true

    def layout_config
      NoCms::Pages.block_layouts.stringify_keys[layout]
    end

    def template
      layout_config[:template] if layout_config
    end

    def has_field? field
      !layout_config.nil? && !layout_config[:fields].symbolize_keys[field.to_sym].nil?
    end

    def field_type field
      return nil unless has_field?(field)
      layout_config[:fields].symbolize_keys[field.to_sym]
    end

    def read_field field
      fields_info[field.to_sym] if has_field?(field)
    end

    def write_field field, value
      return nil unless has_field?(field)
      field_type = field_type field
      # If field type is a symbol, then it's a simple type and we just save the value
      if field_type.is_a? Symbol
        fields_info[field.to_sym] = value
      else # If it's not a symbol then we create a new object or update the previous one
        fields_info[field.to_sym] ||= field_type.new
        fields_info[field.to_sym].assign_attributes value
      end
    end

    # In this missing method we check wether we're asking for one field
    # in which case we will read or write ir
    def method_missing(m, *args, &block)
      # We get the name of the field stripping out the '=' for writers
      field = m.to_s
      write_accessor = field.ends_with? '='
      field.gsub!(/\=$/, '')

      # If this field actually exists, then we write it or read it.
      if has_field?(field)
        write_accessor ?
          write_field(field, args.first) :
          read_field(field.to_sym)
      else
        super
      end
    end

    # When we are assigning attributes (this method is called in new, create...)
    # we must split those fields from our current layout and those who are not
    # (they must be attributes).
    # Attributes are processed the usual way and fields are written later
    def assign_attributes new_attributes
      fields = []

      set_blank_fields

      # We get the layout
      new_layout = new_attributes[:layout] || new_attributes['layout']
      self.layout = new_layout unless new_layout.nil?

      # And now separate fields and attributes
      fields = new_attributes.select{|k, _| has_field? k }.symbolize_keys
      new_attributes.reject!{|k, _| has_field? k }

      super(new_attributes)

      fields.each do |field_name, value|
        self.write_field field_name, value
      end

    end

    private

    def set_blank_fields
      self.fields_info ||= {}
    end

    def set_default_position
      self.update_attribute :position, ((page.blocks.pluck(:position).compact.max || 0) + 1) if self.position.blank?
    end

    def save_related_objects
      fields_info.each do |field_id, object|
        if object.is_a?(ActiveRecord::Base)
          object.save!
        end
      end
    end
  end
end
