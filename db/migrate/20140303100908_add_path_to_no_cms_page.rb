class AddPathToNoCmsPage < ActiveRecord::Migration
  def change
    add_column :no_cms_pages_page_translations, :path, :string
  end
end
