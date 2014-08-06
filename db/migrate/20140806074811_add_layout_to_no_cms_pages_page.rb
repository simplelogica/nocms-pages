class AddLayoutToNoCmsPagesPage < ActiveRecord::Migration
  def change
    add_column :no_cms_pages_pages, :layout, :string
  end
end
