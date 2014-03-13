# This migration comes from no_cms_pages (originally 20140313171000)
class AddDraftToBlock < ActiveRecord::Migration
  def change
    add_column :no_cms_pages_block_translations, :draft, :boolean, default: false
  end
end
