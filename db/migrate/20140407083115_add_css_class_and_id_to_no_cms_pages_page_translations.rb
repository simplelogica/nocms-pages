class AddCssClassAndIdToNoCmsPagesPageTranslations < ActiveRecord::Migration
  def change
    add_column :no_cms_pages_page_translations, :css_class, :string
    add_column :no_cms_pages_page_translations, :css_id, :string
  end
end
