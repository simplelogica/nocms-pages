class DestroyNoCmsPagesBlocks < ActiveRecord::Migration
  def change
    drop_table :no_cms_pages_blocks
  end
end
