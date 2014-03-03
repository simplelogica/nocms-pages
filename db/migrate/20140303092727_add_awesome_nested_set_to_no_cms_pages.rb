class AddAwesomeNestedSetToNoCmsPages < ActiveRecord::Migration
  def change
    add_column :no_cms_pages_pages, :parent_id, :integer
    add_column :no_cms_pages_pages, :lft, :integer
    add_column :no_cms_pages_pages, :rgt, :integer
    add_column :no_cms_pages_pages, :depth, :integer
  end
end
