# This migration comes from no_cms_pages (originally 20140303100908)
class AddPathToNoCmsPage < ActiveRecord::Migration
  def change
    add_column :no_cms_pages_page_translations, :path, :string
  end
end
