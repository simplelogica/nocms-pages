# This migration comes from no_cms_pages (originally 20140303145615)
class AddTemplateToNoCmsPage < ActiveRecord::Migration
  def change
    add_column :no_cms_pages_pages, :template, :string
  end
end
