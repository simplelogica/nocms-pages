# This migration comes from no_cms_pages (originally 20140806074811)
class AddLayoutToNoCmsPagesPage < ActiveRecord::Migration
  def change
    add_column :no_cms_pages_pages, :layout, :string
  end
end
