# This migration comes from no_cms_pages (originally 20140228112643)
class AddSlugToNoCmsPage < ActiveRecord::Migration
  def change
    add_column :no_cms_pages_page_translations, :slug, :string
  end
end
