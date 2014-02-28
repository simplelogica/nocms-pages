class AddSlugToNoCmsPage < ActiveRecord::Migration
  def change
    add_column :no_cms_pages_page_translations, :slug, :string
  end
end
