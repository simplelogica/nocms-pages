class AddDraftToPages < ActiveRecord::Migration
  def change
    add_column :no_cms_pages_page_translations, :draft, :boolean, default: false
  end
end
