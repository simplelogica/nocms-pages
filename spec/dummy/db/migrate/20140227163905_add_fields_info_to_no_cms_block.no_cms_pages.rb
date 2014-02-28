# This migration comes from no_cms_pages (originally 20140227143723)
class AddFieldsInfoToNoCmsBlock < ActiveRecord::Migration
  def change
    add_column :no_cms_pages_block_translations, :fields_info, :longtext, default: Hash.new.to_yaml
  end
end
