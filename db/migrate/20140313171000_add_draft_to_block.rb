class AddDraftToBlock < ActiveRecord::Migration
  def change
    add_column :no_cms_pages_block_translations, :draft, :boolean, default: false
  end
end
