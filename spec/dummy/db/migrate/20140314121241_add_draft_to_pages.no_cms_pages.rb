# This migration comes from no_cms_pages (originally 20140314110439)
class AddDraftToPages < ActiveRecord::Migration
  def change
    add_column :no_cms_pages_page_translations, :draft, :boolean, default: false
  end
end
