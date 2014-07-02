class AddCacheEnabledToNoCmsPagesPageTranslations < ActiveRecord::Migration
  def change
    add_column :no_cms_pages_page_translations, :cache_enabled, :boolean, default: true
  end
end
