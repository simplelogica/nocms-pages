class AddFieldsInfoToNoCmsBlock < ActiveRecord::Migration
  def change
    add_column :no_cms_pages_block_translations, :fields_info, :longtext
  end
end
