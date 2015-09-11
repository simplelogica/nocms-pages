# This migration comes from no_cms_blocks (originally 20150709132202)
class AddNonTranslatedFieldsInfoToNoCmsBlocksBlock < ActiveRecord::Migration
  def change
    add_column :no_cms_blocks_blocks, :fields_info, :longtext
  end
end
