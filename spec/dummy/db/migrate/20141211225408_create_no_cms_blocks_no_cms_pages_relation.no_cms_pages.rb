# This migration comes from no_cms_pages (originally 20141211225243)
class CreateNoCmsBlocksNoCmsPagesRelation < ActiveRecord::Migration
  def change
    create_table :no_cms_blocks_blocks_pages_pages, id: false do |t|

      t.belongs_to :page
      t.belongs_to :block

      t.timestamps
    end
  end
end
