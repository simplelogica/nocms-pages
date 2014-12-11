# This migration comes from no_cms_pages (originally 20141211224348)
class DestroyNoCmsPagesBlocks < ActiveRecord::Migration
  def change
    drop_table :no_cms_pages_blocks
  end
end
