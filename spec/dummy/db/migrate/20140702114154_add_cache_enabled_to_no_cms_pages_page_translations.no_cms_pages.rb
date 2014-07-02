# This migration comes from no_cms_pages (originally 20140702112813)
class AddCacheEnabledToNoCmsPagesPageTranslations < ActiveRecord::Migration
  def change
    add_column :no_cms_pages_page_translations, :cache_enabled, :boolean, default: true
  end
end
