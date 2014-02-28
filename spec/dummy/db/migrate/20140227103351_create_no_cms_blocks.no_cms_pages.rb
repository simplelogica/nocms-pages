# This migration comes from no_cms_pages (originally 20140227100626)
class CreateNoCmsBlocks < ActiveRecord::Migration
  def change
    create_table :no_cms_pages_blocks do |t|
      t.belongs_to :page, index: true

      t.timestamps
    end

    create_table :no_cms_pages_block_translations do |t|
      t.belongs_to :no_cms_pages_block, index: true
      t.string :locale
      t.string :layout
    end

  end
end
