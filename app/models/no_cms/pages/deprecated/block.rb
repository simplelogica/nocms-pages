class NoCms::Pages::Deprecated::Block < ActiveRecord::Base

  self.table_name = "no_cms_pages_blocks"


  belongs_to :page
  belongs_to :parent, class_name: "NoCms::Pages::Deprecated::Block"
  has_many :children, class_name: "NoCms::Pages::Deprecated::Block", foreign_key: 'parent_id', inverse_of: :parent, dependent: :destroy

  scope :roots, ->() { where parent_id: nil }

  translates :layout, :fields_info, :draft

  class Translation
    self.table_name = "no_cms_pages_block_translations"
    serialize :fields_info, Hash
  end

  def readonly?
    true
  end

  def position
    self[:position] || 0
  end

  def self.dump
    roots.map(&:dump)
  end

  def dump
    {
      page: page,
      position: position,
      children: children.map(&:dump),
      translations: Hash[translations.map{|t| [t.locale, {
        layout: t.layout,
        draft: t.draft,
        fields_info: t.fields_info.to_hash
        }]}]

    }
  end

end
